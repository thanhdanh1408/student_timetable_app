// lib/features/exam/presentation/widgets/exam_form_dialog.dart
import 'package:flutter/material.dart';
import '../../domain/entities/exam_entity.dart';

class ExamFormDialog extends StatefulWidget {
  final ExamEntity? exam;
  final Function(ExamEntity) onSave;

  const ExamFormDialog({super.key, this.exam, required this.onSave});

  @override
  State<ExamFormDialog> createState() => _ExamFormDialogState();
}

class _ExamFormDialogState extends State<ExamFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectCtrl, _teacherCtrl, _roomCtrl;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _subjectCtrl = TextEditingController(text: widget.exam?.subjectName ?? '');
    _teacherCtrl = TextEditingController(text: widget.exam?.teacherName ?? '');
    _roomCtrl = TextEditingController(text: widget.exam?.room ?? '');
    _selectedDate = widget.exam?.examDate ?? DateTime.now();
    _startTime = widget.exam != null ? _parseTime(widget.exam!.startTime) : null;
    _endTime = widget.exam?.endTime != null ? _parseTime(widget.exam!.endTime!) : null;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay? time) => time == null ? "Chưa chọn" : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _teacherCtrl.dispose();
    _roomCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.exam == null ? "Thêm lịch thi" : "Sửa lịch thi"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _subjectCtrl,
                decoration: const InputDecoration(labelText: "Môn thi", border: OutlineInputBorder()),
                validator: (v) => (v?.isEmpty ?? true) ? "Vui lòng nhập môn thi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _teacherCtrl,
                decoration: const InputDecoration(labelText: "Giảng viên", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roomCtrl,
                decoration: const InputDecoration(labelText: "Phòng thi", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text("Ngày thi: ${_formatDate(_selectedDate)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              InkWell(
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: _startTime ?? const TimeOfDay(hour: 7, minute: 0),
                  );
                  if (t != null) setState(() => _startTime = t);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: "Giờ bắt đầu*", border: OutlineInputBorder()),
                  child: Text(_formatTime(_startTime)),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: _endTime ?? const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (t != null) setState(() => _endTime = t);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: "Giờ kết thúc (tùy chọn)", border: OutlineInputBorder()),
                  child: Text(_formatTime(_endTime)),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && _startTime != null) {
              final exam = ExamEntity(
                id: widget.exam?.id,
                subjectName: _subjectCtrl.text.trim(),
                teacherName: _teacherCtrl.text.trim(),
                room: _roomCtrl.text.trim(),
                examDate: _selectedDate,
                startTime: _formatTime(_startTime),
                endTime: _endTime != null ? _formatTime(_endTime) : null,
                semester: "HK1.2024-2025",
              );
              await widget.onSave(exam);
              if (mounted) Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Vui lòng chọn giờ bắt đầu")),
              );
            }
          },
          child: Text(widget.exam == null ? "Thêm" : "Lưu"),
        ),
      ],
    );
  }
}