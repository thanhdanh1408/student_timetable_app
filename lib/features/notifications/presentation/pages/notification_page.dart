import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/features/exam/presentation/providers/exam_provider.dart';
import '/features/schedule/presentation/providers/schedule_provider.dart';
import '/features/notifications/presentation/providers/notification_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load data khi page khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'Tất cả (0)',
            ),
            Tab(
              text: 'Chưa đọc (0)',
            ),
            Tab(
              text: 'Đã đọc (0)',
            ),
          ],
        ),
      ),
      body: Consumer3<ExamProvider, ScheduleProvider, NotificationProvider>(
        builder: (_, examProvider, scheduleProvider, notificationProvider, __) {
          final notifications = notificationProvider.notifications;

          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Tab "Tất cả"
              _buildNotificationList(notifications),
              // Tab "Chưa đọc"
              _buildNotificationList(
                  notifications.where((n) => !n.isRead).toList()),
              // Tab "Đã đọc"
              _buildNotificationList(
                  notifications.where((n) => n.isRead).toList()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDebugInfo,
        backgroundColor: Colors.black,
        child: const Icon(Icons.bug_report, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Chưa có thông báo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hệ thống sẽ gửi guồi thông báo nhắc nhở\nvề lịch học và lịch thi',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<dynamic> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<NotificationProvider>().load();
      },
      child: ListView.builder(
        itemCount: notifications.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: Colors.white,
                ),
              ),
              title: Text(
                notification.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Xóa'),
                    onTap: () {
                      context.read<NotificationProvider>().delete(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'exam':
        return Colors.red;
      case 'schedule':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'exam':
        return Icons.assignment;
      case 'schedule':
        return Icons.schedule;
      default:
        return Icons.notifications;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Future<void> _showDebugInfo() async {
    final notificationService = context.read<NotificationProvider>().notificationService;
    final pendingNotifications = await notificationService.getPendingNotifications();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Thông Báo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Số thông báo đang chờ: ${pendingNotifications.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (pendingNotifications.isEmpty)
                const Text('Không có thông báo nào được lên lịch.')
              else
                ...pendingNotifications.map((pending) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${pending.id}'),
                            Text('Tiêu đề: ${pending.title ?? 'N/A'}'),
                            Text('Nội dung: ${pending.body ?? 'N/A'}'),
                            Text('Payload: ${pending.payload ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    )),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  await notificationService.showImmediateNotification(
                    id: 99999,
                    title: 'Test Notification',
                    body: 'Đây là thông báo test để kiểm tra hệ thống!',
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã gửi test notification!')),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Gửi Test Notification'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
