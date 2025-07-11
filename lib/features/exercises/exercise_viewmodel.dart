// lib/features/exercises/exercise_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:gym_app/common/models/exercise_model.dart';
import 'package:gym_app/common/services/exercise_data_service.dart';

class ExerciseViewModel extends ChangeNotifier {
  final ExerciseDataService _exerciseService = ExerciseDataService();

  bool _isLoading = false;
  List<ExerciseModel> _exercises = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<ExerciseModel> get exercises => _exercises;
  String? get errorMessage => _errorMessage;

  ExerciseViewModel() {
    fetchAllExercises();
  }

  Future<void> fetchAllExercises() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _exercises = await _exerciseService.getAllExercises();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}