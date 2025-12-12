// lib/features/subjects/presentation/widgets/subject_form_dialog.dart
import 'package:flutter/material.dart';
import '../../domain/entities/subject_entity.dart';

class SubjectFormDialog extends StatefulWidget {
  final SubjectEntity? subject;
  final Function(SubjectEntity) onSave;

  const SubjectFormDialog({super.key, this.subject, required this.onSave});

  @override
  State<SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<SubjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _teacherCtrl;
  int _credit = 3;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.subject?.subjectName ?? '');
    _teacherCtrl = TextEditingController(text: widget.subject?.teacherName ?? '');
    _credit = widget.subject?.credit ?? 3;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _teacherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.subject == null ? "Thêm môn học" : "Sửa môn học",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Tên môn học*",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v?.isEmpty ?? true) ? "Vui lòng nhập tên môn học" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _teacherCtrl,
                decoration: const InputDecoration(
                  labelText: "Giảng viên",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _credit,
                decoration: const InputDecoration(
                  labelText: "Tín chỉ",
                  border: OutlineInputBorder(),
                ),
                items: [1, 2, 3, 4, 5]
                    .map((c) => DropdownMenuItem<int>(
                          value: c,
                          child: Text("$c tín chỉ"),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _credit = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final subject = SubjectEntity(
                id: widget.subject?.id,
                subjectName: _nameCtrl.text.trim(),
                teacherName: _teacherCtrl.text.trim(),
                room: "",
                dayOfWeek: 2,
                startTime: "00:00",
                endTime: "00:00",
                semester: "",
                credit: _credit,
              );
              await widget.onSave(subject);
              if (mounted) Navigator.pop(context);
            }
          },
          child: Text(widget.subject == null ? "Thêm" : "Lưu"),
        ),
      ],
    );
  }
}
