// lib/features/schedule/presentation/widgets/schedule_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../subjects/presentation/providers/subjects_provider.dart';
import '../../../subjects/domain/entities/subject_entity.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleFormDialog extends StatefulWidget {
  final ScheduleEntity? schedule;
  final Function(ScheduleEntity) onSave;

  const ScheduleFormDialog({super.key, this.schedule, required this.onSave});

  @override
  State<ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends State<ScheduleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  SubjectEntity? _selectedSubject;
  String? _room;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    final subjects = context.read<SubjectsProvider>().subjects;

    if (widget.schedule != null) {
      _selectedSubject = subjects.firstWhere(
        (s) => s.subjectName == widget.schedule!.subjectName,
        orElse: () => subjects.first,
      );
      _room = widget.schedule!.room;
      _startTime = _parseTime(widget.schedule!.startTime);
      _endTime = _parseTime(widget.schedule!.endTime);
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay? time) => time == null ? "Chưa chọn" : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? (_startTime ?? const TimeOfDay(hour: 7, minute: 0)) : (_endTime ?? const TimeOfDay(hour: 9, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startTime = picked;
        else _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<SubjectsProvider>().subjects;

    return AlertDialog(
      title: Text(widget.schedule == null ? "Thêm buổi học" : "Chỉnh sửa buổi học"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<SubjectEntity>(
                value: _selectedSubject,
                decoration: const InputDecoration(labelText: "Chọn môn học", border: OutlineInputBorder()),
                items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s.subjectName))).toList(),
                onChanged: (s) {
                  setState(() => _selectedSubject = s);
                  if (s != null) {
                    _room = s.room;
                    _startTime = _parseTime(s.startTime);
                    _endTime = _parseTime(s.endTime);
                  }
                },
                validator: (v) => v == null ? "Chọn môn học" : null,
              ),
              const SizedBox(height: 16),
              if (_selectedSubject != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Text("GV: ${_selectedSubject!.teacherName}"),
                      const Spacer(),
                      Text("Phòng: ${_selectedSubject!.room}"),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _room,
                decoration: const InputDecoration(labelText: "Phòng học (nếu khác)", border: OutlineInputBorder()),
                onChanged: (v) => _room = v.isEmpty ? null : v,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _pickTime(true),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: "Giờ bắt đầu", border: OutlineInputBorder()),
                  child: Text(_formatTime(_startTime)),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _pickTime(false),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: "Giờ kết thúc", border: OutlineInputBorder()),
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
            if (_formKey.currentState!.validate() && _selectedSubject != null && _startTime != null && _endTime != null) {
              final schedule = ScheduleEntity(
                id: widget.schedule?.id,
                subjectName: _selectedSubject!.subjectName,
                teacherName: _selectedSubject!.teacherName,
                room: _room ?? _selectedSubject!.room,
                dayOfWeek: _selectedSubject!.dayOfWeek,
                startTime: _formatTime(_startTime),
                endTime: _formatTime(_endTime),
                semester: _selectedSubject!.semester,
              );
              await widget.onSave(schedule);
              if (mounted) Navigator.pop(context);
            }
          },
          child: Text(widget.schedule == null ? "Thêm" : "Lưu"),
        ),
      ],
    );
  }
}