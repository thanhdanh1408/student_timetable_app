# 🛠️ Developer Guide - Student Timetable App

## Quick Start

### 1. Setup Environment
```bash
# Install Flutter (3.x+)
flutter doctor

# Clone repository and setup
cd student_timetable_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Run App
```bash
# Web (Edge)
flutter run -d edge

# Android
flutter run -d emulator

# iOS
flutter run -d simulator
```

### 3. Hot Reload/Restart
- **Hot Reload (r)**: Fast refresh for UI changes
- **Hot Restart (R)**: Full app restart when data models change
- **Quit (q)**: Exit app

---

## 📐 Architecture Pattern

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│        PRESENTATION LAYER           │
│  (Pages, Providers, Widgets)        │
├─────────────────────────────────────┤
│        DOMAIN LAYER                 │
│  (Entities, Repositories, Usecases) │
├─────────────────────────────────────┤
│        DATA LAYER                   │
│  (Repository Implementation, Hive)  │
└─────────────────────────────────────┘
```

### Dependency Flow
```
Presentation (Providers) 
    ↓ uses
Usecases
    ↓ depends on
Repositories (abstract)
    ↓ implemented by
Repository Implementations
    ↓ uses
Data Sources (Hive)
```

---

## 🎯 Adding a New Feature

### Step 1: Create Feature Folder Structure
```bash
lib/features/your_feature/
├── domain/
│   ├── entities/
│   │   ├── your_entity.dart
│   │   └── your_entity.g.dart (auto-generated)
│   ├── repositories/
│   │   └── your_repository.dart
│   ├── repositories_impl/
│   │   └── your_repository_impl.dart
│   └── usecases/
│       ├── get_your_entity_usecase.dart
│       ├── add_your_entity_usecase.dart
│       ├── update_your_entity_usecase.dart
│       └── delete_your_entity_usecase.dart
└── presentation/
    ├── pages/
    │   └── your_feature_page.dart
    ├── providers/
    │   └── your_feature_provider.dart
    └── widgets/
        ├── your_entity_card.dart
        └── your_entity_form_dialog.dart
```

### Step 2: Create Entity with Hive Adapter

**File**: `lib/features/your_feature/domain/entities/your_entity.dart`
```dart
import 'package:hive/hive.dart';

part 'your_entity.g.dart';

@HiveType(typeId: 5)  // Assign next available typeId
class YourEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime createdAt;

  YourEntity({
    required this.id,
    required this.name,
    required this.createdAt,
  });
}
```

**Generate adapter**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Create Repository Interface

**File**: `lib/features/your_feature/domain/repositories/your_repository.dart`
```dart
abstract class YourRepository {
  Future<void> init();
  Future<List<YourEntity>> getAll();
  Future<void> add(YourEntity entity);
  Future<void> update(YourEntity entity);
  Future<void> delete(String id);
}
```

### Step 4: Implement Repository

**File**: `lib/features/your_feature/domain/repositories_impl/your_repository_impl.dart`
```dart
import 'package:hive_flutter/hive_flutter.dart';
import '../entities/your_entity.dart';
import '../repositories/your_repository.dart';

class YourRepositoryImpl implements YourRepository {
  late Box<YourEntity> _box;

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen('your_box_name')) {
      _box = await Hive.openBox<YourEntity>('your_box_name');
    } else {
      _box = Hive.box<YourEntity>('your_box_name');
    }
  }

  @override
  Future<List<YourEntity>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> add(YourEntity entity) async {
    await _box.put(entity.id, entity);
  }

  @override
  Future<void> update(YourEntity entity) async {
    await _box.put(entity.id, entity);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
```

### Step 5: Create Usecases

**File**: `lib/features/your_feature/domain/usecases/get_your_entity_usecase.dart`
```dart
import '../entities/your_entity.dart';
import '../repositories/your_repository.dart';

class GetYourEntityUsecase {
  final YourRepository repository;

  GetYourEntityUsecase({required this.repository});

  Future<List<YourEntity>> call() async {
    return await repository.getAll();
  }
}
```

**File**: `lib/features/your_feature/domain/usecases/add_your_entity_usecase.dart`
```dart
import '../entities/your_entity.dart';
import '../repositories/your_repository.dart';

class AddYourEntityUsecase {
  final YourRepository repository;

  AddYourEntityUsecase({required this.repository});

  Future<void> call(YourEntity entity) async {
    await repository.add(entity);
  }
}
```

### Step 6: Create Provider

**File**: `lib/features/your_feature/presentation/providers/your_feature_provider.dart`
```dart
import 'package:flutter/material.dart';
import '../../domain/entities/your_entity.dart';
import '../../domain/usecases/get_your_entity_usecase.dart';
import '../../domain/usecases/add_your_entity_usecase.dart';
import '../../domain/usecases/update_your_entity_usecase.dart';
import '../../domain/usecases/delete_your_entity_usecase.dart';

class YourFeatureProvider with ChangeNotifier {
  final GetYourEntityUsecase _getUsecase;
  final AddYourEntityUsecase _addUsecase;
  final UpdateYourEntityUsecase _updateUsecase;
  final DeleteYourEntityUsecase _deleteUsecase;

  List<YourEntity> _items = [];
  String? _error;
  bool _isLoading = false;

  YourFeatureProvider({
    required GetYourEntityUsecase get,
    required AddYourEntityUsecase add,
    required UpdateYourEntityUsecase update,
    required DeleteYourEntityUsecase delete,
  })  : _getUsecase = get,
        _addUsecase = add,
        _updateUsecase = update,
        _deleteUsecase = delete;

  List<YourEntity> get items => _items;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _getUsecase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(YourEntity item) async {
    try {
      await _addUsecase(item);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> update(YourEntity item) async {
    try {
      await _updateUsecase(item);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    try {
      await _deleteUsecase(id);
      await load();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
```

### Step 7: Create Page

**File**: `lib/features/your_feature/presentation/pages/your_feature_page.dart`
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/your_feature_provider.dart';
import '../widgets/your_entity_card.dart';

class YourFeaturePage extends StatefulWidget {
  const YourFeaturePage({Key? key}) : super(key: key);

  @override
  State<YourFeaturePage> createState() => _YourFeaturePageState();
}

class _YourFeaturePageState extends State<YourFeaturePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<YourFeatureProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Feature'),
        centerTitle: true,
      ),
      body: Consumer<YourFeatureProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Error: ${provider.error}'),
            );
          }

          if (provider.items.isEmpty) {
            return const Center(
              child: Text('No items found'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.load(),
            child: ListView.builder(
              itemCount: provider.items.length,
              itemBuilder: (context, index) {
                final item = provider.items[index];
                return YourEntityCard(
                  item: item,
                  onDelete: () => provider.delete(item.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
```

### Step 8: Register in main.dart

**Update**: `lib/main.dart`
```dart
// 1. Import all classes
import 'features/your_feature/domain/entities/your_entity.dart';
import 'features/your_feature/domain/repositories_impl/your_repository_impl.dart';
import 'features/your_feature/domain/usecases/get_your_entity_usecase.dart';
import 'features/your_feature/domain/usecases/add_your_entity_usecase.dart';
import 'features/your_feature/domain/usecases/update_your_entity_usecase.dart';
import 'features/your_feature/domain/usecases/delete_your_entity_usecase.dart';
import 'features/your_feature/presentation/providers/your_feature_provider.dart';

void main() async {
  // ...existing code...

  // 2. Register Hive adapter (in adapter registration section)
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(YourEntityAdapter());
  }

  // 3. Initialize repository (in repo init section)
  final yourRepo = YourRepositoryImpl();
  await yourRepo.init();

  // 4. Create usecases (in usecase initialization section)
  final getYourEntityUsecase = GetYourEntityUsecase(repository: yourRepo);
  final addYourEntityUsecase = AddYourEntityUsecase(repository: yourRepo);
  final updateYourEntityUsecase = UpdateYourEntityUsecase(repository: yourRepo);
  final deleteYourEntityUsecase = DeleteYourEntityUsecase(repository: yourRepo);

  // 5. Register provider (in MultiProvider section)
  ChangeNotifierProvider(
    create: (_) => YourFeatureProvider(
      get: getYourEntityUsecase,
      add: addYourEntityUsecase,
      update: updateYourEntityUsecase,
      delete: deleteYourEntityUsecase,
    ),
  ),
}
```

### Step 9: Add Route to app_routes.dart

**Update**: `lib/core/config/app_routes.dart`
```dart
// In route definitions
GoRoute(
  path: '/your-feature',
  builder: (context, state) => const YourFeaturePage(),
),

// In bottom nav destinations
BottomNavigationBarItem(
  icon: const Icon(Icons.your_icon),
  label: 'Your Feature',
)
```

---

## 🔍 Common Patterns

### Pattern 1: Form Validation
```dart
class YourFormDialog extends StatefulWidget {
  @override
  State<YourFormDialog> createState() => _YourFormDialogState();
}

class _YourFormDialogState extends State<YourFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Your Entity'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Name *'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Process form
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
```

### Pattern 2: Error Handling
```dart
Future<void> load() async {
  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _items = await _getUsecase();
  } catch (e) {
    _error = 'Failed to load: $e';
    // Show user-friendly message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_error!)),
    );
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

### Pattern 3: Delete Confirmation
```dart
void _showDeleteConfirmation(String id) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Confirmation'),
      content: const Text('Are you sure?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            context.read<YourFeatureProvider>().delete(id);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deleted successfully')),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
```

### Pattern 4: Search/Filter
```dart
String _searchQuery = '';

List<YourEntity> get filteredItems {
  if (_searchQuery.isEmpty) {
    return _items;
  }
  return _items
      .where((item) => item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();
}

// In TextField
TextField(
  decoration: InputDecoration(
    hintText: 'Search...',
    prefixIcon: const Icon(Icons.search),
  ),
  onChanged: (value) {
    _searchQuery = value;
    notifyListeners();
  },
)
```

---

## 🧪 Testing

### Unit Tests (Example)
```dart
// test/features/your_feature/domain/usecases/get_your_entity_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('GetYourEntityUsecase', () {
    test('should return list of entities from repository', () async {
      // Arrange
      final mockRepository = MockYourRepository();
      final usecase = GetYourEntityUsecase(repository: mockRepository);
      
      // Act
      final result = await usecase();
      
      // Assert
      expect(result, isA<List<YourEntity>>());
    });
  });
}
```

---

## 📝 Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| **Entity** | `[Name]Entity` | `SubjectEntity`, `ExamEntity` |
| **Repository** | `[Name]Repository` | `SubjectsRepository` |
| **Repository Impl** | `[Name]RepositoryImpl` | `SubjectsRepositoryImpl` |
| **Usecase** | `[Verb][Name]Usecase` | `GetSubjectsUsecase`, `AddSubjectUsecase` |
| **Provider** | `[Name]Provider` | `SubjectsProvider` |
| **Page** | `[Name]Page` | `SubjectsPage` |
| **Widget/Card** | `[Name]Card` or `[Name]Widget` | `SubjectCard`, `SubjectFormDialog` |
| **Box Name** | `[name]_box` | `subjects_box`, `exams_box` |

---

## 🐛 Debugging Tips

### 1. Check Hive Boxes
```dart
// In debug console
await Hive.openBox('subjects_box').then((box) {
  print('Box size: ${box.length}');
  box.values.forEach((item) => print(item));
});
```

### 2. Enable Provider Logging
```dart
// In main.dart
return MultiProvider(
  providers: [...],
  child: Consumer<YourProvider>(
    builder: (context, provider, _) {
      print('Provider data: ${provider.items}');
      return YourApp();
    },
  ),
);
```

### 3. Trace Navigation
```dart
// In app_routes.dart
GoRouter(
  observers: [
    GoRouterObserver(),  // Add custom observer
  ],
);
```

---

## 📚 Useful Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Hive Documentation](https://docs.hivedb.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Clean Architecture](https://medium.com/flutter-community/clean-architecture-in-flutter)

---

**Happy coding! 🚀**
