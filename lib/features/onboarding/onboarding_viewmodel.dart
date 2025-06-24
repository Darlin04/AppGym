import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String? _selectedGoal;
  String? get selectedGoal => _selectedGoal;

  void nextPage() {
    if (_currentPage < 2) {
      _currentPage++;
      pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      notifyListeners();
    }
  }

  void selectGoal(String goal) {
    _selectedGoal = goal;
    notifyListeners();
  }

  void saveOnboardingData() {
    final age = ageController.text;
    final weight = weightController.text;
    final height = heightController.text;

    print('Datos de Onboarding Guardados:');
    print('Edad: $age');
    print('Peso: $weight kg');
    print('Altura: $height cm');
    print('Objetivo: $_selectedGoal');

    // Aquí iría la llamada al servicio para guardar los datos en Firestore.
  }

  @override
  void dispose() {
    pageController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }
}