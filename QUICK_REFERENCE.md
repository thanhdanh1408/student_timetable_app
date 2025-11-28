# 📖 Quick Reference Guide

## 🚀 Getting Started (30 seconds)

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run app
flutter run -d edge
```

**Demo Account**: `demo@test.com` / `demo123`

---

## 📂 File Locations (Quick Access)

| Task | File Path |
|------|-----------|
| Add login logic | `lib/features/authentication/presentation/providers/auth_provider.dart` |
| Add new screen | `lib/features/[feature]/presentation/pages/` |
| Add new entity | `lib/features/[feature]/domain/entities/` |
| Add navigation route | `lib/core/config/app_routes.dart` |
| View demo data | `lib/core/utils/demo_data_initializer.dart` |
| Main app entry | `lib/main.dart` |
| App configuration | `lib/app.dart` |
| Shared widgets | `lib/shared/widgets/` |

---

## 🔧 Common Tasks

### Task: Add a new Subject
```dart
// 1. Get provider
final provider = context.read<SubjectsProvider>();

// 2. Create entity
final subject = SubjectEntity(
  id: 'sub_${DateTime.now().millisecondsSinceEpoch}',
  subjectName: 'New Subject',
  teacherName: 'Teacher Name',
  room: 'Room 101',
  dayOfWeek: 'Monday',
  startTime: '08:00',
  endTime: '09:30',
  semester: 1,
  credit: 3,
);

// 3. Add to provider
await provider.add(subject);
```

### Task: Delete an item with confirmation
```dart
showDialog(
  context: context,
  builder: (ctx) => AlertDialog(
    title: const Text('Delete?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(ctx),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          context.read<YourProvider>().delete(itemId);
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deleted')),
          );
        },
        child: const Text('Delete'),
      ),
    ],
  ),
);
```

### Task: Search items
```dart
// 1. Add search state
String _searchQuery = '';

// 2. Filter items
final filtered = provider.items
    .where((item) => item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
    .toList();

// 3. Update on input
TextField(
  onChanged: (value) {
    setState(() => _searchQuery = value);
  },
)
```

### Task: Add error handling
```dart
Future<void> myFunction() async {
  try {
    // Your code here
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
```

---

## 🎨 UI Components

### Standard Button
```dart
ElevatedButton(
  onPressed: () {},
  child: const Text('Click me'),
)
```

### Standard Text Field
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Label',
    hintText: 'Hint text',
    prefixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

### Dialog
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Title'),
    content: const Text('Content'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    ],
  ),
);
```

### SnackBar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Message')),
);
```

### Loading State
```dart
if (provider.isLoading) {
  return const Center(child: CircularProgressIndicator());
}
```

---

## 🗄️ Entity Structure

### Subject Entity
```dart
SubjectEntity(
  id: 'sub_123',
  subjectName: 'Toán Cao Cấp',
  teacherName: 'Dr. Nguyễn',
  room: 'A101',
  dayOfWeek: 'Monday',
  startTime: '08:00',
  endTime: '09:30',
  semester: 1,
  credit: 3,
)
```

### Schedule Entity
```dart
ScheduleEntity(
  id: 'sch_123',
  subjectName: 'Toán Cao Cấp',
  teacherName: 'Dr. Nguyễn',
  room: 'A101',
  dayOfWeek: 'Monday',
  startTime: '08:00',
  endTime: '09:30',
  semester: 1,
)
```

### Exam Entity
```dart
ExamEntity(
  id: 'exam_123',
  subjectName: 'Toán Cao Cấp',
  teacherName: 'Dr. Nguyễn',
  room: 'A101',
  examDate: DateTime(2024, 5, 20),
  startTime: '08:00',
  endTime: '10:00',
  semester: 1,
)
```

---

## 🔌 Provider Usage

### Read Data
```dart
final items = context.read<SubjectsProvider>().items;
```

### Listen to Changes
```dart
return Consumer<SubjectsProvider>(
  builder: (context, provider, _) {
    return Text('Count: ${provider.items.length}');
  },
);
```

### Call Methods
```dart
await context.read<SubjectsProvider>().add(subject);
await context.read<SubjectsProvider>().load();
await context.read<SubjectsProvider>().delete(id);
```

---

## 🗺️ Navigation

### Go to Screen
```dart
GoRouter.of(context).go('/subjects');
```

### Go with Parameters
```dart
GoRouter.of(context).go('/exam?status=upcoming');
```

### Push Dialog
```dart
showDialog(context: context, builder: (_) => MyDialog());
```

---

## 💾 Hive Operations

### Open Box
```dart
final box = await Hive.openBox<SubjectEntity>('subjects_box');
```

### Add Item
```dart
await box.put(subject.id, subject);
```

### Get All Items
```dart
final items = box.values.toList();
```

### Delete Item
```dart
await box.delete(id);
```

### Clear Box
```dart
await box.clear();
```

---

## 🐛 Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| **Late initialization error** | Provider not initialized | Add `init()` calls in `main.dart` |
| **Hive box already open** | Multiple box opens | Check `Hive.isBoxOpen()` before opening |
| **State error during build** | setState during build | Use `addPostFrameCallback` in `initState()` |
| **Adapter not registered** | TypeId mismatch | Run `build_runner build` after entity changes |
| **Navigation not working** | Routes not defined | Add route in `app_routes.dart` |
| **Hot reload not working** | Major code structure change | Use Hot Restart (R) instead |

---

## 📋 Checklist: Before Committing

- [ ] Code compiles without errors
- [ ] No unused imports
- [ ] All providers registered in `main.dart`
- [ ] All entities have typeId assigned
- [ ] Build runner executed after entity changes
- [ ] Error handling added to critical functions
- [ ] Validation added to forms
- [ ] UI tested on browser
- [ ] Documentation updated

---

## 🎯 Architecture Decision Record

### Why Clean Architecture?
- **Testability**: Easy to unit test each layer
- **Maintainability**: Clear separation of concerns
- **Scalability**: Easy to add new features
- **Reusability**: Entities and usecases can be reused

### Why Provider?
- **Simple**: Easy to learn and use
- **Powerful**: Supports complex scenarios
- **Efficient**: Only rebuilds necessary widgets
- **Community**: Large ecosystem and support

### Why Hive?
- **Fast**: Pure Dart implementation, no native code
- **Lightweight**: Low overhead for small datasets
- **NoSQL**: Flexible data structure
- **Offline**: Perfect for mobile-first apps

---

## 🔗 Important Links

- **pubspec.yaml**: All dependencies and versions
- **analysis_options.yaml**: Lint rules
- **main.dart**: App initialization and configuration
- **app_routes.dart**: Navigation configuration
- **auth_provider.dart**: Mock authentication logic

---

## 💡 Best Practices

### 1. Always check null
```dart
if (provider.error != null) {
  // Show error message
}
```

### 2. Use const constructors
```dart
const SizedBox(height: 16)
const Text('Hello')
```

### 3. Extract widgets
```dart
class MyCard extends StatelessWidget {
  // Smaller, reusable components
}
```

### 4. Use meaningful names
```dart
// ❌ Bad
int s;
String d;

// ✅ Good
int subjectCount;
String dateFormatted;
```

### 5. Comment complex logic
```dart
// Calculate days until exam date
final daysLeft = examDate.difference(DateTime.now()).inDays;
```

---

## 🚀 Performance Tips

- Use `const` constructors when possible
- Avoid rebuilding entire lists (use `Consumer` selectively)
- Use `RefreshIndicator` for data refresh
- Cache frequently accessed data
- Use `Future.delayed()` for network simulation

---

## 📞 Support

For issues or questions:
1. Check `ARCHITECTURE.md` for design patterns
2. Check `DEVELOPER_GUIDE.md` for detailed examples
3. Review existing feature implementations as reference
4. Check Flutter/Provider documentation

**Last Updated**: 2024
**Status**: Production Ready ✅
