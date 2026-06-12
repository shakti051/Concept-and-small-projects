import 'package:equatable/equatable.dart';

enum SyncStatus {
  synced,
  pendingCreate,
  pendingUpdate,
  pendingDelete,
}

// ignore: must_be_immutable
class Task extends Equatable {
  final String title;
  final String description;
  final String id;
  final String date;
  bool? isDone;
  bool? isDeleted;
  bool? isFavorite;
  SyncStatus syncStatus;

  Task({
    required this.title,
    required this.description,
    required this.id,
    required this.date,
    this.isDone,
    this.isDeleted,
    this.isFavorite,
    this.syncStatus = SyncStatus.synced,
  }) {
    isDone = isDone ?? false;
    isDeleted = isDeleted ?? false;
    isFavorite = isFavorite ?? false;
  }

  Task copyWith({
    String? title,
    String? description,
    String? id,
    String? date,
    bool? isDone,
    bool? isDeleted,
    bool? isFavorite,
    SyncStatus? syncStatus,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      isDeleted: isDeleted ?? this.isDeleted,
      isFavorite: isFavorite ?? this.isFavorite,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'id': id,
      'date': date,
      'isDone': isDone,
      'isDeleted': isDeleted,
      'isFavorite': isFavorite,
      'syncStatus': syncStatus.name,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      isDone: map['isDone'],
      isDeleted: map['isDeleted'],
      isFavorite: map['isFavorite'],
      syncStatus: SyncStatus.values.firstWhere(
      (e) => e.name == map['syncStatus'],
      orElse: () => SyncStatus.synced,
    ),
  
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        id,
        date,
        isDone,
        isDeleted,
        isFavorite,
        syncStatus,
      ];
}
