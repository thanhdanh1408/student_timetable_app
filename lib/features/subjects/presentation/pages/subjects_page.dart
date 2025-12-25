// lib/features/subjects/presentation/pages/subjects_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/subjects_viewmodel.dart';
import '../widgets/subject_card.dart';
import '../widgets/subject_form_dialog.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});
  @override State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectsViewModel>().load();
    });
  }

  @override
  void didUpdateWidget(SubjectsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu có lỗi, hiển thị SnackBar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SubjectsViewModel>();
      if (provider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${provider.error}"), backgroundColor: Colors.red),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubjectsViewModel>();
    
    // Filter logic - chỉ lọc theo tên
    var filtered = provider.subjects;
    
    if (_searchCtrl.text.isNotEmpty) {
      filtered = filtered.where((s) => 
        s.subjectName.toLowerCase().contains(_searchCtrl.text.toLowerCase()) ||
        (s.teacherName?.toLowerCase().contains(_searchCtrl.text.toLowerCase()) ?? false)
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Môn học", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              print('🔵 [SubjectsPage] Add button clicked');
              try {
                showDialog(
                  context: context,
                  builder: (_) {
                    print('🔵 [SubjectsPage] Building SubjectFormDialog');
                    return SubjectFormDialog(onSave: (s) {
                      print('🔵 [SubjectsPage] onSave called for: ${s.subjectName}');
                      provider.add(s);
                    });
                  },
                );
              } catch (e, stackTrace) {
                print('❌ [SubjectsPage] Error showing dialog: $e');
                print('❌ StackTrace: $stackTrace');
              }
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: "Tìm môn học hoặc giảng viên...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                // List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              const Text("Chưa có môn học nào", style: TextStyle(fontSize: 18)),
                              const SizedBox(height: 8),
                              Text("Nhấn nút + để thêm", style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final subject = filtered[index];
                            return SubjectCard(
                              subject: subject,
                              onEdit: () => showDialog(
                                context: context,
                                builder: (_) => SubjectFormDialog(
                                  subject: subject,
                                  onSave: (s) => provider.update(s),
                                ),
                              ),
                              onDelete: () {
                                if (subject.id != null) {
                                  provider.delete(subject.id!);
                                }
                              },
                            );
                          },
                        ),
                )
              ],
            ),
    );
  }
}