import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/features/exam/presentation/providers/exam_provider.dart';
import '/features/schedule/presentation/providers/schedule_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Load data khi page khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().load();
      context.read<ScheduleProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: Consumer2<ExamProvider, ScheduleProvider>(
        builder: (_, examProvider, scheduleProvider, __) {
          final exams = examProvider.exams;
          final schedules = scheduleProvider.schedules;

          // Filter: exams happening within 3 days
          final now = DateTime.now();
          final upcomingExams = exams.where((e) {
            try {
              final parts = e.startTime.split('/');
              final examDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
              final diff = examDate.difference(now).inDays;
              return diff >= 0 && diff <= 3;
            } catch (_) {
              return false;
            }
          }).toList();

          // Filter: today's schedules
          final todaySchedules = schedules.where((s) {
            return s.dayOfWeek == _getDayName(now.weekday);
          }).toList();

          final notifications = [
            ...upcomingExams.map((e) => _NotificationItem(
              type: 'exam',
              title: 'Kỳ thi: ${e.subjectName}',
              subtitle: 'Ngày ${e.startTime} - Phòng ${e.room}',
              time: e.startTime,
              icon: Icons.assignment,
            )),
            ...todaySchedules.map((s) => _NotificationItem(
              type: 'schedule',
              title: 'Học: ${s.subjectName}',
              subtitle: 'Giờ ${s.startTime} - ${s.endTime} - Phòng ${s.room}',
              time: s.startTime,
              icon: Icons.calendar_today,
            )),
          ];

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Không có thông báo', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ExamProvider>().load();
              await context.read<ScheduleProvider>().load();
            },
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(notif.icon, color: notif.type == 'exam' ? Colors.red : Colors.blue),
                    title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(notif.subtitle),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${notif.title} bị loại bỏ khỏi thông báo')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'];
    return days[(weekday - 1) % 7];
  }
}

class _NotificationItem {
  final String type;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;

  _NotificationItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });
}
