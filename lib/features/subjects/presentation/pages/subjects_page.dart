// lib/features/subjects/presentation/pages/subjects_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subjects_provider.dart';
import '../widgets/subject_card.dart';
import '../widgets/subject_form_dialog.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});
  @override State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final _searchCtrl = TextEditingController();
  String _filterDay = "Tất cả";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectsProvider>().load();
    });
  }

  @override
  void didUpdateWidget(SubjectsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu có lỗi, hiển thị SnackBar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SubjectsProvider>();
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

  List<String> _getDayNames() => ["Tất cả", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật"];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubjectsProvider>();
    
    // Filter logic
    var filtered = provider.subjects;
    
    if (_filterDay != "Tất cả") {
      final dayMap = {"Thứ 2": 2, "Thứ 3": 3, "Thứ 4": 4, "Thứ 5": 5, "Thứ 6": 6, "Thứ 7": 7, "Chủ nhật": 8};
      final selectedDay = dayMap[_filterDay]!;
      filtered = filtered.where((s) => s.dayOfWeek == selectedDay).toList();
    }
    
    if (_searchCtrl.text.isNotEmpty) {
      filtered = filtered.where((s) => 
        s.subjectName.toLowerCase().contains(_searchCtrl.text.toLowerCase()) ||
        s.teacherName.toLowerCase().contains(_searchCtrl.text.toLowerCase())
      ).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Môn học", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => SubjectFormDialog(onSave: (s) => provider.add(s)),
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
                          hintText: "Tìm môn học hoặc giảng viên...",
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
                          children: _getDayNames()
                              .map((day) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(day),
                                      selected: _filterDay == day,
                                      onSelected: (_) => setState(() => _filterDay = day),
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