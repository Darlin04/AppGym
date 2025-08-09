import 'package:cloud_firestore/cloud_firestore.dart';


class PlanificationModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String? objective; 
  final int durationWeeks;
  final Timestamp startDate;
  final Timestamp endDate;
  final List<DailyRoutineAssignment> routineAssignments;
  bool isActive; 
  final Timestamp createdAt;

  PlanificationModel({ 
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.objective, 
    required this.durationWeeks,
    required this.startDate,
    required this.endDate,
    required this.routineAssignments,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'objective': objective, 
      'durationWeeks': durationWeeks,
      'startDate': startDate,
      'endDate': endDate,
      'routineAssignments': routineAssignments.map((x) => x.toMap()).toList(),
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  factory PlanificationModel.fromMap(Map<String, dynamic> map) {
    return PlanificationModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      objective: map['objective'] as String?, 
      durationWeeks: map['durationWeeks'] as int,
      startDate: map['startDate'] as Timestamp,
      endDate: map['endDate'] as Timestamp,
      routineAssignments: List<DailyRoutineAssignment>.from(
        (map['routineAssignments'] as List<dynamic>).map(
          (x) => DailyRoutineAssignment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      isActive: map['isActive'] as bool,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  PlanificationModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? objective, 
    int? durationWeeks,
    Timestamp? startDate,
    Timestamp? endDate,
    List<DailyRoutineAssignment>? routineAssignments,
    bool? isActive,
    Timestamp? createdAt,
  }) {
    return PlanificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      objective: objective ?? this.objective, 
      durationWeeks: durationWeeks ?? this.durationWeeks,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      routineAssignments: routineAssignments ?? this.routineAssignments,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


class DailyRoutineAssignment {
  final int dayOfWeek; 
  final String routineId;

  const DailyRoutineAssignment({
    required this.dayOfWeek,
    required this.routineId,
  });

  Map<String, dynamic> toMap() {
    return {
      'dayOfWeek': dayOfWeek,
      'routineId': routineId,
    };
  }

  factory DailyRoutineAssignment.fromMap(Map<String, dynamic> map) {
    return DailyRoutineAssignment(
      dayOfWeek: map['dayOfWeek'] as int,
      routineId: map['routineId'] as String,
    );
  }
}