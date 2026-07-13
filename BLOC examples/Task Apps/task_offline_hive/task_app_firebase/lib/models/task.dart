import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum SyncStatus {
  @HiveField(0)
  synced,

  @HiveField(1)
  pendingCreate,

  @HiveField(2)
  pendingUpdate,

  @HiveField(3)
  pendingDelete,
}

@HiveType(typeId: 1)
class Task extends Equatable {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String id;

  @HiveField(3)
  final String date;

  @HiveField(4)
  final bool isDone;

  @HiveField(5)
  final bool isDeleted;

  @HiveField(6)
  final bool isFavorite;

  @HiveField(7)
  final SyncStatus syncStatus;

  const Task({
    required this.title,
    required this.description,
    required this.id,
    required this.date,
    this.isDone = false,
    this.isDeleted = false,
    this.isFavorite = false,
    this.syncStatus = SyncStatus.synced,
  });

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
      isDone: map['isDone'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
      syncStatus: SyncStatus.values.firstWhere(
        (e) => e.name == (map['syncStatus'] ?? 'synced'),
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