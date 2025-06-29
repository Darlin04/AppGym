// lib/common/services/routine_data_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/common/models/routine_model.dart';

class RoutineDataService {
  final CollectionReference _routinesCollection = FirebaseFirestore.instance.collection('routines');

  Future<void> saveRoutine(RoutineModel routine) async {
    try {
      await _routinesCollection.doc(routine.id).set(routine.toMap());
    } catch (e) {
      print('Error al guardar la rutina: $e');
      throw Exception('No se pudo guardar la rutina.');
    }
  }

  Future<RoutineModel?> getRoutineById(String routineId) async {
    try {
      final docSnapshot = await _routinesCollection.doc(routineId).get();
      if (docSnapshot.exists) {
        return RoutineModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error al obtener la rutina: $e');
      throw Exception('No se pudo obtener la rutina.');
    }
  }
  
  Future<List<RoutineModel>> getRoutinesForUser(String userId) async {
    try {
      final querySnapshot = await _routinesCollection
          .where('creatorUid', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RoutineModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener las rutinas del usuario: $e');
      throw Exception('No se pudieron obtener las rutinas.');
    }
  }
  
  Future<List<RoutineModel>> getPredefinedRoutines() async {
    try {
      final querySnapshot = await _routinesCollection
          .where('isPredefined', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RoutineModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener las rutinas predefinidas: $e');
      throw Exception('No se pudieron obtener las rutinas predefinidas.');
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    try {
      await _routinesCollection.doc(routineId).delete();
    } catch (e) {
      print('Error al eliminar la rutina: $e');
      throw Exception('No se pudo eliminar la rutina.');
    }
  }
}