// lib/features/schedule/presentation/widgets/schedule_timetable.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/schedule_entity.dart';
import '../viewmodels/schedule_viewmodel.dart';

class ScheduleTimetable extends StatelessWidget {
  const ScheduleTimetable({super.key});

  // CHUYỂN RA NGOÀI CLASS → ĐƯỢC COI LÀ CONST
  static const List<String> timeSlots = [
    "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
    "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"
  ];

  static const List<String> weekdays = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

  @override
  Widget build(BuildContext context) {
    final schedules = context.watch<ScheduleViewModel>().schedules;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: 56,
          dataRowHeight: 80,
          columns: [
            const DataColumn(label: Text("Giờ", style: TextStyle(fontWeight: FontWeight.bold))),
            ...weekdays.map((day) => DataColumn(
                  label: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                )),
          ],
          rows: timeSlots.map((time) {
            return DataRow(
              cells: [
                DataCell(Center(child: Text(time, style: const TextStyle(fontSize: 12)))),
                ...List.generate(7, (dayIndex) {
                  final dayOfWeek = dayIndex + 2; // T2=2, ..., CN=8
                  final matching = schedules.where((s) =>
                      s.dayOfWeek == dayOfWeek &&
                      s.startTime == time).toList();

                  if (matching.isEmpty) return const DataCell(SizedBox());

                  final s = matching.first;
                  return DataCell(
                    GestureDetector(
                      onTap: () => _showDetail(context, s),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigo),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(s.subjectName ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                            Text("${s.startTime}-${s.endTime}", style: const TextStyle(fontSize: 10)),
                            Text(s.location ?? "N/A", style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, ScheduleEntity s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.subjectName ?? "N/A"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Giảng viên: ${s.teacherName ?? "N/A"}"),
            Text("Phòng: ${s.location ?? "N/A"}"),
            Text("Thời gian: ${s.startTime} - ${s.endTime}"),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Đóng"))],
      ),
    );
  }
}