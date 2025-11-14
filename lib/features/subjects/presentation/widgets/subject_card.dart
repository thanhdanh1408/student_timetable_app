import 'package:flutter/material.dart';
import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';

class SubjectCard extends StatelessWidget {
  final SubjectEntity subject;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${subject.credit} tín chỉ'),
                Text(subject.teacher),
                Text(subject.room),
              ],
            ),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}