// lib/features/subjects/presentation/widgets/subject_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/subject_entity.dart';
import 'delete_confirm_dialog.dart';

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
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          subject.subjectName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text("Giảng viên: ${subject.teacherName}"),
            Text("Phòng: ${subject.room}"),
            Text("Thứ ${subject.dayOfWeek == 8 ? 'CN' : subject.dayOfWeek - 1} • ${subject.startTime} - ${subject.endTime}"),
            Text("Tín chỉ: ${subject.credit} • ${subject.semester}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.indigo),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => DeleteConfirmDialog(
                    subjectName: subject.subjectName,
                    onConfirm: onDelete,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}