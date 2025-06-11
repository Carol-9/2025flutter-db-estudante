import 'package:sqflite/sqflite.dart';
import 'package:dbestudante/DatabaseHelper.dart';

class CursandoDao {
  final Databasehelper _dbHelper = Databasehelper();

  Future<void> associarEstudanteDisciplina(int idEstudante, int idDisciplina) async {
    final db = await _dbHelper.database;
    await db.insert('cursando', {
      'id_estudante': idEstudante,
      'id_disciplina': idDisciplina,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> desassociarEstudanteDisciplina(int idEstudante, int idDisciplina) async {
    final db = await _dbHelper.database;
    await db.delete(
      'cursando',
      where: 'id_estudante = ? AND id_disciplina = ?',
      whereArgs: [idEstudante, idDisciplina],
    );
  }

  // JOIN: Lista disciplinas de um estudante
  Future<List<Map<String, dynamic>>> listarDisciplinasDoEstudante(int idEstudante) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT d.id, d.nome, d.professor
      FROM disciplina d
      INNER JOIN cursando c ON d.id = c.id_disciplina
      WHERE c.id_estudante = ?
    ''', [idEstudante]);
  }

  // JOIN: Lista estudantes de uma disciplina
  Future<List<Map<String, dynamic>>> listarEstudantesDaDisciplina(int idDisciplina) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT e.id, e.nome, e.matricula
      FROM estudante e
      INNER JOIN cursando c ON e.id = c.id_estudante
      WHERE c.id_disciplina = ?
    ''', [idDisciplina]);
  }
}
