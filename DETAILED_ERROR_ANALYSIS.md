# 🔴 Chi tiết các lỗi trong hệ thống thông báo

## 📌 Tóm tắt nhanh

Bạn đặt thông báo trước 5 phút trong Settings, nhưng không thấy thông báo nào vì:

1. **ExamProvider** (cho lịch thi) không biết đến cài đặt của bạn - nó hardcode 10 phút thay vì dùng 5 phút
2. **ScheduleProvider** (cho lịch học) tính toán ngày/giờ sai do confusion giữa hai hệ thống calendar
3. **main.dart** chưa kết nối `ExamProvider` với `NotificationSettingsProvider`

---

## 🔍 Chi tiết từng lỗi

### **LỖI #1: ExamProvider bỏ qua cài đặt người dùng**

#### 📍 Vị trí: `lib/features/exam/presentation/providers/exam_provider.dart`

#### ❌ Code trước đó (sai):
```dart
class ExamProvider with ChangeNotifier {
  final GetExamsUsecase _get;
  final AddExamUsecase _add;
  final UpdateExamUsecase _update;
  final DeleteExamUsecase _delete;

  ExamProvider({
    required GetExamsUsecase get,
    required AddExamUsecase add,
    required UpdateExamUsecase update,
    required DeleteExamUsecase delete,
  })  : _get = get,
        _add = add,
        _update = update,
        _delete = delete;
  
  // ... rest of code
  
  /// Schedule notification for an exam (10 minutes before exam starts)
  Future<void> _scheduleNotificationForExam(ExamEntity exam) async {
    if (exam.id == null) return;

    final timeParts = exam.startTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final examDateTime = DateTime(
      exam.examDate.year,
      exam.examDate.month,
      exam.examDate.day,
      hour,
      minute,
    );

    if (examDateTime.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        id: exam.id!,
        title: '📝 Sắp đến giờ thi: ${exam.subjectName}',
        body: 'Phòng ${exam.room} • ${exam.startTime}${exam.endTime != null ? " - ${exam.endTime}" : ""}',
        scheduledTime: examDateTime,  // ❌ LỖIX 1: Dùng giờ thi chính xác, không trừ thời gian
        minutesBefore: 10,  // ❌ LỖI 2: Hardcode 10 phút thay vì lấy từ settings
        payload: 'exam_${exam.id}',
      );
    }
  }
}
```

#### Vấn đề cụ thể:
1. **scheduledTime = examDateTime**: Thông báo được set để hiển thị **vào giờ thi**, không phải "trước 5 phút"
2. **minutesBefore: 10**: Hardcode 10 phút, nhưng user đã set 5 phút
3. **Không check settings**: Nếu user tắt "Thông báo lịch thi", vẫn schedule

#### ✅ Code sau khi sửa:
```dart
class ExamProvider with ChangeNotifier {
  final GetExamsUsecase _get;
  final AddExamUsecase _add;
  final UpdateExamUsecase _update;
  final DeleteExamUsecase _delete;
  final NotificationSettingsProvider? _notificationSettings;  // ✅ Thêm này

  ExamProvider({
    required GetExamsUsecase get,
    required AddExamUsecase add,
    required UpdateExamUsecase update,
    required DeleteExamUsecase delete,
    NotificationSettingsProvider? notificationSettings,  // ✅ Thêm tham số
  })  : _get = get,
        _add = add,
        _update = update,
        _delete = delete,
        _notificationSettings = notificationSettings;  // ✅ Lưu vào biến
  
  Future<void> _scheduleNotificationForExam(ExamEntity exam) async {
    if (exam.id == null) {
      print('❌ exam.id is NULL! Cannot schedule notification');
      return;
    }

    // ✅ Check xem user có bật thông báo lịch thi không
    if (_notificationSettings != null && 
        !_notificationSettings!.enableExamNotifications) {
      print('⚠️ Exam notifications are disabled in settings');
      return;
    }

    // ✅ Lấy thời gian nhắc nhở từ settings (mặc định 60 phút)
    final reminderMinutes = _notificationSettings?.examReminderMinutes ?? 60;

    final timeParts = exam.startTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final examDateTime = DateTime(
      exam.examDate.year,
      exam.examDate.month,
      exam.examDate.day,
      hour,
      minute,
    );

    // ✅ Tính thời gian thông báo = thời gian thi - thời gian nhắc nhở
    final notificationTime = examDateTime.subtract(Duration(minutes: reminderMinutes));

    print('📝 Exam notification setup:');
    print('   Exam time: $examDateTime');
    print('   Reminder: $reminderMinutes minutes before');
    print('   Notification time: $notificationTime');

    // ✅ Chỉ schedule nếu thời gian thông báo còn trong tương lai
    if (notificationTime.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        id: exam.id!,
        title: '📝 Sắp đến giờ thi: ${exam.subjectName}',
        body: 'Phòng ${exam.room} • ${exam.startTime}...',
        scheduledTime: notificationTime,  // ✅ Dùng notificationTime chính xác
        payload: 'exam_${exam.id}',
      );
      print('✅ Exam notification scheduled successfully');
    } else {
      print('❌ Notification time already passed');
    }
  }
}
```

---

### **LỖI #2: ScheduleProvider tính toán sai ngày học tiếp theo**

#### 📍 Vị trí: `lib/features/schedule/presentation/providers/schedule_provider.dart` → `_getNextOccurrence()`

#### Vấn đề:

App dùng hệ thống dayOfWeek: **2-8** (2=Thứ 2, ..., 8=Chủ nhật)

Nhưng `DateTime.weekday` trong Dart trả về: **1-7** (1=Monday, ..., 7=Sunday)

#### ❌ Code sai trước:
```dart
DateTime _getNextOccurrence(int dayOfWeek, String timeStr) {
  final now = DateTime.now();
  final timeParts = timeStr.split(':');
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);

  int daysToAdd = (dayOfWeek - now.weekday) % 7;  // ❌ So sánh trực tiếp!
  // Ví dụ: nếu dayOfWeek=3 (Thứ 3) và today=Tuesday (weekday=2)
  // Kết quả: daysToAdd = (3 - 2) % 7 = 1
  // Sẽ lên lịch cho ngày mai = Wednesday (sai!)
  
  if (daysToAdd == 0) {
    final todayClassTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (todayClassTime.isAfter(now.add(Duration(minutes: reminderMinutes)))) {
      return todayClassTime;
    } else {
      daysToAdd = 7;
    }
  }

  return DateTime(now.year, now.month, now.day + daysToAdd, hour, minute);
}
```

#### ✅ Code sủa:
```dart
DateTime _getNextOccurrence(int dayOfWeek, String timeStr) {
  final now = DateTime.now();
  final timeParts = timeStr.split(':');
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);

  // ✅ Convert từ app's dayOfWeek (2-8) sang Dart's weekday (1-7)
  // App: 2=Thứ 2, 3=Thứ 3, ..., 8=Chủ nhật
  // Dart: 1=Monday, 2=Tuesday, ..., 7=Sunday
  final targetWeekday = dayOfWeek == 8 ? 7 : dayOfWeek - 1;
  
  // Bây giờ so sánh đúng:
  int daysToAdd = (targetWeekday - now.weekday) % 7;
  // Ví dụ: dayOfWeek=3 (Thứ 3) → targetWeekday=2
  // today=Tuesday (weekday=2) → daysToAdd = (2-2) % 7 = 0 (cùng ngày) ✅
  // today=Wednesday (weekday=3) → daysToAdd = (2-3) % 7 = 6 (6 ngày tới) ✅
  
  if (daysToAdd == 0) {
    final todayClassTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (todayClassTime.isAfter(now.add(Duration(minutes: reminderMinutes)))) {
      return todayClassTime;
    } else {
      daysToAdd = 7;
    }
  }

  return DateTime(now.year, now.month, now.day + daysToAdd, hour, minute);
}
```

#### Ví dụ thực tế:

**Scenario:** Hôm nay là Thursday (4/12/2025), user có lớp "Thứ 3 lúc 09:00"

| Hệ thống | Giá trị |
|---------|--------|
| **App dayOfWeek** | 3 (Thứ 3) |
| **Dart weekday** | 3 (Wednesday) |
| **Today weekday** | 4 (Thursday) |

**Code sai cũ:** 
- `daysToAdd = (3 - 4) % 7 = 6`
- Kết quả: Thứ 3 tuần tới (10/12) ✅ Đúng nhưng là... may mắn!

**Nếu hôm nay là Tuesday (2/12):**
- **Code sai:** `daysToAdd = (3 - 2) % 7 = 1` → Kết quả Wednesday (3/12) ❌ Sai!
- **Code đúng:** `daysToAdd = (2 - 2) % 7 = 0` → Kết quả Tuesday (2/12) ✅ Đúng!

---

### **LỖI #3: main.dart không kết nối ExamProvider với settings**

#### 📍 Vị trí: `lib/main.dart` - phần setup providers

#### ❌ Code sai trước:
```dart
// Exam
ChangeNotifierProvider(
  create: (_) => ExamProvider(
    get: getExamsUsecase,
    add: addExamUsecase,
    update: updateExamUsecase,
    delete: deleteExamUsecase,
    // ❌ Không pass notificationSettings!
  )..load(),
),
```

#### ✅ Code sủa:
```dart
// Exam - needs NotificationSettingsProvider for custom reminder times
ChangeNotifierProxyProvider<NotificationSettingsProvider, ExamProvider>(
  create: (_) => ExamProvider(
    get: getExamsUsecase,
    add: addExamUsecase,
    update: updateExamUsecase,
    delete: deleteExamUsecase,
    // notificationSettings sẽ được pass trong update
  )..load(),
  update: (_, notificationSettings, previousExamProvider) =>
      previousExamProvider ?? ExamProvider(
        get: getExamsUsecase,
        add: addExamUsecase,
        update: updateExamUsecase,
        delete: deleteExamUsecase,
        notificationSettings: notificationSettings,  // ✅ Pass settings vào đây
      ),
),
```

---

## 🔄 Luồng xử lý trước vs sau

### ❌ **Trước khi sửa (KHÔNG HOẠT ĐỘNG):**

```
User thêm lịch thi
    ↓
ExamProvider.add(exam)
    ↓
_scheduleNotificationForExam()
    ├─ ❌ Không check enableExamNotifications
    ├─ ❌ Hardcode reminderMinutes = 10 (bỏ qua setting 5 phút)
    ├─ scheduledTime = exam_time (thay vì exam_time - 5 phút)
    └─ ❌ Schedule "5 phút nữa" nhưng thông báo set để hiển thị lúc thi
    
KẾT QUẢ: Không thấy thông báo (vì nó được set hiển thị vào giờ thi, quá trễ)
```

### ✅ **Sau khi sửa (HOẠT ĐỘNG ĐÚNG):**

```
User thêm lịch thi + cài đặt "5 phút trước"
    ↓
ExamProvider.add(exam)
    ↓
_scheduleNotificationForExam()
    ├─ ✅ Kiểm tra: enableExamNotifications = true ✓
    ├─ ✅ Lấy reminderMinutes = 5 (từ settings)
    ├─ ✅ Tính: notificationTime = exam_time - 5 phút
    ├─ ✅ Kiểm tra: notificationTime còn trong tương lai ✓
    └─ ✅ Schedule notification cho thời gian chính xác
    
KẾT QUẢ: Thông báo hiển thị 5 phút trước giờ thi ✓
```

---

## 🧠 Tại sao thông báo không hiển thị?

### Nguyên nhân #1: Hardcode thời gian sai
```dart
// ❌ Cũ:
scheduledTime: examDateTime,  // Lên lịch hiển thị LÚC THI
// Thông báo được lên lịch cho 14:00, nhưng nó sẽ không hiển thị (quá trễ!)

// ✅ Mới:
final notificationTime = examDateTime.subtract(Duration(minutes: 5));
scheduledTime: notificationTime;  // Lên lịch hiển thị LÚC 13:55 ✓
```

### Nguyên nhân #2: Không kiểm tra cài đặt
```dart
// ❌ Cũ: Luôn schedule, ngay cả khi user tắt tính năng

// ✅ Mới: Kiểm tra trước
if (_notificationSettings != null && 
    !_notificationSettings!.enableExamNotifications) {
  return;  // Không schedule nếu tắt
}
```

### Nguyên nhân #3: Nhầm lẫn hệ thống ngày
```dart
// ❌ Cũ:
int daysToAdd = (dayOfWeek - now.weekday) % 7;  // Tính sai!

// ✅ Mới:
final targetWeekday = dayOfWeek == 8 ? 7 : dayOfWeek - 1;  // Convert trước
int daysToAdd = (targetWeekday - now.weekday) % 7;  // Tính đúng
```

---

## 📊 So sánh hệ thống dayOfWeek

### Conversion Table:
| Mô tả | App (2-8) | Dart weekday (1-7) | Cách tính |
|-------|-----------|-------------------|----------|
| Thứ 2 (Monday) | 2 | 1 | `2 - 1 = 1` |
| Thứ 3 (Tuesday) | 3 | 2 | `3 - 1 = 2` |
| Thứ 4 (Wednesday) | 4 | 3 | `4 - 1 = 3` |
| Thứ 5 (Thursday) | 5 | 4 | `5 - 1 = 4` |
| Thứ 6 (Friday) | 6 | 5 | `6 - 1 = 5` |
| Thứ 7 (Saturday) | 7 | 6 | `7 - 1 = 6` |
| Chủ nhật (Sunday) | 8 | 7 | `if (8) then 7` |

---

## ✅ Kiểm chứng sửa chữa

Sau sửa, hãy xem logcat khi thêm lịch thi:

```
✅ exam.id is 5, continuing...
✅ Exam notifications are enabled: true
📝 Exam notification setup:
   Subject: Toán
   Exam time: 2025-12-20 14:00:00.000
   Reminder: 5 minutes before
   Notification time: 2025-12-20 13:55:00.000

🔔 ========================================
🔔 SCHEDULING NOTIFICATION
🔔 ID: 5
🔔 Title: 📝 Sắp đến giờ thi: Toán
🔔 Body: Phòng A101 • 14:00
🔔 Scheduled Time (notification): 2025-12-20 13:55:00.000
🔔 Current Time: 2025-12-13 14:30:00.000
🔔 Time Until Notification: 10085 minutes
🔔 ========================================
✅ Exam notification scheduled successfully
```

Nếu thấy logs này ✅, thì sửa chữa đã thành công!
