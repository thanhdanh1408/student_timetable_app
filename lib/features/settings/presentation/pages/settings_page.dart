// lib/features/settings/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../../core/providers/notification_settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notificationSettings =
        context.watch<NotificationSettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Thông tin người dùng
            Card(
              margin: const EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Thông tin tài khoản", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.indigo,
                          child: Text(
                            (auth.user?.displayName?.isNotEmpty ?? false)
                                ? auth.user!.displayName![0].toUpperCase()
                                : "S",
                            style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                auth.user?.displayName ?? "Sinh viên",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                auth.user?.email ?? "",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Cài đặt thông báo
            const Text("Thông báo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text("Nhắc nhở buổi học"),
                    trailing: Switch(
                      value: notificationSettings.enableScheduleNotifications,
                      onChanged: (value) {
                        notificationSettings
                            .setEnableScheduleNotifications(value);
                      },
                    ),
                  ),
                  if (notificationSettings.enableScheduleNotifications)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const Text(
                            'Thời gian trước buổi học:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: NotificationSettingsProvider
                                .reminderOptions
                                .map(
                              (minutes) {
                                final isSelected =
                                    notificationSettings
                                            .scheduleReminderMinutes ==
                                        minutes;
                                return ChoiceChip(
                                  label: Text(
                                    notificationSettings
                                        .getReminderText(minutes),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: isSelected
                                      ? null
                                      : (_) {
                                          notificationSettings
                                              .setScheduleReminderMinutes(
                                                  minutes);
                                        },
                                  backgroundColor: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  selectedColor: Colors.black,
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.assignment),
                    title: const Text("Nhắc nhở lịch thi"),
                    trailing: Switch(
                      value: notificationSettings.enableExamNotifications,
                      onChanged: (value) {
                        notificationSettings
                            .setEnableExamNotifications(value);
                      },
                    ),
                  ),
                  if (notificationSettings.enableExamNotifications)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const Text(
                            'Thời gian trước lịch thi:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: NotificationSettingsProvider
                                .reminderOptions
                                .map(
                              (minutes) {
                                final isSelected =
                                    notificationSettings
                                            .examReminderMinutes ==
                                        minutes;
                                return ChoiceChip(
                                  label: Text(
                                    notificationSettings
                                        .getReminderText(minutes),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  selected: isSelected,
                                  onSelected: isSelected
                                      ? null
                                      : (_) {
                                          notificationSettings
                                              .setExamReminderMinutes(
                                                  minutes);
                                        },
                                  backgroundColor: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  selectedColor: Colors.black,
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Cài đặt chung
            const Text("Chung", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Ngôn ngữ"),
                    subtitle: const Text("Tiếng Việt"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text("Chế độ tối"),
                    trailing: Switch(value: false, onChanged: (_) {}),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text("Thông báo"),
                    trailing: Switch(value: true, onChanged: (_) {}),
                  ),
                ],
              ),
            ),

            // Giới thiệu
            const Text("Về ứng dụng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text("Về ứng dụng"),
                    subtitle: const Text("Version 1.0.0"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: "Student Timetable",
                        applicationVersion: "1.0.0",
                        applicationLegalese: "© 2024 Student Timetable",
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text("Chính sách bảo mật"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text("Điều khoản sử dụng"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Nút đăng xuất
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: const Icon(Icons.logout, color: Colors.red, size: 48),
                      title: const Text("Đăng xuất"),
                      content: const Text("Bạn có chắc muốn đăng xuất?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () async {
                            Navigator.pop(context);
                            await context.read<AuthProvider>().logout();
                            if (context.mounted) {
                              context.go('/login');
                            }
                          },
                          child: const Text("Đăng xuất", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Đăng xuất"),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
