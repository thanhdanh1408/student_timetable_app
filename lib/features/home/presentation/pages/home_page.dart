// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load summary data after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final home = context.watch<HomeProvider>();

    // LẤY FULLNAME TỪ displayName CỦA FIREBASE USER
    final String fullname = auth.user?.displayName ?? "Bạn";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang chủ", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<HomeProvider>().loadSummary(),
          ),
        ],
      ),
      body: home.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => home.loadSummary(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chào mừng – ĐÃ FIX FULLNAME
                    Text(
                      "Chào mừng, $fullname!",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Hôm nay là ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // 4 ô vuông tóm tắt
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.6,
                      children: [
                        _SummaryCard(
                          title: "Môn học",
                          value: "${home.summary?.subjectCount ?? 0}",
                          icon: Icons.book,
                          color: Colors.blue,
                        ),
                        _SummaryCard(
                          title: "Hôm nay",
                          value: "${home.summary?.scheduleTodayCount ?? 0}",
                          icon: Icons.today,
                          color: Colors.green,
                        ),
                        _SummaryCard(
                          title: "Lịch thi",
                          value: "${home.summary?.upcomingExamCount ?? 0}",
                          icon: Icons.assignment,
                          color: Colors.orange,
                        ),
                        _SummaryCard(
                          title: "Thông báo",
                          value: "${home.summary?.notificationCount ?? 0}",
                          icon: Icons.notifications,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Lịch học hôm nay
                    const Text("Lịch học hôm nay", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...?home.summary?.todaySchedules.map((item) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.access_time, color: Colors.indigo),
                            title: Text(item.split(' • ')[0]),
                            subtitle: Text(item.split(' • ').sublist(1).join(' • ')),
                          ),
                        )),

                    const SizedBox(height: 24),

                    // Lịch thi sắp tới
                    const Text("Lịch thi sắp tới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...?home.summary?.upcomingExams.map((exam) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.warning, color: Colors.red),
                            title: Text(exam),
                          ),
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontSize: 14, color: color)),
        ],
      ),
    );
  }
}