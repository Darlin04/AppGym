import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- IMPORTACIÓN AÑADIDA
import 'package:gym_app/common/models/planification_model.dart';
import 'package:gym_app/common/models/user_model.dart';
import 'package:gym_app/common/services/planification_data_service.dart';
import 'package:gym_app/common/services/user_data_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PlanificationDataService _planService = PlanificationDataService();
  final UserDataService _userService = UserDataService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final PlanificationModel? partialPlan;

  final PageController pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String? _selectedGoal;
  int? _selectedRpe;
  
  OnboardingViewModel({this.partialPlan});

  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedGoal => _selectedGoal;
  int? get selectedRpe => _selectedRpe;


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

  void selectRpe(int rpe) {
    _selectedRpe = rpe;
    notifyListeners();
  }


  Future<bool> saveOnboardingData() async {
    if (_currentUser == null) {
      _errorMessage = "No se puede guardar: usuario no autenticado.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userUpdateData = {
        'age': int.tryParse(ageController.text),
        'weightKg': double.tryParse(weightController.text),
        'heightCm': double.tryParse(heightController.text),
        'fitnessGoal': _selectedGoal,
        'rpe': _selectedRpe,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .set(userUpdateData, SetOptions(merge: true));


      if (partialPlan != null) {
        final finalPlan = partialPlan!.copyWith(
          objective: _selectedGoal,
        );
        await _planService.savePlanification(finalPlan);
      } else {
        // CASO B: Se está generando un plan desde cero con el motor lógico.
        // Esto es para el flujo futuro donde el cuestionario crea todo el plan.
        
        // final userModel = await _userService.getUser(_currentUser!.uid);
        // if (userModel != null) {
        //   final generatedPlan = await _logicService.generatePlan(userModel);
        //   await _planService.savePlanification(generatedPlan);
        //   // Opcionalmente, hacerlo activo inmediatamente.
        //   await _planService.setActivePlanification(_currentUser!.uid, generatedPlan.id);
        // }
        print("Lógica de generación automática de plan se ejecutaría aquí.");
      }
      
      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _errorMessage = "Error al guardar los datos: ${e.toString()}";
      _isLoading = false;
      notifyListeners();
      return false;
    }
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