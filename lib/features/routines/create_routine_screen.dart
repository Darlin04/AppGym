// lib/features/routines/create_routine_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/features/routines/routine_viewmodel.dart';
import 'package:gym_app/common/theme/app_theme.dart';
import 'package:gym_app/common/models/routine_model.dart';
import 'package:gym_app/common/models/exercise_model.dart';
import 'package:gym_app/features/exercises/exercise_list_screen.dart';

class CreateRoutineScreen extends StatelessWidget {
  const CreateRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RoutineViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Rutina'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: AppColors.primaryPurpleDark),
            onPressed: () async {
              final success = await viewModel.saveNewRoutine();
              if (success && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text('Nombre de la Rutina', style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: viewModel.routineNameController,
              decoration: const InputDecoration(
                hintText: 'Ej. Día de Pecho y Tríceps',
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: viewModel.currentExercises.length,
                itemBuilder: (context, index) {
                  final exercise = viewModel.currentExercises[index];
                  return _ExerciseTile(
                    key: ValueKey(exercise.exerciseId + exercise.order.toString()),
                    exercise: exercise,
                  );
                },
                onReorder: viewModel.reorderExercises,
              ),
            ),
            _AddExerciseButton(
              onTap: () async {
                final selectedExercise = await Navigator.of(context).push<ExerciseModel>(
                  MaterialPageRoute(
                    builder: (context) => const ExerciseListScreen(isSelectionMode: true),
                  ),
                );

                if (selectedExercise != null && context.mounted) {
                  _showSetsRepsDialog(context, selectedExercise);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final success = await viewModel.saveNewRoutine();
                if (success && context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Consumer<RoutineViewModel>(
                builder: (context, vm, child) {
                  if (vm.isLoading) {
                    return const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    );
                  }
                  return const Text('Guardar Rutina');
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSetsRepsDialog(BuildContext context, ExerciseModel exercise) {
    final setsController = TextEditingController();
    final repsController = TextEditingController();
    final viewModel = context.read<RoutineViewModel>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Añadir ${exercise.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: setsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Series'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Repeticiones'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('Añadir'),
              onPressed: () {
                final sets = int.tryParse(setsController.text) ?? 0;
                final reps = int.tryParse(repsController.text) ?? 0;

                if (sets > 0 && reps > 0) {
                  viewModel.addExerciseToRoutine(exercise, sets, reps);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final RoutineExercise exercise;
  const _ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, color: Colors.grey.shade400),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.exerciseId.replaceAll('_', ' ').split(' ').map((l) => l[0].toUpperCase() + l.substring(1)).join(' '),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${exercise.sets} series x ${exercise.reps} reps',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            ReorderableDragStartListener(
              index: exercise.order,
              child: const Icon(Icons.drag_handle, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddExerciseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddExerciseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primaryPurpleDark),
            const SizedBox(width: 8),
            Text('Añadir Ejercicio', style: TextStyle(color: AppColors.primaryPurpleDark, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}