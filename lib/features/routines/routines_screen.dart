import 'package:flutter/material.dart';

class MyRoutinesScreen extends StatelessWidget {
  const MyRoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Rutinas')),
      body: const Center(
        child: Text('Aquí se mostrarán las rutinas guardadas del usuario.'),
      ),
    );
  }
}