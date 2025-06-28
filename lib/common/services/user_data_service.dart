// lib/common/services/user_data_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_app/common/models/user_model.dart';

class UserDataService {
  final CollectionReference _usersCollection;

  UserDataService() : _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('No se pudo guardar la información del usuario.');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final docSnapshot = await _usersCollection.doc(uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('No se pudo obtener la información del usuario.');
    }
  }
}