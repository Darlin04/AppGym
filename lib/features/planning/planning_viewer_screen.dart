import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/features/planning/planning_viewmodel.dart';
import 'package:gym_app/common/models/planification_model.dart';
import 'package:gym_app/features/onboarding/questionnaire_screen.dart';
import 'package:gym_app/common/theme/app_theme.dart';
import 'package:iconsax/iconsax.dart';

class PlanningViewerScreen extends StatelessWidget {
  const PlanningViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider para crear y proveer el ViewModel a los widgets hijos.
    return ChangeNotifierProvider(
      create: (_) => PlanningViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Planificación'),
        ),
        body: Consumer<PlanningViewModel>(
          builder: (context, viewModel, child) {
            // Estado de carga inicial
            if (viewModel.isLoading && viewModel.activePlanification == null) {
              return const Center(child: CircularProgressIndicator());
            }

            // Estado de error
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

            // Estado con planificación activa
            if (viewModel.activePlanification != null) {
              return _PlanDetailsView(plan: viewModel.activePlanification!);
            }

            // Estado vacío (sin planificación activa)
            return const _EmptyStateView();
          },
        ),
      ),
    );
  }
}

// Widget para mostrar cuando no hay un plan activo.
class _EmptyStateView extends StatelessWidget {
  const _EmptyStateView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text_1, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              'No tienes un plan activo',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Crea un nuevo plan de entrenamiento personalizado para empezar a registrar tu progreso.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Crear Plan de Entrenamiento'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para mostrar los detalles de la planificación activa.
class _PlanDetailsView extends StatelessWidget {
  final PlanificationModel plan;
  const _PlanDetailsView({required this.plan});

  // Helper para formatear Timestamp a una fecha legible.
  String _formatDate(Timestamp timestamp) {
    return DateFormat('dd/MM/yyyy', 'es_ES').format(timestamp.toDate());
  }

  // Helper para obtener el nombre del día de la semana.
  String _getDayOfWeekName(int day) {
    switch (day) {
      case 1: return 'Lunes';
      case 2: return 'Martes';
      case 3: return 'Miércoles';
      case 4: return 'Jueves';
      case 5: return 'Viernes';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return 'Día no válido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 24),
          Text(
            'Rutinas de la Semana',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Construye la lista de rutinas asignadas a cada día.
          if (plan.routineAssignments.isEmpty)
            const Text('No hay rutinas asignadas en esta planificación.')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: plan.routineAssignments.length,
              itemBuilder: (context, index) {
                final assignment = plan.routineAssignments[index];
                return _RoutineDayTile(
                  dayName: _getDayOfWeekName(assignment.dayOfWeek),
                  routineId: assignment.routineId,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(plan.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
            const Divider(height: 32),
            _buildInfoRow(Icons.timer_outlined, 'Duración', '${plan.durationWeeks} semanas'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.calendar_today_outlined, 'Inicio', _formatDate(plan.startDate)),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.flag_outlined, 'Fin', _formatDate(plan.endDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryPurpleDark, size: 20),
        const SizedBox(width: 12),
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(color: AppColors.textSecondary))),
      ],
    );
  }
}

// Widget para mostrar una rutina asignada a un día.
class _RoutineDayTile extends StatelessWidget {
  final String dayName;
  final String routineId;

  const _RoutineDayTile({required this.dayName, required this.routineId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: AppColors.primaryPurpleDark),
        title: Text(dayName, style: const TextStyle(fontWeight: FontWeight.bold)),
        // NOTA: Mostramos el ID por ahora. En el futuro, se podría obtener el nombre de la rutina.
        subtitle: Text('ID de Rutina: $routineId', style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navegar al visor de la rutina específica (RoutineViewerScreen).
          // Se necesitaría obtener el RoutineModel completo a partir del routineId.
        },
      ),
    );
  }
}