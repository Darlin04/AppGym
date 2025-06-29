// lib/common/services/exercise_data_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/common/models/exercise_model.dart';

class ExerciseDataService {
  final CollectionReference _exercisesCollection = FirebaseFirestore.instance.collection('exercises');

  Future<List<ExerciseModel>> getAllExercises() async {
    try {
      final querySnapshot = await _exercisesCollection.get();
      
      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs
          .map((doc) => ExerciseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener los ejercicios: $e');
      throw Exception('No se pudieron obtener los ejercicios.');
    }
  }

  Future<ExerciseModel?> getExerciseById(String exerciseId) async {
    try {
      final docSnapshot = await _exercisesCollection.doc(exerciseId).get();
      if (docSnapshot.exists) {
        return ExerciseModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error al obtener el ejercicio: $e');
      throw Exception('No se pudo obtener el ejercicio.');
    }
  }

  Future<List<ExerciseModel>> getExercisesByType(String type) async {
    try {
      final querySnapshot = await _exercisesCollection
          .where('type', arrayContains: type)
          .get();

      return querySnapshot.docs
          .map((doc) => ExerciseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener los ejercicios por tipo: $e');
      throw Exception('No se pudieron obtener los ejercicios.');
    }
  }
}