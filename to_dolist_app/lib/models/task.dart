// lib/models/task.dart
import 'package:uuid/uuid.dart';

class Task {
  final String id;
  String text;
  bool isCompleted;
  final DateTime creationTime;

  Task({
    required this.id,
    required this.text,
    this.isCompleted = false,
    required this.creationTime,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isCompleted': isCompleted,
    'creationTime': creationTime.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    text: json['text'] as String,
    isCompleted: json['isCompleted'] as bool,
    creationTime: DateTime.parse(json['creationTime'] as String),
  );
}
