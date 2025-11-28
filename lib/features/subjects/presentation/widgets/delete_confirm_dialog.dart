// lib/features/subjects/presentation/widgets/delete_confirm_dialog.dart
import 'package:flutter/material.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String subjectName;
  final VoidCallback onConfirm;

  const DeleteConfirmDialog({
    super.key,
    required this.subjectName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.red),
      title: const Text("Xác nhận xóa", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text("Bạn có chắc muốn xóa môn học:\n\n\"$subjectName\"?\n\nHành động này không thể hoàn tác!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text("Xóa", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}