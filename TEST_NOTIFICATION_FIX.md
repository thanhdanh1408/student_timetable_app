# 🎬 Hướng dẫn kiểm tra sửa chữa (Video Script)

## 📺 Test Scenario 1: Thêm lịch thi với thông báo 5 phút

### 🎯 Mục tiêu:
Xác nhận rằng khi thêm lịch thi, thông báo được schedule **chính xác 5 phút trước giờ thi** (không phải giờ thi luôn).

### 📝 Các bước:

#### Step 1: Cài đặt thông báo
1. Mở app
2. Vào **Settings** (Cài đặt)
3. Tìm mục **"Thông báo lịch thi"**
4. Chọn **"5 phút trước"** từ dropdown
5. Quay lại (tự động save)

```
Mong đợi: Subtitle sẽ hiển thị "5 phút trước"
```

#### Step 2: Thêm lịch thi
1. Vào **Exam** (Lịch thi)
2. Nhấn nút **Add/Thêm** (dấu +)
3. Điền:
   - **Subject:** Toán
   - **Room:** A101
   - **Date:** Chọn ngày trong tương lai (ví dụ: 20/12/2025)
   - **Start time:** 14:00 (2 giờ chiều)
   - **End time:** 15:00
4. Nhấn **Save/Lưu**

```
Mong đợi: Exam được thêm vào danh sách
```

#### Step 3: Kiểm tra notification được schedule
1. Vào **Settings** → **"🧪 Test Notification"**
2. Nhấn nút **"Debug"** (biểu tượng bug)
3. Sẽ hiển thị một popup với thông tin debug

```
Tìm kiếm trong danh sách:
- ID: tương ứng với exam
- Title: "📝 Sắp đến giờ thi: Toán"
- Scheduled time: 2025-12-20 13:55 (14:00 - 5 phút)
```

#### Step 4: Xác nhận logs
1. Mở logcat trong Android Studio
2. Tìm logs sau:

```
📝 EXAM NOTIFICATION SETUP
📝 Subject: Toán
📝 Exam date/time: 2025-12-20 14:00:00.000
📝 Reminder time setting: 5 minutes before
📝 Notification time: 2025-12-20 13:55:00.000
✅ Exam notification scheduled successfully
```

### ✅ Test Passed Criteria:
- [ ] Settings lưu cài đặt 5 phút
- [ ] Exam được thêm thành công
- [ ] Notification được schedule
- [ ] Scheduled time = exam time - 5 minutes
- [ ] Logs hiển thị "successfully"

---

## 📺 Test Scenario 2: Thêm lịch học hàng tuần

### 🎯 Mục tiêu:
Xác nhận rằng lịch học hàng tuần được schedule đúng ngày, với thông báo 10 phút trước.

### 📝 Các bước:

#### Step 1: Cài đặt thông báo lịch học
1. **Settings** → **"Thông báo lịch học"**
2. Chọn **"10 phút trước"**

#### Step 2: Thêm lịch học
1. Vào **Schedule** (Lịch học)
2. Nhấn **Add**
3. Điền:
   - **Subject:** Toán
   - **Day:** Thứ 3 (hoặc ngày nào tiếp theo)
   - **Start time:** 09:00
   - **End time:** 10:30
   - **Room:** A102
4. Nhấn **Save**

#### Step 3: Debug kiểm tra
1. **Settings** → **Test Notification** → **Debug**
2. Tìm trong danh sách:

```
Title: "📚 Sắp đến giờ học: Toán"
Next occurrence (class time): [Thứ 3 của tuần tiếp theo] 09:00
Notification time: [Thứ 3] 08:50 (09:00 - 10 phút)
```

#### Step 4: Verify đúng ngày
```
Ví dụ:
- Hôm nay: Thursday (4/12/2025)
- Chọn: Thứ 3 (Tuesday)
- Kết quả: Thứ 3 tuần tới (9/12/2025) 08:50 ✓
```

### ✅ Test Passed Criteria:
- [ ] Settings lưu 10 phút
- [ ] Schedule được thêm
- [ ] Notification được schedule cho ngày **tiếp theo** có Thứ 3
- [ ] Thời gian notification = class time - 10 minutes
- [ ] Ngày tính toán đúng

---

## 📺 Test Scenario 3: Tắt thông báo

### 🎯 Mục tiêu:
Xác nhận rằng khi tắt thông báo, không có notification nào được schedule.

### 📝 Các bước:

#### Step 1: Tắt thông báo lịch thi
1. **Settings**
2. Tìm **"Thông báo lịch thi"**
3. Nhấn **Toggle OFF** (trở thành xám/tắt)
4. Subtitle sẽ hiển thị **"Đã tắt"**

#### Step 2: Thêm lịch thi mới
1. **Exam** → **Add**
2. Nhập:
   - Subject: Văn
   - Room: B101
   - Date: 25/12/2025
   - Time: 10:00
3. Nhấn **Save**

#### Step 3: Debug kiểm tra
1. **Settings** → **Test Notification** → **Debug**
2. **Không nên** thấy notification mới được thêm

```
Logs sẽ hiển thị:
⚠️ Exam notifications are disabled in settings
❌ [EXIT] Notification NOT scheduled
```

### ✅ Test Passed Criteria:
- [ ] Toggle hiển thị "Đã tắt"
- [ ] Exam được thêm vào danh sách
- [ ] **Không** có notification được schedule
- [ ] Logs hiển thị "disabled"

---

## 📺 Test Scenario 4: Thay đổi cài đặt và reschedule

### 🎯 Mục tiêu:
Xác nhận rằng khi thay đổi thời gian nhắc nhở, notification cũ được hủy và lên lịch lại.

### 📝 Các bước:

#### Step 1: Tạo exam với 5 phút
1. **Settings** → **"Thông báo lịch thi"** → **"5 phút trước"**
2. **Exam** → **Add** → Thêm exam Anh lúc 16:00
3. **Debug:** Xác nhận scheduled time = 15:55

#### Step 2: Thay đổi cài đặt
1. **Settings** → **"Thông báo lịch thi"** → **"30 phút trước"**
2. Xác nhận subtitle đổi thành "30 phút trước"

#### Step 3: Edit exam
1. Vào **Exam** → Nhấn vào exam Anh
2. Nhấn **Edit** hoặc **Update**
3. Không cần thay đổi gì, chỉ nhấn **Save**

#### Step 4: Debug kiểm tra
1. **Debug**
2. Tìm exam Anh
3. **Scheduled time phải = 15:30** (16:00 - 30 phút) ✓

### ✅ Test Passed Criteria:
- [ ] Exam được reschedule
- [ ] Notification time thay đổi từ 15:55 → 15:30
- [ ] Logs hiển thị notification được cancel và reschedule

---

## 🔴 Negative Test: Thời gian trong quá khứ

### 🎯 Mục tiêu:
Xác nhận rằng nếu thường báo cần hiển thị trong quá khứ, nó sẽ **không** được schedule.

### 📝 Các bước:

#### Step 1: Thêm exam vào **ngày hôm nay** lúc **09:00**
```
Giả sử lúc này là 14:30
```

1. **Exam** → **Add**
2. Date: Hôm nay (4/12/2025)
3. Time: 09:00
4. Save

#### Step 2: Debug kiểm tra
```
Logs sẽ hiển thị:
📝 Notification time: 2025-12-04 08:55
📝 Current time: 2025-12-04 14:30
⚠️ Notification time is in the past
❌ Notification NOT scheduled
```

### ✅ Test Passed Criteria:
- [ ] Logs hiển thị thời gian notification đã qua
- [ ] Notification **không** được schedule
- [ ] Exam vẫn được lưu (chỉ notification không được schedule)

---

## 📊 Debug Popup Checklist

Khi nhấn **Debug**, popup sẽ hiển thị danh sách notifications đang chờ:

```
Title: 📝 Sắp đến giờ thi: Toán
Body: 30 phút nữa bạn thi Toán – Phòng A101
Scheduled Time: 2025-12-20 13:30
Payload: exam_5

Title: 📚 Sắp đến giờ học: Toán
Body: Phòng A102 • 09:00 - 10:30
Scheduled Time: 2025-12-10 08:50
Payload: schedule_3
```

### ✅ Kiểm tra:
- [ ] Số lượng notification = số exam/schedule được thêm
- [ ] Mỗi notification có ID, title, body, scheduled time
- [ ] Scheduled time = class/exam time - reminder minutes

---

## 🎯 Final Verification

Sau khi hoàn thành tất cả tests, hãy xác nhận:

| Tiêu chí | ✅ |
|---------|---|
| Exam notifications tuân theo cài đặt | ✓ |
| Schedule notifications tuân theo cài đặt | ✓ |
| Ngày tính toán chính xác | ✓ |
| Thời gian tính toán chính xác | ✓ |
| Tắt/bật thông báo hoạt động | ✓ |
| Thay đổi cài đặt có reschedule | ✓ |
| Logs hiển thị chi tiết | ✓ |
| Không có lỗi compile | ✓ |

---

## 🎬 Recording Tips

Nếu muốn record video demo:
1. Clear logcat trước khi start
2. Mở logcat bên cạnh để hiển thị logs real-time
3. Chậm lại khi nhấn debug để dễ thấy chi tiết
4. Highlight cái important (scheduled time = exam_time - minutes)

**Total Test Time:** ~15 phút cho toàn bộ scenarios
