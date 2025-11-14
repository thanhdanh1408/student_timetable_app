import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_timetable_app/core/utils/helpers.dart';
import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';
import 'package:student_timetable_app/features/subjects/presentation/providers/subjects_provider.dart';
import 'package:student_timetable_app/features/subjects/presentation/widgets/add_edit_subject_form.dart';
import 'package:student_timetable_app/features/subjects/presentation/widgets/subject_card.dart';
import 'package:student_timetable_app/shared/widgets/loading_indicator.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubjectsProvider>(context, listen: false).fetchSubjects();
    });
  }

  void _showAddEditDialog({SubjectEntity? subject}) {
    showDialog(
      context: context,
      builder: (context) => AddEditSubjectForm(
        subject: subject,
        onSave: (newSubject) {
          final provider = Provider.of<SubjectsProvider>(context, listen: false);
          if (subject == null) {
            provider.addSubject(newSubject);
          } else {
            provider.editSubject(newSubject);
          }
        },
      ),
    );
  }

  void _confirmDelete(int subjectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa môn học này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Provider.of<SubjectsProvider>(context, listen: false).deleteSubject(subjectId);
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectsProvider>(  // Key fix: Dùng Consumer để rebuild khi notify
      builder: (context, provider, child) {
        if (provider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(context, provider.errorMessage!);
            provider.clearError();  // Clear error sau show
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Môn học'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddEditDialog(),
              ),
            ],
          ),
          body: provider.isLoading
              ? const LoadingIndicator()
              : provider.subjects.isEmpty
                  ? const Center(child: Text('Chưa có môn học nào'))
                  : ListView.builder(
                      itemCount: provider.subjects.length,
                      itemBuilder: (context, index) {
                        final subject = provider.subjects[index];
                        return SubjectCard(
                          subject: subject,
                          onEdit: () => _showAddEditDialog(subject: subject),
                          onDelete: () => _confirmDelete(subject.subjectId!),
                        );
                      },
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddEditDialog(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}