// lib/features/exam/domain/entities/exam_entity.dart
import 'package:hive/hive.dart';

part 'exam_entity.g.dart';

@HiveType(typeId: 2)
class ExamEntity extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String subjectName;

  @HiveField(2)
  final String teacherName;

  @HiveField(3)
  final String room;

  @HiveField(4)
  final DateTime examDate; // Ngày thi

  @HiveField(5)
  final String startTime; // Giờ bắt đầu thi

  @HiveField(6)
  final String? endTime;   // Giờ kết thúc thi (nếu có)

  @HiveField(7)
  final String semester;

  @HiveField(8)
  final String? note;

  ExamEntity({
    this.id,
    required this.subjectName,
    required this.teacherName,
    required this.room,
    required this.examDate,
    required this.startTime,
    this.endTime,
    required this.semester,
    this.note,
  });

  ExamEntity copyWith({
    int? id,
    String? subjectName,
    String? teacherName,
    String? room,
    DateTime? examDate,
    String? startTime,
    String? endTime,
    String? semester,
    String? note,
  }) {
    return ExamEntity(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      teacherName: teacherName ?? this.teacherName,
      room: room ?? this.room,
      examDate: examDate ?? this.examDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      semester: semester ?? this.semester,
      note: note ?? this.note,
    );
  }
}