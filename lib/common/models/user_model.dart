import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? name;
  final int? age;
  final double? weightKg;
  final double? heightCm;
  final String? fitnessGoal;
  final String? linkedGymCode;
  final Timestamp? createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.age,
    this.weightKg,
    this.heightCm,
    this.fitnessGoal,
    this.linkedGymCode,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'age': age,
      'weightKg': weightKg,
      'heightCm': heightCm,
      'fitnessGoal': fitnessGoal,
      'linkedGymCode': linkedGymCode,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      age: map['age'] as int?,
      weightKg: (map['weightKg'] as num?)?.toDouble(),
      heightCm: (map['heightCm'] as num?)?.toDouble(),
      fitnessGoal: map['fitnessGoal'] as String?,
      linkedGymCode: map['linkedGymCode'] as String?,
      createdAt: map['createdAt'] as Timestamp?,
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    int? age,
    double? weightKg,
    double? heightCm,
    String? fitnessGoal,
    String? linkedGymCode,
    Timestamp? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      linkedGymCode: linkedGymCode ?? this.linkedGymCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}