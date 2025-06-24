import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/features/onboarding/onboarding_viewmodel.dart';
import 'package:gym_app/common/theme/app_theme.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: const _QuestionnaireView(),
    );
  }
}

class _QuestionnaireView extends StatelessWidget {
  const _QuestionnaireView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea tu Plan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
                    _AgeStep(),
                  ],
                ),
              ),
              _NavigationButtons(),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Cuál es tu objetivo principal?', style: textTheme.headlineSmall),
        const SizedBox(height: 30),
        _GoalOptionCard(
          title: 'Perder Peso',
          isSelected: viewModel.selectedGoal == 'perder_peso',
          onTap: () => viewModel.selectGoal('perder_peso'),
        ),
        const SizedBox(height: 16),
        _GoalOptionCard(
          title: 'Ganar Músculo',
          isSelected: viewModel.selectedGoal == 'ganar_musculo',
          onTap: () => viewModel.selectGoal('ganar_musculo'),
        ),
        const SizedBox(height: 16),
        _GoalOptionCard(
          title: 'Mejorar Salud',
          isSelected: viewModel.selectedGoal == 'mejorar_salud',
          onTap: () => viewModel.selectGoal('mejorar_salud'),
        ),
      ],
    );
  }
}

class _GoalOptionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalOptionCard({required this.title, required this.isSelected, required this.onTap});

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
            color: isSelected ? AppColors.primaryPurpleDark : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryPurpleDark : Colors.black,
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

class _MeasurementsStep extends StatelessWidget {
  const _MeasurementsStep();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<OnboardingViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tus Medidas', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Estos datos nos ayudan a personalizar tu plan.', style: textTheme.bodyMedium),
        const SizedBox(height: 30),
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
    );
  }
}

class _AgeStep extends StatelessWidget {
  const _AgeStep();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<OnboardingViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Cuál es tu edad?', style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Esto nos ayuda a ajustar la intensidad del entrenamiento.', style: textTheme.bodyMedium),
        const SizedBox(height: 30),
        TextField(
          controller: viewModel.ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Edad'),
        ),
      ],
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    return ElevatedButton(
      onPressed: () {
        if (viewModel.currentPage < 2) {
          viewModel.nextPage();
        } else {
          viewModel.saveOnboardingData();
          Navigator.of(context).pop();
        }
      },
      child: Text(viewModel.currentPage < 2 ? 'Siguiente' : 'Finalizar'),
    );
  }
}