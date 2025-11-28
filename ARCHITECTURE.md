# 📚 Student Timetable App - Complete Architecture

## Project Overview
**Student Timetable App** là một ứng dụng Flutter web hoàn thiện cho quản lý lịch học và lịch thi của sinh viên.

- **Architecture**: Clean Architecture with MVVM pattern
- **State Management**: Provider
- **Local Storage**: Hive
- **Navigation**: GoRouter

---

## 🏗️ Project Structure

### Complete Feature Architecture (Each feature follows Clean Architecture)

```
lib/
├── features/
│   ├── authentication/          ✅ Complete
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user_entity.dart
│   │   │   │   └── user_entity.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   ├── repositories_impl/
│   │   │   │   └── auth_repository_impl.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       └── widgets/
│   │           ├── custom_textfield.dart
│   │           ├── custom_button.dart
│   │           ├── auth_form.dart
│   │           └── error_dialog.dart
│   │
│   ├── subjects/                 ✅ Complete
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── subject_entity.dart
│   │   │   │   └── subject_entity.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── subjects_repository.dart
│   │   │   ├── repositories_impl/
│   │   │   │   └── subjects_repository_impl.dart
│   │   │   └── usecases/
│   │   │       ├── get_subjects_usecase.dart
│   │   │       ├── add_subject_usecase.dart
│   │   │       ├── update_subject_usecase.dart
│   │   │       └── delete_subject_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── subjects_page.dart
│   │       ├── providers/
│   │       │   └── subjects_provider.dart
│   │       └── widgets/
│   │           ├── subject_card.dart
│   │           ├── subject_form_dialog.dart
│   │           └── delete_confirm_dialog.dart
│   │
│   ├── schedule/                 ✅ Complete
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── schedule_entity.dart
│   │   │   │   └── schedule_entity.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── schedule_repository.dart
│   │   │   ├── repositories_impl/
│   │   │   │   └── schedule_repository_impl.dart
│   │   │   └── usecases/
│   │   │       ├── get_schedules_usecase.dart
│   │   │       ├── add_schedule_usecase.dart
│   │   │       ├── update_schedule_usecase.dart
│   │   │       └── delete_schedule_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── schedule_page.dart
│   │       ├── providers/
│   │       │   └── schedule_provider.dart
│   │       └── widgets/
│   │           ├── schedule_card.dart
│   │           ├── schedule_form_dialog.dart
│   │           └── schedule_timetable.dart
│   │
│   ├── exam/                     ✅ Complete
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── exam_entity.dart
│   │   │   │   └── exam_entity.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── exam_repository.dart
│   │   │   ├── repositories_impl/
│   │   │   │   └── exam_repository_impl.dart
│   │   │   └── usecases/
│   │   │       ├── get_exams_usecase.dart
│   │   │       ├── add_exam_usecase.dart
│   │   │       ├── update_exam_usecase.dart
│   │   │       └── delete_exam_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── exam_page.dart
│   │       ├── providers/
│   │       │   └── exam_provider.dart
│   │       └── widgets/
│   │           ├── exam_card.dart
│   │           └── exam_form_dialog.dart
│   │
│   ├── home/                     ✅ Complete
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── home_summary_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── home_repository.dart
│   │   │   ├── repositories_impl/
│   │   │   │   └── home_repository_impl.dart
│   │   │   └── usecases/
│   │   │       └── get_home_summary_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── home_page.dart
│   │       └── providers/
│   │           └── home_provider.dart
│   │
│   ├── notifications/            ✅ Complete (NEW)
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── notification_entity.dart
│   │   │   │   └── notification_entity.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository.dart
│   │   │   ├── repositories_impl/
│   │   │   │   └── notification_repository_impl.dart
│   │   │   └── usecases/
│   │   │       ├── get_notifications_usecase.dart
│   │   │       ├── add_notification_usecase.dart
│   │   │       └── delete_notification_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── notification_page.dart
│   │       └── providers/
│   │           └── notification_provider.dart
│   │
│   └── settings/                 ✅ Complete (NEW)
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── user_settings_entity.dart
│       │   │   └── user_settings_entity.g.dart
│       │   ├── repositories/
│       │   │   └── settings_repository.dart
│       │   ├── repositories_impl/
│       │   │   └── settings_repository_impl.dart
│       │   └── usecases/
│       │       ├── get_settings_usecase.dart
│       │       └── save_settings_usecase.dart
│       └── presentation/
│           ├── pages/
│           │   └── settings_page.dart
│           └── providers/
│               └── settings_provider.dart
│
├── core/
│   ├── config/
│   │   └── app_routes.dart       (GoRouter configuration)
│   └── utils/
│       └── demo_data_initializer.dart
│
├── shared/
│   ├── models/
│   ├── widgets/
│   │   └── placeholder_page.dart
│   └── services/
│
├── app.dart
├── main.dart
└── pubspec.yaml
```

---

## 🔑 Key Features

### 1. **Authentication (Mock)**
- **Entities**: `UserEntity` (fullname, email, password)
- **Repositories**: Mock auth with Hive storage
- **CRUD**: Login, Register, Logout, Get Current User
- **Pages**: LoginPage, RegisterPage
- **Auth Flow**: Email/password validation + GoRouter redirect

### 2. **Subjects Management**
- **Entity**: SubjectEntity (name, teacher, room, day, times, credits)
- **CRUD**: Create, Read, Update, Delete
- **Features**: Search, Filter by day, Display cards with actions
- **Validation**: Required fields (name, teacher, room, day, times)
- **Error Handling**: Try-catch with SnackBar feedback

### 3. **Schedule Management**
- **Entity**: ScheduleEntity (subject, teacher, room, day, start/end time)
- **CRUD**: Full CRUD with auto-fill from subjects
- **Features**: Search, Filter by day, Timetable view
- **Smart Linking**: Auto-fill times from selected subject
- **Validation**: Room override allowed

### 4. **Exam Management**
- **Entity**: ExamEntity (subject, teacher, room, exam date, time)
- **CRUD**: Full CRUD
- **Features**: Search, Filter (upcoming/past), Countdown timer
- **Date Picker**: Flutter material DatePicker for exam dates
- **Smart Display**: Days left calculator

### 5. **Home Dashboard**
- **Stats Cards**: 4 cards showing:
  - Total subjects count
  - Today's schedule count
  - Upcoming exams (within 3 days)
  - Total notifications
- **Today's Schedule**: List of today's classes
- **Upcoming Exams**: 3-day preview
- **Real-time Data**: Pulls from Subjects, Schedule, Exam providers
- **Refresh**: Manual refresh + RefreshIndicator

### 6. **Notifications (NEW)**
- **Entity**: NotificationEntity (title, body, type, created_at, is_read)
- **Auto-generation**: From Schedule (today's classes) + Exam (3-day preview)
- **Features**: List view with dismiss, combined data streams
- **Sorting**: By date (newest first)

### 7. **Settings (NEW)**
- **Entity**: UserSettingsEntity (darkMode, notifications, language)
- **Features**: 
  - User profile display (avatar, name, email)
  - Dark mode toggle
  - Notifications toggle
  - Language selector
  - About dialog
  - **Logout with confirmation** → Redirect to login

---

## 🗄️ Data Models (Hive Entities)

| Entity | TypeId | Fields |
|--------|--------|--------|
| **SubjectEntity** | 0 | id, subjectName, teacherName, room, dayOfWeek, startTime, endTime, semester, credit |
| **ScheduleEntity** | 1 | id, subjectName, teacherName, room, dayOfWeek, startTime, endTime, semester |
| **ExamEntity** | 2 | id, subjectName, teacherName, room, examDate, startTime, endTime, semester |
| **NotificationEntity** | 3 | id, title, body, type, createdAt, isRead, relatedId |
| **UserSettingsEntity** | 4 | userId, darkMode, notifications, language, createdAt, updatedAt |

---

## 🔄 State Management (Provider Architecture)

### Providers Structure (Each Feature)
```dart
class [Feature]Provider with ChangeNotifier {
  // Data
  List<[Entity]> _items = [];
  String? _error;
  bool _isLoading = false;

  // Getters
  get items => _items;
  get error => _error;
  get isLoading => _isLoading;

  // Constructor (Inject usecases)
  [Feature]Provider({
    required Get[Entity]Usecase get,
    required Add[Entity]Usecase add,
    required Update[Entity]Usecase update,
    required Delete[Entity]Usecase delete,
  });

  // Methods
  Future<void> load() async { ... }
  Future<void> add([Entity] item) async { ... }
  Future<void> update([Entity] item) async { ... }
  Future<void> delete(int index) async { ... }
}
```

### Provider Registration (main.dart)
All 7 feature providers registered as `ChangeNotifierProvider`:
- AuthProvider
- SubjectsProvider
- ScheduleProvider
- ExamProvider
- HomeProvider
- NotificationProvider
- SettingsProvider

---

## 🌐 Navigation (GoRouter)

### Routes
```
/login                       → LoginPage
/register                    → RegisterPage
/home                        → HomePage (with bottom nav shell)
/subjects                    → SubjectsPage
/schedule                    → SchedulePage
/exam                        → ExamPage
/notification                → NotificationPage (NEW)
/settings                    → SettingsPage (NEW)
```

### Auth Redirect Logic
- If NOT logged in + accessing protected routes → Redirect to /login
- If logged in + accessing /login or /register → Redirect to /home
- Bottom navigation bar for easy feature switching

---

## 💾 Local Storage (Hive)

### Boxes (Persisted)
```
auth_user          → Stores logged-in user info
subjects_box       → SubjectEntity[]
schedules_box      → ScheduleEntity[]
exams_box          → ExamEntity[]
notifications_box  → NotificationEntity[] (NEW)
settings_box       → UserSettingsEntity[] (NEW)
```

### Initialization (main.dart)
```dart
1. Hive.initFlutter()
2. Register adapters (typeId 0-4)
3. Open all boxes
4. Initialize repositories
5. Initialize demo data
6. Create usecases
7. Create providers
8. Run app
```

---

## 🧪 Demo Data

Auto-populated on first run:

### Demo Accounts
```
demo@test.com / demo123
student1@example.com / password123
student2@example.com / password123
```

### Sample Data
- **3 Subjects**: Toán Cao Cấp, Lập Trình Di Động, Tiếng Anh
- **2 Schedules**: Today's classes with auto-populated times
- **2 Exams**: Next 2 days with countdown display
- **Settings**: Default (Vi, notifications on, light mode)

---

## ✅ Clean Architecture Checklist

### Each Feature Has:
- ✅ Entity (Hive serializable)
- ✅ Repository (abstract interface)
- ✅ RepositoryImpl (Hive implementation)
- ✅ Usecases (business logic)
- ✅ Provider (state management)
- ✅ Pages (UI screens)
- ✅ Widgets (reusable components)
- ✅ Error Handling (try-catch + user feedback)
- ✅ Validation (form inputs)
- ✅ Search/Filter (if applicable)

---

## 🚀 Running the App

```bash
# Install dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run on Edge browser
flutter run -d edge --web-port 5000

# Hot reload (r) / Hot restart (R) / Quit (q)
```

---

## 📋 Testing Checklist

- [ ] Login with demo account
- [ ] Register new account
- [ ] Add subject with validation
- [ ] Edit subject
- [ ] Delete subject with confirmation
- [ ] Add schedule with auto-fill
- [ ] Edit/delete schedule
- [ ] Add exam with date picker
- [ ] View exam countdown
- [ ] Check home dashboard stats
- [ ] View notifications (today + upcoming)
- [ ] Toggle settings (dark mode, notifications, language)
- [ ] Logout with redirect to login

---

## 🎨 UI/UX Features

- **Material Design 3** with custom color scheme (Indigo primary)
- **Bottom Navigation Bar** for feature switching
- **RefreshIndicator** on all list pages
- **Search/Filter** on subjects, schedule, exam pages
- **Delete Confirmation** dialogs
- **Error SnackBars** for user feedback
- **Loading States** with CircularProgressIndicator
- **Form Validation** with required field indicators (*)
- **Date/Time Pickers** for better UX

---

## 🛠️ Technical Stack

| Component | Technology |
|-----------|------------|
| **Frontend Framework** | Flutter 3.x |
| **UI Toolkit** | Material Design 3 |
| **State Management** | Provider 6.x |
| **Local Storage** | Hive 2.x |
| **Serialization** | Hive + build_runner |
| **Navigation** | GoRouter 13.x |
| **HTTP** | None (mock data only) |

---

## 📱 Platform Support

- ✅ **Web** (Edge, Chrome)
- ✅ **Android** (built-in support)
- ✅ **iOS** (built-in support)

---

## 🎯 Future Enhancements

- [ ] Export timetable to PDF/Calendar
- [ ] Cloud sync (Firebase/backend)
- [ ] Multi-language support (Vi/En)
- [ ] Dark theme implementation
- [ ] Push notifications
- [ ] Class attendance tracking
- [ ] Grade management
- [ ] Notes per subject

---

**Project completed with full Clean Architecture implementation! ✨**
