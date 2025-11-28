// lib/features/schedule/presentation/pages/schedule_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_form_dialog.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _searchCtrl = TextEditingController();
  String _filterDay = "Tất cả";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider>().load();
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
    final provider = context.watch<ScheduleProvider>();

    // Filter logic
    var filtered = provider.schedules;
    
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
        title: const Text("Lịch học", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ScheduleFormDialog(onSave: (s) => provider.add(s)),
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
                              Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              const Text("Chưa có lịch học", style: TextStyle(fontSize: 20)),
                              const SizedBox(height: 8),
                              const Text("Nhấn nút + để thêm buổi học", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final schedule = filtered[index];
                            return ScheduleCard(
                              schedule: schedule,
                              onEdit: () => showDialog(
                                context: context,
                                builder: (_) => ScheduleFormDialog(
                                  schedule: schedule,
                                  onSave: (s) => provider.update(s),
                                ),
                              ),
                              onDelete: () {
                                if (schedule.id != null) {
                                  provider.delete(schedule.id!);
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

  void _showDeleteConfirm(BuildContext context, ScheduleProvider provider, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.red, size: 48),
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc muốn xóa buổi học này?\n\nHành động này không thể hoàn tác!"),
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