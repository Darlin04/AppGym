// lib/features/routines/routine_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:gym_app/common/models/routine_model.dart';
import 'package:gym_app/common/models/exercise_model.dart';
import 'package:gym_app/common/services/routine_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoutineViewModel extends ChangeNotifier {
  final RoutineDataService _routineService = RoutineDataService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  bool _isLoading = false;
  List<RoutineModel> _userRoutines = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<RoutineModel> get userRoutines => _userRoutines;
  String? get errorMessage => _errorMessage;

  final TextEditingController routineNameController = TextEditingController();
  List<RoutineExercise> _currentExercises = [];
  List<RoutineExercise> get currentExercises => _currentExercises;

  RoutineViewModel() {
    fetchUserRoutines();
  }

  Future<void> fetchUserRoutines() async {
    if (_currentUser == null) {
      _errorMessage = "Usuario no autenticado.";
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      _userRoutines = await _routineService.getRoutinesForUser(_currentUser!.uid);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startNewRoutine() {
    routineNameController.clear();
    _currentExercises = [];
    notifyListeners();
  }

  void addExerciseToRoutine(ExerciseModel exercise, int sets, int reps) {
    final newRoutineExercise = RoutineExercise(
      exerciseId: exercise.id,
      sets: sets,
      reps: reps,
      restSecs: 60, // Valor por defecto, se podría configurar en el diálogo
      order: _currentExercises.length,
    );
    _currentExercises.add(newRoutineExercise);
    notifyListeners();
  }

  void reorderExercises(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _currentExercises.removeAt(oldIndex);
    _currentExercises.insert(newIndex, item);
    
    // Actualiza el campo 'order' de cada ejercicio para mantener la consistencia
    for (int i = 0; i < _currentExercises.length; i++) {
      _currentExercises[i] = RoutineExercise(
        exerciseId: _currentExercises[i].exerciseId,
        sets: _currentExercises[i].sets,
        reps: _currentExercises[i].reps,
        restSecs: _currentExercises[i].restSecs,
        order: i,
      );
    }
    notifyListeners();
  }

  Future<bool> saveNewRoutine() async {
    if (routineNameController.text.trim().isEmpty) {
      _errorMessage = 'El nombre de la rutina no puede estar vacío.';
      notifyListeners();
      return false;
    }
    if (_currentExercises.isEmpty) {
      _errorMessage = 'Debes añadir al menos un ejercicio a la rutina.';
      notifyListeners();
      return false;
    }
    if (_currentUser == null) {
      _errorMessage = 'No se puede guardar la rutina. Usuario no autenticado.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final newRoutine = RoutineModel(
      id: const Uuid().v4(), // Genera un ID único para la nueva rutina
      name: routineNameController.text.trim(),
      description: 'Rutina personalizada', // Se podría añadir un campo para esto
      creatorUid: _currentUser!.uid,
      isPredefined: false,
      exercises: _currentExercises,
    );

    try {
      await _routineService.saveRoutine(newRoutine);
      await fetchUserRoutines(); // Vuelve a cargar las rutinas para actualizar la lista
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    routineNameController.dispose();
    super.dispose();
  }
}