import 'package:flutter/material.dart';
import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:dbestudante/disciplina_dao.dart';
import 'package:dbestudante/cursando_dao.dart';

class Pag1 extends StatefulWidget {
  const Pag1({super.key});

  @override
  State<Pag1> createState() => _Pag1State();
}

class _Pag1State extends State<Pag1> {
  final _estudanteDao = EstudanteDao();
  final _disciplinaDao = DisciplinaDao();
  final _cursandoDao = CursandoDao();

  final _controllerNome = TextEditingController();
  final _controllerMatricula = TextEditingController();

  List<Estudante> _listaEstudantes = [];
  Estudante? _estudanteAtual;

  @override
  void initState() {
    super.initState();
    _loadEstudantes();
  }


  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> _loadEstudantes() async {
    final lista = await _estudanteDao.listarEstudantes();
    setState(() {
      _listaEstudantes = lista;
    });
  }


  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> _salvarOuEditar() async {
    final nome = _controllerNome.text.trim();
    final matricula = _controllerMatricula.text.trim();

    if (nome.isEmpty || matricula.isEmpty) return;

    if (_estudanteAtual == null) {
      await _estudanteDao.incluirEstudante(Estudante(nome: nome, matricula: matricula));
    } else {
      _estudanteAtual!.nome = nome;
      _estudanteAtual!.matricula = matricula;
      await _estudanteDao.editarEstudante(_estudanteAtual!);
    }

    _controllerNome.clear();
    _controllerMatricula.clear();
    _estudanteAtual = null;
    await _loadEstudantes();
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> _apagarEstudante(int id) async {
    await _estudanteDao.deleteEstudante(id);
    await _loadEstudantes();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> _mostrarDisciplinasDoEstudante(Estudante estudante) async {
    final disciplinas = await _cursandoDao.listarDisciplinasDoEstudante(estudante.id!);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Disciplinas de ${estudante.nome}'),
        content: disciplinas.isEmpty
            ? Text("Nenhuma disciplina encontrada.")
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: disciplinas
                    .map((d) => Text("${d['nome']} - ${d['professor']}"))
                    .toList(),
              ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Fechar'))
        ],
      ),
    );
  }

  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudantes'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerNome,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _controllerMatricula,
              decoration: InputDecoration(labelText: 'Matrícula'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _salvarOuEditar,
              child: Text(_estudanteAtual == null ? 'Salvar' : 'Atualizar'), // help
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _listaEstudantes.length,
                itemBuilder: (context, index) {
                  final estudante = _listaEstudantes[index];
                  return Card(
                    child: ListTile(
                      title: Text(estudante.nome),
                      subtitle: Text('Matrícula: ${estudante.matricula}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _apagarEstudante(estudante.id!),
                      ),
                      onTap: () {
                        setState(() {
                          _estudanteAtual = estudante;
                          _controllerNome.text = estudante.nome;
                          _controllerMatricula.text = estudante.matricula;
                        });
                        _mostrarDisciplinasDoEstudante(estudante);
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
