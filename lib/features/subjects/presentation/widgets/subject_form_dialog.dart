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
  late TextEditingController _nameCtrl, _teacherCtrl, _roomCtrl, _semesterCtrl;
  int? _dayOfWeek;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _credit = 3;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.subject?.subjectName ?? '');
    _teacherCtrl = TextEditingController(text: widget.subject?.teacherName ?? '');
    _roomCtrl = TextEditingController(text: widget.subject?.room ?? '');
    _semesterCtrl = TextEditingController(text: widget.subject?.semester ?? 'HK1.2024-2025');
    _dayOfWeek = widget.subject?.dayOfWeek;
    _credit = widget.subject?.credit ?? 3;
    _startTime = widget.subject != null ? _parseTime(widget.subject!.startTime) : null;
    _endTime = widget.subject != null ? _parseTime(widget.subject!.endTime) : null;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay? time) => time == null ? "Chưa chọn" : '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _teacherCtrl.dispose();
    _roomCtrl.dispose();
    _semesterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subject == null ? "Thêm môn học" : "Sửa môn học", style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tên môn học
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "Tên môn học*", border: OutlineInputBorder()),
                validator: (v) => (v?.isEmpty ?? true) ? "Vui lòng nhập tên môn học" : null,
              ),
              const SizedBox(height: 12),
              
              // Giảng viên
              TextFormField(
                controller: _teacherCtrl,
                decoration: const InputDecoration(labelText: "Giảng viên", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              
              // Phòng học
              TextFormField(
                controller: _roomCtrl,
                decoration: const InputDecoration(labelText: "Phòng học", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              
              // Thứ
              DropdownButtonFormField<int>(
                value: _dayOfWeek,
                decoration: const InputDecoration(labelText: "Thứ*", border: OutlineInputBorder()),
                hint: const Text("Chọn thứ"),
                items: [2, 3, 4, 5, 6, 7, 8]
                    .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text("Thứ ${d == 8 ? 'CN' : d - 1}"),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _dayOfWeek = v),
                validator: (v) => v == null ? "Chọn thứ" : null,
              ),
              const SizedBox(height: 12),
              
              // Giờ bắt đầu
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
              
              // Giờ kết thúc
              InkWell(
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: _endTime ?? const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (t != null) setState(() => _endTime = t);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: "Giờ kết thúc*", border: OutlineInputBorder()),
                  child: Text(_formatTime(_endTime)),
                ),
              ),
              const SizedBox(height: 12),
              
              // Học kỳ
              TextFormField(
                controller: _semesterCtrl,
                decoration: const InputDecoration(labelText: "Học kỳ", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              
              // Tín chỉ
              DropdownButtonFormField<int>(
                value: _credit,
                decoration: const InputDecoration(labelText: "Tín chỉ", border: OutlineInputBorder()),
                items: [1, 2, 3, 4, 5]
                    .map((c) => DropdownMenuItem(value: c, child: Text("$c tín chỉ")))
                    .toList(),
                onChanged: (v) => setState(() => _credit = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && _startTime != null && _endTime != null) {
              final subject = SubjectEntity(
                id: widget.subject?.id,
                subjectName: _nameCtrl.text.trim(),
                teacherName: _teacherCtrl.text.trim(),
                room: _roomCtrl.text.trim(),
                dayOfWeek: _dayOfWeek!,
                startTime: _formatTime(_startTime),
                endTime: _formatTime(_endTime),
                semester: _semesterCtrl.text.trim(),
                credit: _credit,
              );
              await widget.onSave(subject);
              if (mounted) Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Vui lòng chọn giờ bắt đầu và giờ kết thúc")),
              );
            }
          },
          child: Text(widget.subject == null ? "Thêm" : "Lưu"),
        ),
      ],
    );
  }
}