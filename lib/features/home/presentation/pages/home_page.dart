import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_timetable_app/features/authentication/presentation/providers/auth_provider.dart';
import 'package:student_timetable_app/features/home/presentation/providers/home_provider.dart';
import 'package:student_timetable_app/shared/widgets/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,  // Button refresh thủ công để sync nếu cần
          ),
        ],
      ),
      body: Stack(  // Fix nháy: Content dưới, loading overlay nếu isLoading
        children: [
          if (homeProvider.summary != null)
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chào mừng, ${authProvider.user?.fullname ?? 'Người dùng'}!',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Đây là lịch quan trọng của bạn'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SummaryCard(title: 'Môn học', value: homeProvider.summary!.subjectCount.toString(), icon: Icons.book),
                      _SummaryCard(title: 'Buổi học', value: homeProvider.summary!.scheduleCount.toString(), icon: Icons.calendar_today),
                      _SummaryCard(title: 'Bài thi', value: homeProvider.summary!.examCount.toString(), icon: Icons.assignment),
                      _SummaryCard(title: 'Thông báo', value: homeProvider.summary!.notificationCount.toString(), icon: Icons.notifications),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Lịch học hôm nay', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...homeProvider.summary!.todaySchedules.map((schedule) => Card(child: ListTile(title: Text(schedule)))),
                  const SizedBox(height: 16),
                  const Text('Lịch thi sắp tới', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...homeProvider.summary!.upcomingExams.map((exam) => Card(child: ListTile(title: Text(exam)))),
                ],
              ),
            )
          else
            const Center(child: Text('Lỗi tải dữ liệu')),
          if (homeProvider.isLoading)
            const Center(child: LoadingIndicator()),  // Overlay loading, không replace content
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Card(
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}