import 'package:dbestudante/pag1.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(app());
}

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "CRUD Estudante",
        home: Pag1(),
        debugShowCheckedModeBanner: false);
  }
}
