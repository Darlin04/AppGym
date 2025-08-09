import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/features/onboarding/onboarding_viewmodel.dart';
import 'package:gym_app/common/models/planification_model.dart';
import 'package:gym_app/common/theme/app_theme.dart';

class QuestionnaireScreen extends StatelessWidget {
  final PlanificationModel? partialPlan;

  const QuestionnaireScreen({super.key, this.partialPlan});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(partialPlan: partialPlan),
      child: _QuestionnaireView(isAddingGoalToPlan: partialPlan != null),
    );
  }
}

// ---- EL RESTO DEL ARCHIVO PERMANECE IGUAL ----

class _QuestionnaireView extends StatelessWidget {
  final bool isAddingGoalToPlan;
  const _QuestionnaireView({required this.isAddingGoalToPlan});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isAddingGoalToPlan ? 'Define tu Objetivo' : 'Crea tu Plan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            if (viewModel.currentPage == 0) {
              Navigator.of(context).pop();
            } else {
              viewModel.previousPage();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _StepIndicator(
                totalSteps: 3,
                currentStep: viewModel.currentPage + 1,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: viewModel.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _GoalStep(),
                    _MeasurementsStep(),
                    _RpeStep(),
                  ],
                ),
              ),
              _NavigationButtons(isAddingGoalToPlan: isAddingGoalToPlan),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  const _StepIndicator({required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Paso $currentStep de $totalSteps',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _GoalStep extends StatelessWidget {
  const _GoalStep();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¿Cuál es tu objetivo principal?', style: textTheme.headlineSmall),
          const SizedBox(height: 30),
          _OptionCard(
            title: 'Perder Peso',
            isSelected: viewModel.selectedGoal == 'perder_peso',
            onTap: () => viewModel.selectGoal('perder_peso'),
          ),
          const SizedBox(height: 16),
          _OptionCard(
            title: 'Ganar Músculo',
            isSelected: viewModel.selectedGoal == 'ganar_musculo',
            onTap: () => viewModel.selectGoal('ganar_musculo'),
          ),
          const SizedBox(height: 16),
          _OptionCard(
            title: 'Mejorar Salud',
            isSelected: viewModel.selectedGoal == 'mejorar_salud',
            onTap: () => viewModel.selectGoal('mejorar_salud'),
          ),
        ],
      ),
    );
  }
}

class _MeasurementsStep extends StatelessWidget {
  const _MeasurementsStep();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<OnboardingViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tus Medidas', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Estos datos nos ayudan a personalizar tu plan.', style: textTheme.bodyMedium),
          const SizedBox(height: 30),
          TextField(
            controller: viewModel.ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Edad'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: viewModel.weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Peso (kg)'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: viewModel.heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Altura (cm)'),
          ),
        ],
      ),
    );
  }
}

class _RpeStep extends StatelessWidget {
  const _RpeStep();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¿Cómo percibes tu esfuerzo?', style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Selecciona tu nivel de esfuerzo en una escala del 1 al 10.', style: textTheme.bodyMedium),
          const SizedBox(height: 30),
          _OptionCard(
            title: '1-4: Muy Ligero a Ligero',
            isSelected: viewModel.selectedRpe == 4,
            onTap: () => viewModel.selectRpe(4),
          ),
          const SizedBox(height: 16),
          _OptionCard(
            title: '5-7: Moderado a Duro',
            isSelected: viewModel.selectedRpe == 7,
            onTap: () => viewModel.selectRpe(7),
          ),
          const SizedBox(height: 16),
          _OptionCard(
            title: '8-10: Muy Duro a Máximo Esfuerzo',
            isSelected: viewModel.selectedRpe == 10,
            onTap: () => viewModel.selectRpe(10),
          ),
        ],
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final bool isAddingGoalToPlan;
  const _NavigationButtons({required this.isAddingGoalToPlan});
  
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: viewModel.isLoading ? null : () async {
        if (viewModel.currentPage < 2) {
          viewModel.nextPage();
        } else {
          final success = await viewModel.saveOnboardingData();
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Plan guardado con éxito!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (context.mounted && viewModel.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(viewModel.errorMessage!),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      },
      child: viewModel.isLoading
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white))
          : Text(viewModel.currentPage < 2 ? 'Siguiente' : 'Finalizar y Guardar'),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurpleDark : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primaryPurpleDark : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryPurpleDark),
          ],
        ),
      ),
    );
  }
}