// lib/utils/demo_data_initializer.dart
// Utility để populate demo data nếu storage trống

import 'package:hive/hive.dart';
import '/features/subjects/domain/entities/subject_entity.dart';
import '/features/schedule/domain/entities/schedule_entity.dart';
import '/features/exam/domain/entities/exam_entity.dart';

Future<void> initializeDemoData() async {
  try {
    final subjectsBox = Hive.box<SubjectEntity>('subjects_box');
    final schedulesBox = Hive.box<ScheduleEntity>('schedules_box');
    final examsBox = Hive.box<ExamEntity>('exams_box');

    // Only initialize if ALL boxes are empty
    if (subjectsBox.isEmpty && schedulesBox.isEmpty && examsBox.isEmpty) {
    // Add demo subjects
    await subjectsBox.add(SubjectEntity(
      id: 1,
      subjectName: 'Toán Cao Cấp',
      teacherName: 'Dr. Nguyễn Văn A',
      room: 'A301',
      dayOfWeek: 2, // Thứ 2
      startTime: '07:30',
      endTime: '09:00',
      semester: '1',
      credit: 3,
    ));

    await subjectsBox.add(SubjectEntity(
      id: 2,
      subjectName: 'Lập Trình Di Động',
      teacherName: 'Dr. Trần Văn B',
      room: 'B205',
      dayOfWeek: 3, // Thứ 3
      startTime: '09:15',
      endTime: '11:45',
      semester: '1',
      credit: 4,
    ));

    await subjectsBox.add(SubjectEntity(
      id: 3,
      subjectName: 'Tiếng Anh',
      teacherName: 'Ms. Phạm Thị C',
      room: 'C102',
      dayOfWeek: 4, // Thứ 4
      startTime: '13:30',
      endTime: '15:00',
      semester: '1',
      credit: 2,
    ));

    // Add demo schedules (today)
    final now = DateTime.now();
    final todayDayOfWeek = now.weekday; // 1=Mon, 2=Tue, ..., 7=Sun

    await schedulesBox.add(ScheduleEntity(
      id: 1,
      subjectName: 'Toán Cao Cấp',
      teacherName: 'Dr. Nguyễn Văn A',
      room: 'A301',
      dayOfWeek: todayDayOfWeek,
      startTime: '07:30',
      endTime: '09:00',
      semester: '1',
    ));

    await schedulesBox.add(ScheduleEntity(
      id: 2,
      subjectName: 'Lập Trình Di Động',
      teacherName: 'Dr. Trần Văn B',
      room: 'B205',
      dayOfWeek: todayDayOfWeek,
      startTime: '09:15',
      endTime: '11:45',
      semester: '1',
    ));

    // Add demo exams (next 3 days)
    final futureDate1 = now.add(const Duration(days: 1));
    final futureDate2 = now.add(const Duration(days: 2));

    await examsBox.add(ExamEntity(
      id: 1,
      subjectName: 'Toán Cao Cấp',
      teacherName: 'Dr. Nguyễn Văn A',
      room: 'C101',
      examDate: futureDate1,
      startTime: '09:00',
      semester: '1',
    ));

    await examsBox.add(ExamEntity(
      id: 2,
      subjectName: 'Cơ Sở Dữ Liệu',
      teacherName: 'Dr. Lê Văn D',
      room: 'C102',
      examDate: futureDate2,
      startTime: '13:00',
      semester: '1',
    ));
    }
  } catch (e) {
    // Silent fail
  }
}
