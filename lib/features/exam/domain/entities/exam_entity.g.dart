// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamEntityAdapter extends TypeAdapter<ExamEntity> {
  @override
  final int typeId = 2;

  @override
  ExamEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExamEntity(
      id: fields[0] as int?,
      subjectName: fields[1] as String,
      teacherName: fields[2] as String,
      room: fields[3] as String,
      examDate: fields[4] as DateTime,
      startTime: fields[5] as String,
      endTime: fields[6] as String?,
      semester: fields[7] as String,
      note: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExamEntity obj) {
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
      ..write(obj.examDate)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.semester)
      ..writeByte(8)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
