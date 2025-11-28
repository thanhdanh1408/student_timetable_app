// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsEntityAdapter extends TypeAdapter<UserSettingsEntity> {
  @override
  final int typeId = 4;

  @override
  UserSettingsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettingsEntity(
      userId: fields[0] as String,
      darkMode: fields[1] as bool,
      notifications: fields[2] as bool,
      language: fields[3] as String,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingsEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.darkMode)
      ..writeByte(2)
      ..write(obj.notifications)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
