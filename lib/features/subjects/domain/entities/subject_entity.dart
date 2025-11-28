// lib/features/subjects/domain/entities/subject_entity.dart
import 'package:hive/hive.dart';

part 'subject_entity.g.dart';

@HiveType(typeId: 0)
class SubjectEntity extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String subjectName;

  @HiveField(2)
  final String teacherName;

  @HiveField(3)
  final String room;

  @HiveField(4)
  final int dayOfWeek; // 2=Thứ 2, 3=Thứ 3, ..., 8=Chủ nhật

  @HiveField(5)
  final String startTime; // "07:30"

  @HiveField(6)
  final String endTime;   // "09:00"

  @HiveField(7)
  final String semester;

  @HiveField(8)
  final int credit;

  SubjectEntity({
    this.id,
    required this.subjectName,
    required this.teacherName,
    required this.room,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.semester,
    required this.credit,
  });

  SubjectEntity copyWith({
    int? id,
    String? subjectName,
    String? teacherName,
    String? room,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    String? semester,
    int? credit,
  }) {
    return SubjectEntity(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      teacherName: teacherName ?? this.teacherName,
      room: room ?? this.room,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      semester: semester ?? this.semester,
      credit: credit ?? this.credit,
    );
  }
}