// lib/common/models/exercise_model.dart

class ExerciseModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> type;
  final Map<String, double> logicValues;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.logicValues,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'logicValues': logicValues,
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    final logicValuesData = map['logicValues'] as Map<String, dynamic>? ?? {};
    
    final logicValuesCasted = logicValuesData.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return ExerciseModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      type: List<String>.from(map['type'] as List<dynamic>),
      logicValues: logicValuesCasted,
    );
  }

  ExerciseModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? type,
    Map<String, double>? logicValues,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      logicValues: logicValues ?? this.logicValues,
    );
  }
}