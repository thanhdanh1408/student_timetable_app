import 'package:flutter/material.dart';
import 'package:student_timetable_app/core/utils/validators.dart';
import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';
import 'package:student_timetable_app/shared/widgets/custom_button.dart';
import 'package:student_timetable_app/shared/widgets/custom_textfield.dart';

class AddEditSubjectForm extends StatefulWidget {
  final SubjectEntity? subject;  // Null nếu thêm mới
  final Function(SubjectEntity) onSave;

  const AddEditSubjectForm({super.key, this.subject, required this.onSave});

  @override
  State<AddEditSubjectForm> createState() => _AddEditSubjectFormState();
}

class _AddEditSubjectFormState extends State<AddEditSubjectForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _creditController;
  late TextEditingController _teacherController;
  late TextEditingController _roomController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? '');
    _creditController = TextEditingController(text: widget.subject?.credit.toString() ?? '');
    _teacherController = TextEditingController(text: widget.subject?.teacher ?? '');
    _roomController = TextEditingController(text: widget.subject?.room ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditController.dispose();
    _teacherController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final subject = SubjectEntity(
        subjectId: widget.subject?.subjectId,
        name: _nameController.text,
        credit: int.parse(_creditController.text),
        teacher: _teacherController.text,
        room: _roomController.text,
      );
      widget.onSave(subject);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subject == null ? 'Thêm môn học' : 'Sửa môn học'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Tên môn',
                controller: _nameController,
                validator: (value) => value!.isEmpty ? 'Tên không được để trống' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Số tín chỉ',
                controller: _creditController,
                validator: (value) => value!.isEmpty || int.tryParse(value) == null ? 'Số tín chỉ không hợp lệ' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Giảng viên',
                controller: _teacherController,
                validator: (value) => value!.isEmpty ? 'Giảng viên không được để trống' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Phòng học',
                controller: _roomController,
              ),
            ],
          ),
        ),
      ),
      actions: [
        CustomButton(text: 'Lưu', onPressed: _save),
      ],
    );
  }
}