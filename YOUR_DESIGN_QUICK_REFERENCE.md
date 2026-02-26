# Your Design Screen - Quick Reference

## 🚀 Usage

### Navigate to Screen:
```dart
context.go(AppPath.yourdesign); // Route: /your-design
```

### Access from Bottom Nav:
Tap "Your Design" tab (index 2)

---

## 🎯 Key Features

### 1. **View Toggle**
- Default: Grid view (2 columns)
- Tap icon to switch to List view
- Icon changes automatically

### 2. **Search Projects**
- Type in search bar
- Real-time filtering
- Case-insensitive

### 3. **Project Actions**
- Tap project → Open for editing
- Tap ⋮ → Download or Delete
- Pull down → Refresh

---

## 📊 Project Data

### Sample Projects (6):
```dart
1. Untitled Design (image_first.png) + Whiteboard badge
2. Coffee Bag Design (image_second.png)
3. AI Coffee Bag Design (image_third.png)
4. Coffee Bag Design (image_fourth.png)
5. AI Coffee Bag Design (image_fiveth.png)
6. Coffee Bag Design (image_six.png)
```

All marked as "Private" with lock icon

---

## 🎨 UI Elements

### Grid Item:
```
┌─────────────┐
│   [Image]   │
│             │
│   ⋮ (menu)  │
├─────────────┤
│ Title       │
│ 🔒 Private  │
└─────────────┘
```

### List Item:
```
┌────┬──────────────────┬──┐
│Img │ Title            │⋮ │
│    │ 🔒 Private       │  │
└────┴──────────────────┴──┘
```

---

## 💻 Code Examples

### Get Controller:
```dart
final controller = Get.put(YourDesignController());
```

### Toggle View:
```dart
controller.toggleView();
```

### Search:
```dart
controller.updateSearchQuery('Coffee');
```

### Download:
```dart
controller.downloadProject(project);
```

### Delete:
```dart
controller.deleteProject(project);
```

### Refresh:
```dart
await controller.refresh();
```

---

## 🔧 Customization

### Add More Projects:
Edit `_initializeProjects()` in controller:
```dart
_projects.value = [
  DesignProject(
    id: '7',
    title: 'New Design',
    imagePath: 'assets/images/your_image.png',
    isPrivate: false,
    category: 'Label',
  ),
  // ... more projects
];
```

### Change Colors:
Modify in view file:
```dart
color: AppColors.primary // Change primary color
backgroundColor: Colors.white // Change background
```

### Adjust Layout:
```dart
crossAxisCount: 3, // Change grid columns
height: 200.h, // Change thumbnail height
```

---

## 🎭 Popup Menu Options

### Download:
- Icon: `Icons.download`
- Color: Black
- Action: Downloads project
- Feedback: Success snackbar

### Delete:
- Icon: `Icons.delete_outline`
- Color: Red
- Action: Shows confirmation dialog
- Feedback: Success snackbar after delete

---

## 📱 Navigation Bar

```dart
bottomNavigationBar: CustomNavBar(
  currentIndex: 2, // Your Design = index 2
  onTap: (index) => _handleNavigation(context, index),
)
```

### Index Map:
- 0 = Create
- 1 = Collections
- 2 = Your Design ⭐
- 3 = Profile

---

## ✨ Animations

### Pull-to-Refresh:
```dart
RefreshIndicator(
  onRefresh: controller.refresh,
  color: AppColors.primary,
  // ...
)
```

### Loading State:
```dart
if (controller.isLoading) {
  return const _LoadingView();
}
```

### Empty State:
```dart
if (projects.isEmpty) {
  return const _EmptyView();
}
```

---

## 🐛 Debugging

### Check Controller State:
```dart
print('Loading: ${controller.isLoading}');
print('Grid View: ${controller.isGridView}');
print('Projects: ${controller.projects.length}');
```

### Common Issues:

**Projects not showing?**
- Check image paths exist
- Verify assets in pubspec.yaml
- Check controller initialization

**Search not working?**
- Verify `updateSearchQuery()` is called
- Check filter logic in controller

**Navigation not working?**
- Verify route is added to route_path.dart
- Check AppPath.yourdesign is defined

---

## 📦 Required Files

✅ Controller: `lib/controllers/your_design_controller/your_design_controller.dart`
✅ View: `lib/views/your_design/your_design.dart`
✅ Route: Added to `lib/routes/route_path.dart`
✅ Binding: Added to `lib/dependency/binding.dart`
✅ Assets: 6 images in `assets/images/`

---

## 🎯 Next Steps

1. **Add Backend Integration**
   ```dart
   Future<void> loadProjectsFromAPI() async {
     final response = await api.getProjects();
     _projects.value = response.data;
   }
   ```

2. **Add Lottie Animations**
   ```yaml
   dependencies:
     lottie: ^3.0.0
   ```
   ```dart
   Lottie.asset('assets/animations/empty.json')
   ```

3. **Add Sorting**
   ```dart
   void sortByDate() {
     _projects.sort((a, b) => 
       b.lastModified.compareTo(a.lastModified));
   }
   ```

4. **Add Filtering**
   ```dart
   void filterByCategory(String category) {
     _filteredProjects.value = _projects
       .where((p) => p.category == category)
       .toList();
   }
   ```

---

**Status:** ✅ Ready to use
**Version:** 1.0.0
**Last Updated:** February 25, 2026
