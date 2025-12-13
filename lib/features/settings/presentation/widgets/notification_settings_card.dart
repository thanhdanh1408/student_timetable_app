// lib/features/settings/presentation/widgets/notification_settings_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/core/providers/notification_settings_provider.dart';

class NotificationSettingsCard extends StatelessWidget {
  const NotificationSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationSettings = context.watch<NotificationSettingsProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Thông báo lịch học
          ListTile(
            leading: const Icon(Icons.school, color: Colors.blue),
            title: const Text("Thông báo lịch học"),
            subtitle: Text(
              notificationSettings.enableScheduleNotifications
                  ? "Nhắc ${notificationSettings.getReminderText(notificationSettings.scheduleReminderMinutes)}"
                  : "Đã tắt"
            ),
            trailing: Switch(
              value: notificationSettings.enableScheduleNotifications,
              onChanged: (value) {
                notificationSettings.setEnableScheduleNotifications(value);
              },
            ),
          ),
          if (notificationSettings.enableScheduleNotifications) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 20, color: Colors.grey),
                  const SizedBox(width: 12),
                  const Text("Nhắc trước:"),
                  const Spacer(),
                  DropdownButton<int>(
                    value: notificationSettings.scheduleReminderMinutes,
                    items: NotificationSettingsProvider.reminderOptions.map((minutes) {
                      return DropdownMenuItem(
                        value: minutes,
                        child: Text(notificationSettings.getReminderText(minutes)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        notificationSettings.setScheduleReminderMinutes(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
          const Divider(height: 1),
          // Thông báo lịch thi
          ListTile(
            leading: const Icon(Icons.assignment, color: Colors.orange),
            title: const Text("Thông báo lịch thi"),
            subtitle: Text(
              notificationSettings.enableExamNotifications
                  ? "Nhắc ${notificationSettings.getReminderText(notificationSettings.examReminderMinutes)}"
                  : "Đã tắt"
            ),
            trailing: Switch(
              value: notificationSettings.enableExamNotifications,
              onChanged: (value) {
                notificationSettings.setEnableExamNotifications(value);
              },
            ),
          ),
          if (notificationSettings.enableExamNotifications) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 20, color: Colors.grey),
                  const SizedBox(width: 12),
                  const Text("Nhắc trước:"),
                  const Spacer(),
                  DropdownButton<int>(
                    value: notificationSettings.examReminderMinutes,
                    items: NotificationSettingsProvider.reminderOptions.map((minutes) {
                      return DropdownMenuItem(
                        value: minutes,
                        child: Text(notificationSettings.getReminderText(minutes)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        notificationSettings.setExamReminderMinutes(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
