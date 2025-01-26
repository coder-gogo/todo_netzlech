import 'package:equatable/equatable.dart';
import 'package:todo_netzlech/utils/extension.dart';
import 'package:uuid/uuid.dart';

class TaskModel extends Equatable {
  final String? id;
  final String title;
  final String status; // e.g., 'pending', 'completed'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDeleted;

  TaskModel({
    required this.title,
    this.updatedAt,
    this.status = 'pending',
    DateTime? createdAt,
    this.isDeleted = false,
    String? id,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Convert TaskModel object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }

  // Create TaskModel object from Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      id: map['id'],
      isDeleted: map['is_deleted'],
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? status, // e.g., 'pending', 'completed'
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) =>
      TaskModel(
        title: title ?? this.title,
        updatedAt: updatedAt ?? this.updatedAt,
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  String? getUpdateDescription() => updatedAt?.toCompletedAtString('Completed at');

  String getCreatedDescription() => createdAt.toCompletedAtString('Created at');

  bool isDone() => status == 'completed';

  @override
  List<Object?> get props => [id, title, status, createdAt, updatedAt, isDeleted];
}
