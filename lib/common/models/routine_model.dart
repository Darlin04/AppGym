import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineExercise {
  final String exerciseId;
  final int sets;
  final int reps;
  final int restSecs;
  final int order;

  const RoutineExercise({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    required this.restSecs,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'restSecs': restSecs,
      'order': order,
    };
  }

  factory RoutineExercise.fromMap(Map<String, dynamic> map) {
    return RoutineExercise(
      exerciseId: map['exerciseId'] as String,
      sets: map['sets'] as int,
      reps: map['reps'] as int,
      restSecs: map['restSecs'] as int,
      order: map['order'] as int,
    );
  }
}

class RoutineModel {
  final String id;
  final String name;
  final String description;
  final String creatorUid;
  final bool isPredefined;
  final List<RoutineExercise> exercises;
  final Timestamp? createdAt;

  const RoutineModel({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorUid,
    required this.isPredefined,
    required this.exercises,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorUid': creatorUid,
      'isPredefined': isPredefined,
      'exercises': exercises.map((x) => x.toMap()).toList(),
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory RoutineModel.fromMap(Map<String, dynamic> map) {
    return RoutineModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      creatorUid: map['creatorUid'] as String,
      isPredefined: map['isPredefined'] as bool,
      exercises: List<RoutineExercise>.from(
        (map['exercises'] as List<dynamic>)
            .map((x) => RoutineExercise.fromMap(x as Map<String, dynamic>)),
      ),
      createdAt: map['createdAt'] as Timestamp?,
    );
  }
}