import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/common/models/planification_model.dart';
import 'package:gym_app/common/services/planification_data_service.dart';

class PlanningViewModel extends ChangeNotifier {
  final PlanificationDataService _planificationService = PlanificationDataService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  bool _isLoading = false;
  String? _errorMessage;
  PlanificationModel? _activePlanification;
  List<PlanificationModel> _allUserPlanifications = [];


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PlanificationModel? get activePlanification => _activePlanification;
  List<PlanificationModel> get allUserPlanifications => _allUserPlanifications;

  PlanningViewModel() {

    fetchActivePlanification();
  }


  Future<void> fetchActivePlanification() async {
    if (_currentUser == null) {
      _errorMessage = "Error: Usuario no autenticado.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activePlanification = await _planificationService.getActivePlanificationForUser(_currentUser!.uid);
    } catch (e) {
      _errorMessage = 'Error al cargar la planificación activa: ${e.toString()}';
      _activePlanification = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchAllUserPlanifications() async {
    if (_currentUser == null) {
      _errorMessage = "Error: Usuario no autenticado.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allUserPlanifications = await _planificationService.getAllPlanificationsForUser(_currentUser!.uid);
    } catch (e) {
      _errorMessage = 'Error al cargar las planificaciones: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Establece una planificación como activa y desactiva las demás.
  Future<bool> setActivePlanification(String planificationId) async {
    if (_currentUser == null) {
      _errorMessage = "Error: Usuario no autenticado.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _planificationService.setActivePlanification(_currentUser!.uid, planificationId);

      await fetchActivePlanification(); 
      return true;
    } catch (e) {
      _errorMessage = 'Error al activar la planificación: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   Future<void> createAndSavePlanification(/* Parámetros del cuestionario */) async {
   }
}