// lib/features/routines/routine_viewer_screen.dart

import 'package:flutter/material.dart';
import 'package:gym_app/common/models/routine_model.dart';
import 'package:gym_app/common/models/exercise_model.dart';
import 'package:gym_app/common/services/exercise_data_service.dart';
import 'package:gym_app/common/theme/app_theme.dart';

class RoutineViewerScreen extends StatefulWidget {
  final RoutineModel routine;

  const RoutineViewerScreen({super.key, required this.routine});

  @override
  State<RoutineViewerScreen> createState() => _RoutineViewerScreenState();
}

class _RoutineViewerScreenState extends State<RoutineViewerScreen> {
  bool _isLoading = true;
  Map<String, ExerciseModel> _exerciseDetailsMap = {};

  @override
  void initState() {
    super.initState();
    _fetchExerciseDetails();
  }

  Future<void> _fetchExerciseDetails() async {
    final exerciseService = ExerciseDataService();
    final Map<String, ExerciseModel> detailsMap = {};
    
    for (final routineExercise in widget.routine.exercises) {
      final exerciseDetail = await exerciseService.getExerciseById(routineExercise.exerciseId);
      if (exerciseDetail != null) {
        detailsMap[routineExercise.exerciseId] = exerciseDetail;
      }
    }

    if (mounted) {
      setState(() {
        _exerciseDetailsMap = detailsMap;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.name),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.routine.exercises.length,
              itemBuilder: (context, index) {
                final routineExercise = widget.routine.exercises[index];
                final exerciseDetail = _exerciseDetailsMap[routineExercise.exerciseId];

                if (exerciseDetail == null) {
                  return const SizedBox.shrink();
                }

                return _ExerciseDetailCard(
                  routineExercise: routineExercise,
                  exerciseDetail: exerciseDetail,
                );
              },
            ),
    );
  }
}

class _ExerciseDetailCard extends StatelessWidget {
  final RoutineExercise routineExercise;
  final ExerciseModel exerciseDetail;

  const _ExerciseDetailCard({required this.routineExercise, required this.exerciseDetail});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (exerciseDetail.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  exerciseDetail.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.fitness_center, color: Colors.grey),
                    );
                  },
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseDetail.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${routineExercise.sets} series x ${routineExercise.reps} reps',
                    style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Descanso: ${routineExercise.restSecs} seg',
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
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