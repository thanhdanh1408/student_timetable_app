// lib/features/settings/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '/core/providers/auth_provider.dart';
import '/core/services/notification_service.dart';
import '../widgets/notification_settings_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
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
                                (auth.userEmail?.isNotEmpty ?? false)
                                    ? auth.userEmail![0].toUpperCase()
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
                                    auth.userEmail?.split('@').first ?? "Sinh viên",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    auth.userEmail ?? "",
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

            // CÀI ĐẶT THÔNG BÁO
            const Text("Thông báo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            const NotificationSettingsCard(),

            // Cài đặt chung
            const Text("Chung", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  // TEST NOTIFICATION BUTTON
                  ListTile(
                    leading: const Icon(Icons.notifications_active, color: Colors.orange),
                    title: const Text("🧪 Test Notification"),
                    subtitle: const Text("Nhấn để kiểm tra thông báo"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      onPressed: () async {
                        try {
                          print('🧪 Testing notification...');
                          await NotificationService().showImmediateNotification(
                            id: 'test_notification_9999',
                            title: '🧪 Test Notification',
                            body: 'Hệ thống thông báo đang hoạt động!',
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Đã gửi test notification!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          print('❌ Error testing notification: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ Lỗi: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Test', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const Divider(height: 1),
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
                            await context.read<AuthProvider>().signOut();
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
      },
    );
  }
}
