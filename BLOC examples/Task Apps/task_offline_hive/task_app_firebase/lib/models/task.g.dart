// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      title: fields[0] as String,
      description: fields[1] as String,
      id: fields[2] as String,
      date: fields[3] as String,
      isDone: fields[4] as bool,
      isDeleted: fields[5] as bool,
      isFavorite: fields[6] as bool,
      syncStatus: fields[7] as SyncStatus,
      lastModified: fields[8] as DateTime,
      ownerId: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.isDone)
      ..writeByte(5)
      ..write(obj.isDeleted)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.syncStatus)
      ..writeByte(8)
      ..write(obj.lastModified)
      ..writeByte(9)
      ..write(obj.ownerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncStatusAdapter extends TypeAdapter<SyncStatus> {
  @override
  final int typeId = 0;

  @override
  SyncStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncStatus.synced;
      case 1:
        return SyncStatus.pendingCreate;
      case 2:
        return SyncStatus.pendingUpdate;
      case 3:
        return SyncStatus.pendingHardDelete;
      default:
        return SyncStatus.synced;
    }
  }

  @override
  void write(BinaryWriter writer, SyncStatus obj) {
    switch (obj) {
      case SyncStatus.synced:
        writer.writeByte(0);
        break;
      case SyncStatus.pendingCreate:
        writer.writeByte(1);
        break;
      case SyncStatus.pendingUpdate:
        writer.writeByte(2);
        break;
      case SyncStatus.pendingHardDelete:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
