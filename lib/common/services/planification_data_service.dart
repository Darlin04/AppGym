import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/common/models/planification_model.dart';

 
class PlanificationDataService {
  final CollectionReference _planificationsCollection =
      FirebaseFirestore.instance.collection('planifications');

 
  Future<void> savePlanification(PlanificationModel planification) async {
    try {
      await _planificationsCollection
          .doc(planification.id)
          .set(planification.toMap());
    } catch (e) {
      print('Error al guardar la planificación: $e');
      throw Exception('No se pudo guardar la planificación.');
    }
  }

 
  Future<PlanificationModel?> getActivePlanificationForUser(String userId) async {
    try {
      final querySnapshot = await _planificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return PlanificationModel.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;  
    } catch (e) {
      print('Error al obtener la planificación activa: $e');
      throw Exception('No se pudo obtener la planificación activa.');
    }
  }

   
  Future<List<PlanificationModel>> getAllPlanificationsForUser(String userId) async {
    try {
      final querySnapshot = await _planificationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) =>
              PlanificationModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener las planificaciones del usuario: $e');
      throw Exception('No se pudieron obtener las planificaciones.');
    }
  }

 
  Future<void> setActivePlanification(String userId, String planificationIdToActivate) async {
    final batch = FirebaseFirestore.instance.batch();

    try {
 
      final activePlansQuery = await _planificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

   
  
      for (final doc in activePlansQuery.docs) {
        if (doc.id != planificationIdToActivate) {
          batch.update(doc.reference, {'isActive': false});
        }
      }


      final planToActivateRef = _planificationsCollection.doc(planificationIdToActivate);
      batch.update(planToActivateRef, {'isActive': true});


      await batch.commit();
    } catch (e) {
      print('Error al actualizar el estado de la planificación: $e');
      throw Exception('No se pudo actualizar el estado de la planificación.');
    }
  }


  Future<void> deletePlanification(String planificationId) async {
    try {
      await _planificationsCollection.doc(planificationId).delete();
    } catch (e) {
      print('Error al eliminar la planificación: $e');
      throw Exception('No se pudo eliminar la planificación.');
    }
  }
}