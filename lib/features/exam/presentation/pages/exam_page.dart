// lib/features/exam/presentation/pages/exam_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import '../widgets/exam_card.dart';
import '../widgets/exam_form_dialog.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});
  @override State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final _searchCtrl = TextEditingController();
  String _filterStatus = "Tất cả";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().load();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamProvider>();

    // Filter logic
    var filtered = provider.exams;
    
    if (_filterStatus == "Sắp tới") {
      filtered = filtered.where((e) => e.examDate.isAfter(DateTime.now())).toList();
    } else if (_filterStatus == "Đã qua") {
      filtered = filtered.where((e) => e.examDate.isBefore(DateTime.now())).toList();
    }
    
    if (_searchCtrl.text.isNotEmpty) {
      filtered = filtered.where((e) => 
        e.subjectName.toLowerCase().contains(_searchCtrl.text.toLowerCase()) ||
        e.teacherName.toLowerCase().contains(_searchCtrl.text.toLowerCase())
      ).toList();
    }

    // Sort by date
    filtered.sort((a, b) => a.examDate.compareTo(b.examDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch thi", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ExamFormDialog(onSave: (e) => provider.add(e)),
            ),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search & Filter
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: "Tìm môn thi hoặc giảng viên...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ["Tất cả", "Sắp tới", "Đã qua"]
                              .map((status) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(status),
                                      selected: _filterStatus == status,
                                      onSelected: (_) => setState(() => _filterStatus = status),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              const Text("Chưa có lịch thi nào", style: TextStyle(fontSize: 20)),
                              const SizedBox(height: 8),
                              const Text("Nhấn + để thêm", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final exam = filtered[index];
                            return ExamCard(
                              exam: exam,
                              onEdit: () => showDialog(
                                context: context,
                                builder: (_) => ExamFormDialog(exam: exam, onSave: (e) => provider.update(e)),
                              ),
                              onDelete: () {
                                if (exam.id != null) {
                                  _showDeleteConfirm(context, provider, exam.id!);
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

  void _showDeleteConfirm(BuildContext context, ExamProvider provider, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.red, size: 48),
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc muốn xóa lịch thi này?\n\nHành động này không thể hoàn tác!"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              provider.delete(id);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}