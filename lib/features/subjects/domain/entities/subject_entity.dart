class SubjectEntity {
  final int? subjectId;
  final String name;
  final int credit;
  final String teacher;
  final String room;

  SubjectEntity({
    this.subjectId,
    required this.name,
    required this.credit,
    required this.teacher,
    required this.room,
  });
}