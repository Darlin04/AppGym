// lib/features/exercises/exercise_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/features/exercises/exercise_viewmodel.dart';
import 'package:gym_app/common/models/exercise_model.dart';
import 'package:gym_app/features/exercises/exercise_detail_screen.dart';
import 'package:gym_app/common/theme/app_theme.dart';

class ExerciseListScreen extends StatelessWidget {
  final bool isSelectionMode;

  const ExerciseListScreen({super.key, this.isSelectionMode = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExerciseViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isSelectionMode ? 'Seleccionar Ejercicio' : 'Librería de Ejercicios'),
        ),
        body: Consumer<ExerciseViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Error: ${viewModel.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              );
            }

            if (viewModel.exercises.isEmpty) {
              return const Center(
                child: Text(
                  'No se encontraron ejercicios en la base de datos.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: viewModel.exercises.length,
              itemBuilder: (context, index) {
                final exercise = viewModel.exercises[index];
                return _ExerciseCard(
                  exercise: exercise,
                  isSelectionMode: isSelectionMode,
                );
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
  final bool isSelectionMode;

  const _ExerciseCard({required this.exercise, required this.isSelectionMode});

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
          if (isSelectionMode) {
            Navigator.of(context).pop(exercise);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExerciseDetailScreen(exercise: exercise),
              ),
            );
          }
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: exercise.type
                        .map((type) => Chip(
                              label: Text(type),
                              backgroundColor: AppColors.primaryPurple.withOpacity(0.5),
                              labelStyle: const TextStyle(color: AppColors.primaryPurpleDark, fontSize: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}