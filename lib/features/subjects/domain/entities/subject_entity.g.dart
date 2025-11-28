// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectEntityAdapter extends TypeAdapter<SubjectEntity> {
  @override
  final int typeId = 0;

  @override
  SubjectEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectEntity(
      id: fields[0] as int?,
      subjectName: fields[1] as String,
      teacherName: fields[2] as String,
      room: fields[3] as String,
      dayOfWeek: fields[4] as int,
      startTime: fields[5] as String,
      endTime: fields[6] as String,
      semester: fields[7] as String,
      credit: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.subjectName)
      ..writeByte(2)
      ..write(obj.teacherName)
      ..writeByte(3)
      ..write(obj.room)
      ..writeByte(4)
      ..write(obj.dayOfWeek)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.semester)
      ..writeByte(8)
      ..write(obj.credit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
