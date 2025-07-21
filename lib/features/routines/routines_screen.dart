import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/features/routines/routine_viewmodel.dart';
import 'package:gym_app/features/routines/create_routine_screen.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoutineViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Rutinas'),
        ),
        body: Consumer<RoutineViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Nueva Rutina'),
                    onPressed: () {
                      viewModel.startNewRoutine();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: viewModel,
                            child: const CreateRoutineScreen(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildRoutinesList(viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoutinesList(RoutineViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!));
    }
    if (viewModel.userRoutines.isEmpty) {
      return const Center(child: Text('Aún no has creado ninguna rutina.'));
    }

    return ListView.builder(
      itemCount: viewModel.userRoutines.length,
      itemBuilder: (context, index) {
        final routine = viewModel.userRoutines[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(routine.name),
            subtitle: Text('${routine.exercises.length} ejercicios'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navegar a la pantalla de visualización de la rutina
            },
          ),
        );
      },
    );
  }
}