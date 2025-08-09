import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/common/models/routine_model.dart';
import 'package:gym_app/common/models/planification_model.dart';
import 'package:gym_app/common/services/routine_data_service.dart';
import 'package:gym_app/common/services/planification_data_service.dart';

class CreatePlanViewModel extends ChangeNotifier {
  final RoutineDataService _routineService = RoutineDataService();
  final PlanificationDataService _planService = PlanificationDataService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  bool _isLoading = false;
  String? _errorMessage;
  List<RoutineModel> _userRoutines = [];

  final planNameController = TextEditingController();
  final durationController = TextEditingController(text: '4'); 

  Map<String, Set<int>> _dayAssignments = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<RoutineModel> get userRoutines => _userRoutines;
  Map<String, Set<int>> get dayAssignments => _dayAssignments;

  CreatePlanViewModel() {
    fetchUserRoutines();
  }

  Future<void> fetchUserRoutines() async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();
    try {
      _userRoutines = await _routineService.getRoutinesForUser(_currentUser!.uid);
    } catch (e) {
      _errorMessage = "Error al cargar tus rutinas.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleDayForRoutine(String routineId, int dayOfWeek) {
    for (var entry in _dayAssignments.entries) {
      if (entry.key != routineId && entry.value.contains(dayOfWeek)) {
        print("Día $dayOfWeek ya está asignado a la rutina ${entry.key}");
        return;
      }
    }

    _dayAssignments.putIfAbsent(routineId, () => {});

    if (_dayAssignments[routineId]!.contains(dayOfWeek)) {
      _dayAssignments[routineId]!.remove(dayOfWeek);
    } else {
      _dayAssignments[routineId]!.add(dayOfWeek);
    }

    _dayAssignments.removeWhere((key, value) => value.isEmpty);
    
    notifyListeners();
  }

  bool isDayAssigned(int dayOfWeek) {
    return _dayAssignments.values.any((days) => days.contains(dayOfWeek));
  }

  bool isDaySelectedForRoutine(String routineId, int dayOfWeek) {
    return _dayAssignments[routineId]?.contains(dayOfWeek) ?? false;
  }

  Future<bool> savePlanification() async {
    if (_currentUser == null || planNameController.text.trim().isEmpty) {
      _errorMessage = "El nombre del plan es obligatorio.";
      notifyListeners();
      return false;
    }
    if (_dayAssignments.isEmpty) {
      _errorMessage = "Debes asignar al menos una rutina a un día.";
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final List<DailyRoutineAssignment> assignments = [];
    _dayAssignments.forEach((routineId, days) {
      for (var day in days) {
        assignments.add(DailyRoutineAssignment(dayOfWeek: day, routineId: routineId));
      }
    });
    
    final duration = int.tryParse(durationController.text) ?? 4;
    final now = DateTime.now();
    final startDate = Timestamp.fromDate(now);
    final endDate = Timestamp.fromDate(now.add(Duration(days: duration * 7)));

    final newPlan = PlanificationModel(
      id: const Uuid().v4(),
      userId: _currentUser!.uid,
      name: planNameController.text.trim(),
      description: "Plan semanal personalizado",
      durationWeeks: duration,
      startDate: startDate,
      endDate: endDate,
      routineAssignments: assignments,
      isActive: false, 
      createdAt: Timestamp.now(),
    );

    try {
      await _planService.savePlanification(newPlan);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = "No se pudo guardar el plan.";
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    planNameController.dispose();
    durationController.dispose();
    super.dispose();
  }
}