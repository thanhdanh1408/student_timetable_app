class ApiConstants {
  static const String baseUrl = "http://192.168.1.100/student_timetable_api"; // Thay bằng IP máy bạn chạy XAMPP
  static const Duration timeout = Duration(seconds: 30);

  // Auth
  static const String login = "$baseUrl/auth/login.php";
  static const String register = "$baseUrl/auth/register.php";
  static const String logout = "$baseUrl/auth/logout.php";
  static const String profile = "$baseUrl/auth/profile.php";

  // Subjects
  static const String subjects = "$baseUrl/subjects/index.php";
  static const String addSubject = "$baseUrl/subjects/create.php";
  static const String updateSubject = "$baseUrl/subjects/update.php";
  static const String deleteSubject = "$baseUrl/subjects/delete.php";

  // Schedule
  static const String schedules = "$baseUrl/schedules/index.php";
  static const String addSchedule = "$baseUrl/schedules/create.php";
  static const String updateSchedule = "$baseUrl/schedules/update.php";
  static const String deleteSchedule = "$baseUrl/schedules/delete.php";

  // Exam
  static const String exams = "$baseUrl/exams/index.php";
}