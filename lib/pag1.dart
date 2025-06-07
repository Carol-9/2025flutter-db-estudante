import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:dbestudante/disciplina_dao.dart';
import 'package:flutter/material.dart';

class pag1 extends StatefulWidget {
  const pag1({super.key});

  @override
  State<pag1> createState() => _pag1State();
}

class _pag1State extends State<pag1> {
  final _estudanteDAO = EstudanteDao();
  final _disciplinaDAO = DisciplinaDao();
  Estudante? _estudanteAtual;

  final _controllerNome = TextEditingController();
  final _controllerMatricula = TextEditingController();
  List<Estudante> _listaEstudantes = [
    Estudante(nome: "Fulano", matricula: "123456"),
    Estudante(nome: "Ciclano", matricula: "789123"),
    Estudante(nome: "Jorge", matricula: "7654321")
  ];

  // List <Disciplina> _listaDisciplina = [
  //   Disciplina(nome: "Matematica", professor: "Prof. Victor"),
  //   Disciplina(nome: "Portugues", professor: "Prof. Victor"),
  //   Disciplina(nome: "Historia", professor: "Prof. Victor"),
  // ];

  @override
  void initState() {
    _loadEstudantes();
    super.initState();
  }
  
  @override
  void initState2(){
    _loadDisciplina();
    super.initState();
  }

  _loadEstudantes() async {
    List<Estudante> temp = await _estudanteDAO.listarEstudantes();
    setState(() {
      _listaEstudantes = temp;
    });
  }
  
_loadDisciplina() async {
    List<Disciplina> temp = await _disciplinaDAO.listarDisciplina();
    setState(() {
      // _listaDisciplina = temp;
    });
  }


  _salvarOUEditar() async {
    if (_estudanteAtual == null) {
      //novo estudante
      await _estudanteDAO.incluirEstudante(Estudante(
          nome: _controllerNome.text, matricula: _controllerMatricula.text));
    } else {
      //atualizar estudante
      _estudanteAtual!.nome = _controllerNome.text;
      _estudanteAtual!.matricula = _controllerMatricula.text;
      await _estudanteDAO.editarEstudante(_estudanteAtual!);
    }
    _controllerNome.clear();
    _controllerMatricula.clear();
    setState(() {
      _loadEstudantes();
      _estudanteAtual = null;
    });
  }

  _apagarEstudante(int index) async {
    await _estudanteDAO.deleteEstudante(index);
    _loadEstudantes();
  }

  _editarEstudante(Estudante e) async {
    await _estudanteDAO.editarEstudante(e);
    _loadEstudantes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Estudante"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerNome,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerMatricula,
              decoration: InputDecoration(
                labelText: "Matricula",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                _salvarOUEditar();
              },
              child:
                  _estudanteAtual == null ? Text("Salvar") : Text("Atualizar"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaEstudantes.length,
              itemBuilder: (context, index) {
                //colocar a logica para criar cada item a partir da lista Estudantes
                return ListTile(
                  title: Text(_listaEstudantes[index].nome),
                  subtitle: Text(_listaEstudantes[index].matricula),
                  trailing: IconButton(
                    onPressed: () {
                      _apagarEstudante(_listaEstudantes[index].id!);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  onTap: () {
                    setState(() {
                      _estudanteAtual = _listaEstudantes[index];
                      _controllerNome.text = _estudanteAtual!.nome;
                      _controllerMatricula.text = _estudanteAtual!.matricula;
                      _editarEstudante(_estudanteAtual!);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
