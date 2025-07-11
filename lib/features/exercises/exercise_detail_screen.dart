// lib/features/exercises/exercise_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:gym_app/common/models/exercise_model.dart';
import 'package:gym_app/common/theme/app_theme.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (exercise.imageUrl.isNotEmpty)
              Image.network(
                exercise.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  _buildTags(),
                  const SizedBox(height: 24),
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: exercise.type
          .map((type) => Chip(
                label: Text(type),
                backgroundColor: AppColors.primaryPurple.withOpacity(0.5),
                labelStyle: const TextStyle(color: AppColors.primaryPurpleDark),
                side: BorderSide.none,
              ))
          .toList(),
    );
  }
}