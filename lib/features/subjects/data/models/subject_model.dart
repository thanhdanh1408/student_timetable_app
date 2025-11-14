import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  SubjectModel({
    int? subjectId,
    required String name,
    required int credit,
    required String teacher,
    required String room,
  }) : super(subjectId: subjectId, name: name, credit: credit, teacher: teacher, room: room);

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subject_id'],
      name: json['subject_name'],
      credit: json['credit'],
      teacher: json['teacher_name'],
      room: json['room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_name': name,
      'credit': credit,
      'teacher_name': teacher,
      'room': room,
    };
  }
}