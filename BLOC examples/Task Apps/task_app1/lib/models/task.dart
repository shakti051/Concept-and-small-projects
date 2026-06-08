//import 'dart:convert';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String title;
  final String id;
  final String description;
  final String date;
  bool? isDone;
  bool? isDeleted;
  bool? isFavorite;

  Task({
    required this.title,
    required this.id,
    required this.description,
    required this.date,
    this.isDone,
    this.isDeleted,
    this.isFavorite,
  }) {
    isDone = isDone ?? false;
    isDeleted = isDeleted ?? false;
    isFavorite = isFavorite ?? false;
  }

  Task copyWith({
    String? title,
    String? id,
    String? description,
    String? date,
    bool? isDone,
    bool? isDeleted,
    bool? isFavorite,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      isDeleted: isDeleted ?? this.isDeleted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'date': date,
      'isDone': isDone,
      'isDeleted': isDeleted,
      'isFavorite': isFavorite,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      isDone: map['isDone'],
      isDeleted: map['isDeleted'],
      isFavorite: map['isFavorite'],
    );
  }

  @override
  List<Object?> get props => [
    title,
    id,
    description,
    date,
    isDone,
    isDeleted,
    isFavorite,
  ];

  // String toJson() => json.encode(toMap());

  // factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
