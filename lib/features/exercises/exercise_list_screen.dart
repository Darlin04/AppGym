import 'package:flutter/material.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Librería de Ejercicios')),
      body: const Center(
        child: Text('Aquí se mostrará la lista de ejercicios.'),
      ),
    );
  }
}