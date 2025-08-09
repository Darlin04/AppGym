import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/features/planning/create_plan_viewmodel.dart';
import 'package:gym_app/common/models/routine_model.dart';
import 'package:gym_app/common/theme/app_theme.dart';
import 'package:gym_app/features/onboarding/questionnaire_screen.dart';
import 'package:gym_app/common/models/planification_model.dart';

class CreatePlanScreen extends StatelessWidget {
  const CreatePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreatePlanViewModel(),
      child: const _CreatePlanView(),
    );
  }
}

class _CreatePlanView extends StatelessWidget {
  const _CreatePlanView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreatePlanViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Planificación'),
      ),
      body: Builder(
        builder: (context) {
          if (viewModel.isLoading && viewModel.userRoutines.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.userRoutines.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No tienes rutinas creadas. Crea una rutina primero para poder asignarla a un plan.'),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlanInfoSection(context),
                const SizedBox(height: 24),
                Text(
                  'Asigna tus rutinas a los días',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.userRoutines.length,
                  itemBuilder: (context, index) {
                    final routine = viewModel.userRoutines[index];
                    return _RoutineAssignmentCard(routine: routine);
                  },
                ),
              ],
            ),
          );
        },
      ),
      // BOTÓN FLOTANTE PARA GUARDAR
      floatingActionButton: FloatingActionButton.extended(
        onPressed: viewModel.isLoading ? null : () async {
          final result = await viewModel.saveOrProceed();

          if (result is PlanificationModel && context.mounted) {
            // Navegar al cuestionario con el plan parcial
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => QuestionnaireScreen(partialPlan: result),
            ));
          } else if (result == true && context.mounted) {
            // Guardado con éxito, cerrar pantalla
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Plan guardado con éxito'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop();
          } else if (viewModel.errorMessage != null && context.mounted) {
            // Mostrar error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(viewModel.errorMessage!), backgroundColor: Colors.red),
            );
          }
        },
        label: Text(viewModel.wantsToAddGoal ? 'Continuar al Objetivo' : 'Guardar Plan'),
        icon: viewModel.isLoading ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPlanInfoSection(BuildContext context) {
    final viewModel = context.watch<CreatePlanViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: viewModel.planNameController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Plan',
            hintText: 'Ej. Hipertrofia - Fase 1',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: viewModel.durationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Duración (semanas)',
          ),
        ),
        const SizedBox(height: 8),
        // Switch para la opción de objetivo
        SwitchListTile(
          title: const Text("Añadir un objetivo específico"),
          value: viewModel.wantsToAddGoal,
          onChanged: (value) {
            viewModel.setWantsToAddGoal(value);
          },
          activeColor: AppColors.primaryPurpleDark,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

// _RoutineAssignmentCard y _DaySelector permanecen iguales, los omito por brevedad
class _RoutineAssignmentCard extends StatelessWidget {
  final RoutineModel routine;
  const _RoutineAssignmentCard({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(routine.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${routine.exercises.length} ejercicios', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            _DaySelector(routineId: routine.id),
          ],
        ),
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  final String routineId;
  const _DaySelector({required this.routineId});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreatePlanViewModel>();
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final dayOfWeek = index + 1;
        final isSelected = viewModel.isDaySelectedForRoutine(routineId, dayOfWeek);
        final isDisabled = viewModel.isDayAssigned(dayOfWeek) && !isSelected;

        return GestureDetector(
          onTap: isDisabled ? null : () => viewModel.toggleDayForRoutine(routineId, dayOfWeek),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: isSelected
                ? AppColors.primaryPurpleDark
                : isDisabled
                    ? Colors.grey.shade300
                    : AppColors.primaryPurple.withOpacity(0.5),
            child: Text(
              days[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : isDisabled
                        ? Colors.grey.shade500
                        : AppColors.primaryPurpleDark,
              ),
            ),
          ),
        );
      }),
    );
  }
}