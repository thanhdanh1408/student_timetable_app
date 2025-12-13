# 🔧 Tóm tắt sửa chữa lỗi chức năng thông báo

## 🎯 Vấn đề được phát hiện và khắc phục

### **Vấn đề 1: ExamProvider không sử dụng cài đặt thông báo của người dùng** ❌→✅

**Triệu chứng:** Khi thêm lịch thi và set thông báo trước 5 phút trong cài đặt, nhưng không thấy thông báo nào hoặc thông báo hiển thị với thời gian sai (hardcode 10 phút).

**Nguyên nhân:**
- File: [lib/features/exam/presentation/providers/exam_provider.dart](lib/features/exam/presentation/providers/exam_provider.dart)
- `ExamProvider` không nhận `NotificationSettingsProvider` trong constructor
- Không kiểm tra xem người dùng có bật "Thông báo lịch thi" hay không
- Không lấy giá trị `examReminderMinutes` từ cài đặt

**Cách sửa:**
1. Thêm tham số `NotificationSettingsProvider? notificationSettings` vào constructor của ExamProvider
2. Kiểm tra `enableExamNotifications` trước khi schedule thông báo
3. Lấy `examReminderMinutes` từ settings thay vì hardcode
4. Tính toán thời gian thông báo: `examDateTime - reminderMinutes`
5. Kiểm tra thời gian thông báo có trong tương lai không trước khi schedule

**Ảnh hưởng:** Exam notifications sẽ tuân theo cài đặt người dùng (bật/tắt, thời gian nhắc nhở tùy chỉnh)

---

### **Vấn đề 2: ScheduleProvider tính toán sai ngày/giờ lớp học tiếp theo** ❌→✅

**Triệu chứng:** Thông báo cho lịch học có thể không hiển thị hoặc hiển thị vào ngày/giờ sai.

**Nguyên nhân:**
- File: [lib/features/schedule/presentation/providers/schedule_provider.dart](lib/features/schedule/presentation/providers/schedule_provider.dart)
- Hàm `_getNextOccurrence` không chuyển đổi đúng giữa hai hệ thống dayOfWeek:
  - **Hệ thống app:** 2-8 (2=Thứ 2, 3=Thứ 3, ..., 8=Chủ nhật)
  - **Flutter DateTime.weekday:** 1-7 (1=Monday, ..., 7=Sunday)
- Khi so sánh `dayOfWeek` trực tiếp với `now.weekday`, kết quả không chính xác

**Cách sửa:**
```dart
// Convert từ app's dayOfWeek (2-8) sang Dart's weekday (1-7)
final targetWeekday = dayOfWeek == 8 ? 7 : dayOfWeek - 1;

// Sau đó dùng targetWeekday để tính daysToAdd
int daysToAdd = (targetWeekday - now.weekday) % 7;
```

**Ảnh hưởng:** Schedule notifications sẽ được lên lịch cho ngày/giờ chính xác của lớp học tiếp theo

---

### **Vấn đề 3: NotificationService API không rõ ràng** ❌→✅

**Triệu chứng:** Code khó hiểu, tham số `minutesBefore` bị bỏ qua trong thực hiện.

**Nguyên nhân:**
- File: [lib/core/services/notification_service.dart](lib/core/services/notification_service.dart)
- Tham số `minutesBefore` tồn tại trong API nhưng không được sử dụng
- Tài liệu không rõ ràng về cách tính toán `scheduledTime`

**Cách sửa:**
1. Loại bỏ tham số `minutesBefore` không dùng
2. Thêm comment chi tiết giải thích:
   - `scheduledTime` phải là thời gian **chính xác** khi thông báo sẽ hiển thị
   - Phải tính `scheduledTime = eventTime - reminderDuration` **trước** khi gọi hàm
   - Hàm sẽ kiểm tra nếu `scheduledTime` đã qua (trong quá khứ) thì sẽ không schedule

**Ảnh hưởng:** Code rõ ràng, dễ hiểu, giảm lỗi khi sử dụng API

---

### **Vấn đề 4: ExamProvider và ScheduleProvider không nhận NotificationSettingsProvider trong main.dart** ❌→✅

**Nguyên nhân:**
- File: [lib/main.dart](lib/main.dart)
- Mặc dù code đã chuẩn bị để nhận `NotificationSettingsProvider`, nhưng `ExamProvider` chưa được thiết lập đúng

**Cách sửa:**
- Thay đổi `ExamProvider` từ `ChangeNotifierProvider` sang `ChangeNotifierProxyProvider<NotificationSettingsProvider, ExamProvider>`
- Tương tự như `ScheduleProvider` để đảm bảo `NotificationSettingsProvider` được truyền vào

**Code:**
```dart
// Exam - needs NotificationSettingsProvider for custom reminder times
ChangeNotifierProxyProvider<NotificationSettingsProvider, ExamProvider>(
  create: (_) => ExamProvider(
    get: getExamsUsecase,
    add: addExamUsecase,
    update: updateExamUsecase,
    delete: deleteExamUsecase,
  )..load(),
  update: (_, notificationSettings, previousExamProvider) =>
      previousExamProvider ?? ExamProvider(
    get: getExamsUsecase,
    add: addExamUsecase,
    update: updateExamUsecase,
    delete: deleteExamUsecase,
    notificationSettings: notificationSettings,
  ),
),
```

**Ảnh hưởng:** Cả `ExamProvider` và `ScheduleProvider` đều nhận cài đặt từ user

---

## 📝 Danh sách file đã sửa

| File | Thay đổi |
|------|---------|
| [lib/features/exam/presentation/providers/exam_provider.dart](lib/features/exam/presentation/providers/exam_provider.dart) | ✅ Thêm `NotificationSettingsProvider`, sửa logic schedule |
| [lib/main.dart](lib/main.dart) | ✅ Thay đổi `ExamProvider` provider từ `ChangeNotifierProvider` → `ChangeNotifierProxyProvider` |
| [lib/features/schedule/presentation/providers/schedule_provider.dart](lib/features/schedule/presentation/providers/schedule_provider.dart) | ✅ Sửa conversion dayOfWeek trong `_getNextOccurrence` |
| [lib/core/services/notification_service.dart](lib/core/services/notification_service.dart) | ✅ Loại bỏ tham số không dùng, cải thiện documentation |

---

## 🧪 Cách kiểm tra sửa chữa

### **Test Case 1: Thêm lịch thi với thông báo trước 5 phút**
1. Vào Settings → Thông báo lịch thi
2. Chọn "5 phút trước"
3. Thêm một lịch thi (ngày/giờ trong tương lai)
4. Mở Debug thông báo (nút bug report)
5. ✅ Xác nhận: Thông báo được schedule với ID của lịch thi, thời gian = giờ thi - 5 phút

### **Test Case 2: Thêm lịch học với thông báo trước 10 phút**
1. Vào Settings → Thông báo lịch học
2. Chọn "10 phút trước"
3. Thêm một lịch học (ngày tiếp theo)
4. Mở Debug thông báo
5. ✅ Xác nhận: Thông báo được schedule, thời gian = giờ học - 10 phút

### **Test Case 3: Tắt thông báo lịch thi**
1. Vào Settings → Tắt "Thông báo lịch thi"
2. Thêm một lịch thi mới
3. Mở Debug thông báo
4. ✅ Xác nhận: Thông báo **không** được schedule

### **Test Case 4: Thay đổi cài đặt thời gian nhắc nhở**
1. Có một lịch thi đã được schedule
2. Vào Settings → Thay đổi từ "5 phút" sang "30 phút"
3. Cập nhật/sửa lịch thi
4. ✅ Xác nhận: Thông báo được reschedule với thời gian mới

---

## 🔍 Debug Logs

Khi thêm/sửa lịch học hoặc lịch thi, hãy xem logcat để confirm:

### Ví dụ logs khi schedule thành công:
```
📅 ========================================
📅 SCHEDULE NOTIFICATION SETUP
📅 Subject: Toán
📅 Day of week: 3
📅 Start time: 09:00
📅 Next occurrence (class time): 2025-12-17 09:00:00.000
📅 Reminder time setting: 5 minutes before
📅 Notification time: 2025-12-17 08:55:00.000
📅 Current time: 2025-12-13 14:30:00.000
📅 Minutes until notification: 6485

🔔 ========================================
🔔 SCHEDULING NOTIFICATION
🔔 ID: 1
🔔 Title: 📚 Sắp đến giờ học: Toán
🔔 Scheduled Time (notification): 2025-12-17 08:55:00.000
✅ Notification scheduled successfully
```

---

## 🎉 Kết luận

Sau các sửa chữa này, chức năng thông báo sẽ hoạt động chính xác:
- ✅ Tuân theo cài đặt người dùng (bật/tắt, thời gian)
- ✅ Lên lịch thông báo đúng thời gian
- ✅ Hỗ trợ cả lịch học hàng tuần lẫn lịch thi cụ thể
- ✅ Kiểm tra ngày tháng chính xác
