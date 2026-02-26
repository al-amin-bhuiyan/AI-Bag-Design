# FAQs Help Center - Quick Reference Guide

## 🚀 Quick Start

### Accessing the Screen
```dart
// From any screen with BuildContext:
context.push(AppPath.faqsHelpCenter);

// From Help & Support screen (already implemented):
// Tap "FAQs / Help Center" option
```

---

## 📁 File Locations

```
lib/
├── controllers/
│   └── faqs_help_center_controller/
│       └── faqs_help_center_controller.dart    ← Controller logic
├── views/
│   └── help_support/
│       └── faqs_help_center/
│           └── faqs_help_center.dart            ← UI screen
├── routes/
│   ├── app_path.dart                            ← Route path (updated)
│   └── route_path.dart                          ← Route config (updated)
└── dependency/
    └── binding.dart                             ← Binding (updated)
```

---

## 🎯 Key Features

### ✅ Implemented
- [x] **Expandable FAQs** - Tap to expand/collapse
- [x] **Multiple Expansion** - Multiple FAQs can be open simultaneously
- [x] **Smooth Animations** - 300ms transitions
- [x] **Pull-to-Refresh** - Refresh FAQ content
- [x] **Loading State** - Shows spinner during load
- [x] **Responsive Design** - Works on all screen sizes
- [x] **Back Navigation** - Custom back button

---

## 💻 Code Snippets

### Adding a New FAQ
```dart
// In faqs_help_center_controller.dart, _getFAQsData() method:
FAQItem(
  question: 'Your new question?',
  answer: 'Your detailed answer here. Can be multiple lines.',
),
```

### Getting Controller Instance
```dart
// Method 1: Initialize (if not exists)
final controller = Get.put(FAQsHelpCenterController());

// Method 2: Find existing
final controller = Get.find<FAQsHelpCenterController>();
```

### Manual Operations
```dart
// Expand all FAQs
controller.expandAll();

// Collapse all FAQs
controller.collapseAll();

// Toggle specific FAQ
controller.toggleFAQ(0);  // Toggle first FAQ

// Check if FAQ is expanded
bool isOpen = controller.isExpanded(2);  // Check third FAQ

// Refresh data
await controller.refresh();
```

---

## 🎨 Customization

### Colors
```dart
// Question text color
const Color(0xFF0F0F0F)

// Answer text color
const Color(0xFF6B7280)

// Border color
const Color(0xFFE5E7EB)

// Loading spinner
AppColors.primary
```

### Typography
```dart
// Question
AppFonts.poppinsSemiBold(fontSize: 15.sp)

// Answer
AppFonts.poppinsRegular(fontSize: 13.sp)
```

### Animation Duration
```dart
// Change in view file:
duration: const Duration(milliseconds: 300)  // Default
duration: const Duration(milliseconds: 200)  // Faster
duration: const Duration(milliseconds: 500)  // Slower
```

### Spacing
```dart
// Between FAQ items
bottom: 16.h

// Card padding
horizontal: 16.w, vertical: 16.h
```

---

## 🔧 Common Tasks

### Task 1: Change FAQ Content
**File:** `lib/controllers/faqs_help_center_controller/faqs_help_center_controller.dart`
**Method:** `_getFAQsData()`
**Action:** Modify existing FAQItem objects

### Task 2: Add More FAQs
**File:** Same as above
**Method:** Same as above
**Action:** Add new FAQItem to the list

### Task 3: Change Colors
**File:** `lib/views/help_support/faqs_help_center/faqs_help_center.dart`
**Search for:** Color hex codes (0xFF...)
**Action:** Replace with desired colors

### Task 4: Modify Animation Speed
**File:** Same as above
**Search for:** `Duration(milliseconds: 300)`
**Action:** Change milliseconds value

### Task 5: Change Text Styles
**File:** Same as above
**Search for:** `AppFonts.poppins...`
**Action:** Change font size, weight, or color

---

## 🐛 Debugging

### Enable Debug Prints
Debug prints are already included with emoji prefixes:
- 🔵 Info logs
- ✅ Success logs
- ❌ Error logs

### Check Console Output
```dart
🔵 Expanded FAQ at index: 0
🔵 Collapsed FAQ at index: 0
✅ Expanded all FAQs
✅ Collapsed all FAQs
🔵 Navigate to FAQs Help Center
🔵 Navigated back from FAQs
```

### Verify State
```dart
// In controller, add debug method:
void debugPrintState() {
  print('Expanded indices: $_expandedIndices');
  print('Is loading: $_isLoading');
  print('FAQ count: ${faqItems.length}');
}

// Call from UI:
controller.debugPrintState();
```

---

## 📊 Widget Tree

```
FAQsHelpCenterScreen (StatelessWidget)
│
├─ Scaffold
│  └─ SafeArea
│     └─ Column
│        ├─ _AppBar
│        │  └─ Row
│        │     ├─ CustomBackButton
│        │     ├─ SizedBox (spacer)
│        │     ├─ Text (title)
│        │     └─ SizedBox (spacer)
│        │
│        └─ Expanded → _FAQContent (Obx)
│           ├─ _LoadingView (if loading)
│           └─ RefreshIndicator
│              └─ SingleChildScrollView
│                 └─ Column
│                    └─ _FAQList
│                       └─ _FAQItem (x5) (Obx)
│                          ├─ AnimatedContainer
│                          │  └─ Column
│                          │     ├─ _FAQItemHeader
│                          │     │  └─ InkWell
│                          │     │     └─ Row
│                          │     │        ├─ Text (question)
│                          │     │        └─ _ExpandIcon
│                          │     │           └─ AnimatedRotation
│                          │     │
│                          │     └─ _FAQItemBody
│                          │        └─ AnimatedCrossFade
│                          │           └─ _AnswerContent
│                          │              └─ Column
│                          │                 ├─ Container (divider)
│                          │                 └─ Text (answer)
```

---

## 🎓 Best Practices Used

### OOP Principles
✅ Private constructors for utility classes
✅ Encapsulation with private methods/properties
✅ Single Responsibility Principle
✅ Composition over inheritance
✅ Data abstraction (FAQItem model)

### Flutter Best Practices
✅ Const constructors
✅ Private widgets (_WidgetName)
✅ Proper state management (GetX)
✅ Responsive design (ScreenUtil)
✅ Context.mounted checks
✅ Proper disposal in onClose()

### Code Organization
✅ Section comments (============)
✅ Consistent naming conventions
✅ Comprehensive documentation
✅ Debug logging with emojis
✅ Proper file structure

---

## 📱 User Flow

```
Profile Screen
    ↓
Help & Support Screen
    ↓ (tap "FAQs / Help Center")
FAQs Help Center Screen
    ↓ (tap FAQ question)
FAQ Expanded (answer shown)
    ↓ (tap again)
FAQ Collapsed
    ↓ (tap back button)
Help & Support Screen
```

---

## ⚡ Performance Tips

1. **Use const constructors** - Already implemented where possible
2. **Lazy controller loading** - Already configured in binding.dart
3. **Efficient rebuilds** - Only FAQ items use Obx, not entire screen
4. **Optimized animations** - Single AnimatedContainer per item

---

## 🔗 Related Files

### Dependencies
- `get: ^latest` - State management
- `go_router: ^latest` - Navigation
- `flutter_screenutil: ^latest` - Responsive UI

### Utilities Used
- `AppColors` - Color constants
- `AppFonts` - Typography
- `Dimentions` - Spacing (not used in this screen)
- `AppPath` - Route paths
- `CustomBackButton` - Reusable back button

---

## 📞 Support

For issues or questions:
1. Check the main documentation: `FAQS_HELP_CENTER_DOCUMENTATION.md`
2. Review the code structure guide: `CODE_STRUCTURE_AND_STYLE_GUIDE.md`
3. Check console for debug logs

---

## ✨ Quick Tips

💡 **Tip 1:** FAQs are stored in controller, not database (yet)
💡 **Tip 2:** Multiple FAQs can be expanded simultaneously
💡 **Tip 3:** Pull down to refresh (currently simulated)
💡 **Tip 4:** All text supports multi-line content
💡 **Tip 5:** Animations are automatic and smooth

---

**Last Updated:** February 21, 2026  
**Version:** 1.0.0
