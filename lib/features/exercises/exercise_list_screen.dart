// lib/features/exercises/exercise_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/features/exercises/exercise_viewmodel.dart';
import 'package:gym_app/common/models/exercise_model.dart';
import 'package:gym_app/features/exercises/exercise_detail_screen.dart'; // Importamos la pantalla de detalles

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Librería de Ejercicios'),
        ),
        body: Consumer<ExerciseViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            }

            if (viewModel.exercises.isEmpty) {
              return const Center(child: Text('No se encontraron ejercicios.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: viewModel.exercises.length,
              itemBuilder: (context, index) {
                final exercise = viewModel.exercises[index];
                return _ExerciseCard(exercise: exercise);
              },
            );
          },
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;

  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExerciseDetailScreen(exercise: exercise),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise.imageUrl.isNotEmpty)
              Image.network(
                exercise.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                // Muestra un placeholder mientras carga
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                // Muestra un icono si la imagen falla
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}