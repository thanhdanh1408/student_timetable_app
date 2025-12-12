// lib/features/subjects/presentation/widgets/add_edit_subject_form.dart
import 'package:flutter/material.dart';
import '../../domain/entities/subject_entity.dart';

class AddEditSubjectForm extends StatefulWidget {
  final SubjectEntity? subject;
  final Function(SubjectEntity) onSave;

  const AddEditSubjectForm({super.key, this.subject, required this.onSave});

  @override
  State<AddEditSubjectForm> createState() => _AddEditSubjectFormState();
}

class _AddEditSubjectFormState extends State<AddEditSubjectForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _teacherCtrl;
  late TextEditingController _roomCtrl;
  late TextEditingController _semesterCtrl;
  int _credit = 3;
  int? _dayOfWeek;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.subject?.subjectName ?? '');
    _teacherCtrl = TextEditingController(text: widget.subject?.teacherName ?? '');
    _roomCtrl = TextEditingController(text: widget.subject?.room ?? '');
    _semesterCtrl = TextEditingController(text: widget.subject?.semester ?? 'HK1.2024-2025');
    _credit = widget.subject?.credit ?? 3;
    _dayOfWeek = widget.subject?.dayOfWeek;
    _startTime = widget.subject != null ? _parseTime(widget.subject!.startTime) : null;
    _endTime = widget.subject != null ? _parseTime(widget.subject!.endTime) : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _teacherCtrl.dispose();
    _roomCtrl.dispose();
    _semesterCtrl.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "Chưa chọn";
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? const TimeOfDay(hour: 7, minute: 0))
          : (_endTime ?? const TimeOfDay(hour: 9, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(widget.subject == null ? Icons.add_circle_outline : Icons.edit, color: Colors.indigo),
          const SizedBox(width: 12),
          Text(
            widget.subject == null ? "Thêm môn học mới" : "Chỉnh sửa môn học",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tên môn học
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: "Tên môn học",
                    prefixIcon: const Icon(Icons.book),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => v!.isEmpty ? "Vui lòng nhập tên môn" : null,
                ),
                const SizedBox(height: 16),

                // Giảng viên
                TextFormField(
                  controller: _teacherCtrl,
                  decoration: InputDecoration(
                    labelText: "Giảng viên",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Phòng học
                TextFormField(
                  controller: _roomCtrl,
                  decoration: InputDecoration(
                    labelText: "Phòng học",
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Thứ trong tuần
                DropdownButtonFormField<int>(
                  value: _dayOfWeek,
                  decoration: InputDecoration(
                    labelText: "Thứ học",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: [
                    for (int i = 2; i <= 8; i++)
                      DropdownMenuItem(
                        value: i,
                        child: Text(i == 8 ? "Chủ nhật" : "Thứ $i"),
                      ),
                  ],
                  onChanged: (v) => setState(() => _dayOfWeek = v),
                  validator: (v) => v == null ? "Vui lòng chọn thứ" : null,
                ),
                const SizedBox(height: 16),

                // Giờ bắt đầu
                InkWell(
                  onTap: () => _pickTime(true),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Giờ bắt đầu",
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_formatTime(_startTime)),
                  ),
                ),
                const SizedBox(height: 16),

                // Giờ kết thúc
                InkWell(
                  onTap: () => _pickTime(false),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Giờ kết thúc",
                      prefixIcon: const Icon(Icons.access_time),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_formatTime(_endTime)),
                  ),
                ),
                const SizedBox(height: 16),

                // Số tín chỉ
                DropdownButtonFormField<int>(
                  value: _credit,
                  decoration: InputDecoration(
                    labelText: "Số tín chỉ",
                    prefixIcon: const Icon(Icons.credit_card),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: [1, 2, 3, 4, 5].map((c) => DropdownMenuItem(value: c, child: Text("$c tín chỉ"))).toList(),
                  onChanged: (v) => setState(() => _credit = v!),
                ),
                const SizedBox(height: 16),

                // Học kỳ
                TextFormField(
                  controller: _semesterCtrl,
                  decoration: InputDecoration(
                    labelText: "Học kỳ",
                    prefixIcon: const Icon(Icons.school),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _startTime != null &&
                _endTime != null &&
                _dayOfWeek != null) {
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
              widget.onSave(subject);
              Navigator.pop(context);
            }
          },
          child: Text(widget.subject == null ? "Thêm" : "Lưu"),
        ),
      ],
    );
  }
}