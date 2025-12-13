# ⚡ Hướng dẫn nhanh - Sửa chữa lỗi thông báo

## 🎯 Vấn đề
Khi thêm lịch học/thi và set thông báo trước 5 phút, **nhưng không thấy thông báo**.

## 🔧 Những gì đã sửa

### 1️⃣ **ExamProvider** (Lịch thi)
- ✅ Thêm `NotificationSettingsProvider` 
- ✅ Kiểm tra setting "bật/tắt" thông báo
- ✅ Lấy thời gian nhắc nhở từ cài đặt (5p, 10p, 15p, 30p, 60p)
- ✅ Tính đúng thời gian: **notification_time = exam_time - reminder_minutes**

### 2️⃣ **ScheduleProvider** (Lịch học hàng tuần)
- ✅ Sửa conversion dayOfWeek (app dùng 2-8, Dart dùng 1-7)
- ✅ Tính đúng ngày học tiếp theo

### 3️⃣ **main.dart** 
- ✅ Kết nối `ExamProvider` với `NotificationSettingsProvider`

### 4️⃣ **NotificationService**
- ✅ Cải thiện documentation (rõ ràng hơn về cách tính `scheduledTime`)

## 📂 File đã sửa

```
✏️ lib/features/exam/presentation/providers/exam_provider.dart
✏️ lib/main.dart
✏️ lib/features/schedule/presentation/providers/schedule_provider.dart
✏️ lib/core/services/notification_service.dart
```

## 🧪 Kiểm tra thành công

### Test 1: Lịch thi
1. Settings → "Thông báo lịch thi" → "5 phút trước"
2. Thêm lịch thi
3. Settings → "🧪 Test Notification" → Debug
4. ✅ Xác nhận thông báo được schedule với `scheduledTime = exam_time - 5 phút`

### Test 2: Lịch học
1. Settings → "Thông báo lịch học" → "10 phút trước"
2. Thêm lịch học (ngày tiếp theo)
3. Debug
4. ✅ Xác nhận thông báo được schedule với `scheduledTime = class_time - 10 phút`

### Test 3: Tắt thông báo
1. Settings → Tắt "Thông báo lịch thi"
2. Thêm lịch thi
3. Debug
4. ✅ Không thấy thông báo được schedule

## 📊 Sự khác biệt trước/sau

| Tính năng | Trước ❌ | Sau ✅ |
|----------|---------|--------|
| **Exam Notification** | Hardcode 10 phút | Dùng setting của user (5/10/15/30/60p) |
| **Tuân theo setting** | Không | Có (bật/tắt, thời gian tùy chỉnh) |
| **Tính thời gian** | `scheduledTime = exam_time` ❌ | `scheduledTime = exam_time - minutes` ✅ |
| **Schedule cho lịch học** | Tính sai ngày | Tính đúng |
| **Debug logs** | Ít | Chi tiết |

## 💡 Cách hoạt động

### User experience:
```
Bật app → Settings → Set "Thông báo trước 5 phút" 
    ↓
Thêm lịch thi lúc 14:00 ngày 20/12
    ↓
Ứng dụng tự động schedule thông báo cho 13:55 (5 phút trước)
    ↓
Lúc 13:55 → Thông báo hiển thị ✓
```

## 🚀 Tiếp theo
- Hiện tại chưa có background notification (khi app đóng)
- Có thể thêm `workmanager` hoặc `flutter_background_service` nếu cần
- Hiện tại chỉ support local notifications khi app đang chạy

## 📝 Ghi chú

- **Logs**: Mỗi lần add/edit schedule/exam, kiểm tra logcat để confirm
- **Timezone**: App đặt timezone = "Asia/Ho_Chi_Minh" 
- **Future notifications only**: Nếu notification_time đã qua, không schedule

---

**Câu hỏi?** Xem file `DETAILED_ERROR_ANALYSIS.md` để hiểu sâu hơn.
