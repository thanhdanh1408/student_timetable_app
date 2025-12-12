// lib/features/exam/presentation/widgets/exam_form_dialog.dart
import 'package:flutter/material.dart';
import '../../domain/entities/exam_entity.dart';
import '../../../subjects/domain/entities/subject_entity.dart';

class ExamFormDialog extends StatefulWidget {
  final ExamEntity? exam;
  final List<SubjectEntity> subjects;
  final Function(ExamEntity) onSave;

  const ExamFormDialog({
    super.key,
    this.exam,
    required this.subjects,
    required this.onSave,
  });

  @override
  State<ExamFormDialog> createState() => _ExamFormDialogState();
}

class _ExamFormDialogState extends State<ExamFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _roomCtrl;
  late SubjectEntity? _selectedSubject;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _roomCtrl = TextEditingController(text: widget.exam?.room ?? '');
    _selectedDate = widget.exam?.examDate ?? DateTime.now();
    _startTime = widget.exam != null ? _parseTime(widget.exam!.startTime) : null;
    _endTime = widget.exam?.endTime != null ? _parseTime(widget.exam!.endTime!) : null;

    // Tìm môn học được chọn dựa trên tên
    if (widget.exam != null && widget.subjects.isNotEmpty) {
      _selectedSubject = widget.subjects.firstWhere(
        (s) => s.subjectName == widget.exam!.subjectName,
        orElse: () => widget.subjects.first,
      );
    } else {
      _selectedSubject = widget.subjects.isNotEmpty ? widget.subjects.first : null;
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay? time) =>
      time == null ? "Chưa chọn" : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  void dispose() {
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
              // Dropdown chọn môn học
              DropdownButtonFormField<SubjectEntity>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: "Môn thi*",
                  border: OutlineInputBorder(),
                ),
                items: widget.subjects
                    .map((subject) => DropdownMenuItem(
                          value: subject,
                          child: Text(subject.subjectName),
                        ))
                    .toList(),
                onChanged: (SubjectEntity? value) {
                  setState(() => _selectedSubject = value);
                },
                validator: (value) => value == null ? "Vui lòng chọn môn thi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roomCtrl,
                decoration: const InputDecoration(
                  labelText: "Phòng thi",
                  border: OutlineInputBorder(),
                ),
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
                  decoration: const InputDecoration(
                    labelText: "Giờ bắt đầu*",
                    border: OutlineInputBorder(),
                  ),
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
                  decoration: const InputDecoration(
                    labelText: "Giờ kết thúc (tùy chọn)",
                    border: OutlineInputBorder(),
                  ),
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
            if (_formKey.currentState!.validate() && _startTime != null && _selectedSubject != null) {
              final exam = ExamEntity(
                id: widget.exam?.id,
                subjectName: _selectedSubject!.subjectName,
                teacherName: _selectedSubject!.teacherName,
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
                const SnackBar(content: Text("Vui lòng chọn môn thi và giờ bắt đầu")),
              );
            }
          },
          child: Text(widget.exam == null ? "Thêm" : "Lưu"),
        ),
      ],
    );
  }
}