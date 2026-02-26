# Code Structure & Coding Style Guide
## Jeebz Bag Design App

Last Updated: February 21, 2026

---

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture Pattern](#architecture-pattern)
3. [Code Organization](#code-organization)
4. [Coding Standards](#coding-standards)
5. [Widget Composition](#widget-composition)
6. [State Management](#state-management)
7. [Navigation](#navigation)
8. [Styling & Theming](#styling--theming)
9. [Best Practices](#best-practices)

---

## 🎯 Project Overview

**App Name:** Jeebz Bag Design  
**Framework:** Flutter  
**State Management:** GetX  
**Navigation:** GoRouter  
**Design System:** Material Design 3 with custom theming  
**Responsive UI:** flutter_screenutil

### Tech Stack
- **Flutter SDK:** Latest stable
- **State Management:** GetX (Reactive programming)
- **Routing:** GoRouter
- **UI Scaling:** flutter_screenutil
- **Fonts:** Google Fonts (Poppins primary, Inter secondary)
- **Icons:** flutter_svg for vector icons

---

## 🏗️ Architecture Pattern

### **MVC + OOP Principles**

The app follows a **Model-View-Controller (MVC)** pattern with strong **Object-Oriented Programming (OOP)** principles:

```
lib/
├── main.dart                    # App entry point
├── controllers/                 # Business logic layer
├── views/                       # UI presentation layer
├── models/                      # Data models (future use)
├── widgets/                     # Reusable UI components
├── utils/                       # Utilities & constants
├── routes/                      # Navigation configuration
└── dependency/                  # Dependency injection
```

### Core Principles
1. **Separation of Concerns:** UI, logic, and data are strictly separated
2. **Single Responsibility:** Each class has one clear purpose
3. **Encapsulation:** Private constructors, private methods, proper getters
4. **Composition over Inheritance:** Widget composition for UI building
5. **DRY (Don't Repeat Yourself):** Reusable widgets and utility classes

---

## 📁 Code Organization

### Controllers (`lib/controllers/`)
Controllers manage business logic and state for specific screens:

```dart
/// Pattern: {FeatureName}Controller
/// Example: LoginController, ProfileController
class FeatureController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  
  // ============ LIFECYCLE METHODS ============
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }
  
  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }
  
  // ============ PRIVATE METHODS ============
  void _initialize() { }
  void _cleanup() { }
  
  // ============ PUBLIC METHODS ============
  Future<void> performAction() async { }
}
```

**Key Features:**
- Comment sections for organization (`============ SECTION ============`)
- Observable properties with private backing fields (`_variable`)
- Public getters for reactive state
- Clear lifecycle management
- Private helper methods prefixed with `_`
- Comprehensive documentation comments

### Views (`lib/views/`)
Views contain UI presentation logic:

```dart
/// Main screen widget
class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeatureController>();
    
    return Scaffold(
      body: _ScreenContent(controller: controller),
    );
  }
}

/// Private widget for screen content
class _ScreenContent extends StatelessWidget {
  final FeatureController controller;
  
  const _ScreenContent({required this.controller});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        _Body(controller: controller),
      ],
    );
  }
}
```

**Key Features:**
- Main screen widget is a clean StatelessWidget
- Private widgets (`_WidgetName`) for composition
- Controller dependency injection via `Get.find<>()`
- Nested widget structure for organization
- Each widget has single responsibility

### Widgets (`lib/widgets/`)
Reusable UI components following OOP principles:

```dart
/// CustomButton - Reusable button widget
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });
  
  /// Factory constructor for primary button
  factory CustomButton.primary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return CustomButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return _ButtonWrapper(
      child: _ButtonContent(
        label: label,
        isLoading: isLoading,
      ),
    );
  }
}
```

**Key Features:**
- Factory constructors for variants (`.primary()`, `.secondary()`)
- Private sub-widgets for internal composition
- Comprehensive documentation
- Consistent parameter ordering

### Utils (`lib/utils/`)

#### **AppColors** - Color constants
```dart
class AppColors {
  AppColors._(); // Private constructor
  
  static const Color primary = Color(0xFF0066FF);
  static const Color secondary = Color(0xFFEBFCFF);
  static const Color textPrimary = Color(0xFF000000);
}
```

#### **AppFonts** - Typography
```dart
class AppFonts {
  AppFonts._();
  
  static TextStyle poppinsRegular({
    double? fontSize,
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}
```

#### **Dimentions** - Responsive sizing
```dart
class Dimentions {
  Dimentions._();
  
  static double get spacingSM => 8.h;
  static double get spacingMD => 16.h;
  static double get paddingLG => 24.w;
  static double fontSize(double size) => size.sp;
}
```

#### **AppConstants** - Configuration
```dart
class AppConstants {
  AppConstants._();
  
  static const String appName = 'Jeebz Bag Design';
  static const String appVersion = '1.0.0';
}

class SplashConfig {
  SplashConfig._();
  
  static const Duration splashDuration = Duration(seconds: 3);
  static Color get backgroundColor => AppColors.splashBackground;
}
```

---

## 💻 Coding Standards

### Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Classes | PascalCase | `ProfileController` |
| Files | snake_case | `profile_controller.dart` |
| Variables | camelCase | `isLoading`, `userName` |
| Private variables | _camelCase | `_isLoading`, `_userName` |
| Constants | camelCase or UPPER_SNAKE_CASE | `appName`, `MAX_SIZE` |
| Private widgets | _PascalCase | `_ProfileCard` |
| Methods | camelCase | `updateProfile()` |
| Private methods | _camelCase | `_initialize()` |

### Documentation

```dart
/// Class-level documentation
/// Describes the purpose and responsibility of the class
/// Follows OOP principles with [specific pattern]
class FeatureController extends GetxController {
  
  /// Method documentation
  /// Describes what the method does, parameters, and return value
  /// @param context - BuildContext for navigation
  /// @return Future<void> - Completes when action is done
  Future<void> performAction(BuildContext context) async {
    // Implementation
  }
}
```

**Documentation Guidelines:**
- Every public class has a description comment
- Public methods have purpose documentation
- Complex logic has inline comments
- TODO comments for future implementations
- Debug print statements with emojis (🔵 info, ✅ success, ❌ error)

### Code Organization Within Files

```dart
/// 1. Imports
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 2. Class documentation
/// 3. Class declaration
class MyController extends GetxController {
  
  // 4. Properties section
  // ============ OBSERVABLE PROPERTIES ============
  final RxBool _isLoading = false.obs;
  
  // 5. Getters section
  bool get isLoading => _isLoading.value;
  
  // 6. Lifecycle methods
  // ============ LIFECYCLE METHODS ============
  @override
  void onInit() { }
  
  // 7. Initialization methods
  // ============ INITIALIZATION ============
  void _initialize() { }
  
  // 8. Public methods
  // ============ PUBLIC METHODS ============
  void performAction() { }
  
  // 9. Private methods
  // ============ PRIVATE METHODS ============
  void _helperMethod() { }
  
  // 10. Utility methods
  // ============ UTILITY METHODS ============
  void _showMessage(String message) { }
}
```

---

## 🧩 Widget Composition

### Private Widget Pattern
The codebase extensively uses **private widgets** for composition:

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ProfileContent(),
    );
  }
}

/// Private widget - only accessible within this file
class _ProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileHeader(),
        _ProfileBody(),
        _ProfileFooter(),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget { }
class _ProfileBody extends StatelessWidget { }
class _ProfileFooter extends StatelessWidget { }
```

**Benefits:**
- Better code organization
- Easier to read and maintain
- Clear separation of concerns
- No external access to internal widgets
- Performance optimization (const constructors)

### Animation Patterns

```dart
TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
  duration: const Duration(milliseconds: 400),
  curve: Curves.elasticOut,
  builder: (context, value, child) {
    final scale = 1.0 + (value * 0.08);
    final borderWidth = (value * 2.0).clamp(0.0, 2.0);
    
    return Transform.scale(
      scale: scale,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: borderWidth),
        ),
        child: child,
      ),
    );
  },
)
```

**Animation Guidelines:**
- Use `TweenAnimationBuilder` for simple animations
- Use `.clamp()` to prevent negative values
- Elastic curves for bouncy effects
- 400ms is standard animation duration

---

## 🔄 State Management

### GetX Reactive Programming

```dart
class MyController extends GetxController {
  // 1. Private reactive variable
  final RxBool _isLoading = false.obs;
  
  // 2. Public getter
  bool get isLoading => _isLoading.value;
  
  // 3. Update method
  void _setLoading(bool value) {
    _isLoading.value = value;
  }
  
  // 4. Use in UI with Obx
  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
      controller.isLoading ? 'Loading...' : 'Done',
    ));
  }
}
```

### State Update Patterns

```dart
// ✅ Correct - Private setter method
void _setLoading(bool value) {
  _isLoading.value = value;
}

// ✅ Correct - Direct update in public method
Future<void> loadData() async {
  _isLoading.value = true;
  try {
    // Load data
  } finally {
    _isLoading.value = false;
  }
}

// ❌ Avoid - Direct external access
// External code should not do: controller._isLoading.value = true;
```

### Controller Lifecycle

```dart
@override
void onInit() {
  super.onInit();
  // Called when controller is created
  // Initialize data, start listeners
  _initialize();
}

@override
void onReady() {
  super.onReady();
  // Called after the widget is rendered
  // Good for API calls that show UI feedback
}

@override
void onClose() {
  // Called when controller is disposed
  // Clean up resources, cancel subscriptions
  _cleanup();
  super.onClose();
}
```

---

## 🧭 Navigation

### GoRouter Configuration

```dart
class RoutePath {
  RoutePath._();
  
  static final GoRouter router = GoRouter(
    initialLocation: AppPath.splash,
    routes: _buildRoutes(),
  );
  
  static List<RouteBase> _buildRoutes() {
    return [
      _createSplashRoute(),
      _createLoginRoute(),
      // More routes...
    ];
  }
  
  static GoRoute _createLoginRoute() {
    return GoRoute(
      path: AppPath.login,
      name: 'login',
      builder: (context, state) => const LogInScreen(),
    );
  }
}
```

### Navigation Patterns

```dart
// Push new route
context.push(AppPath.profile);

// Push with parameters
context.push('${AppPath.verificationCode}?email=$email');

// Replace current route
context.go(AppPath.home);

// Pop back
context.pop();

// Check if can pop
if (context.canPop()) {
  context.pop();
}
```

### Path Constants

```dart
class AppPath {
  AppPath._();
  
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
}
```

---

## 🎨 Styling & Theming

### Color Usage

```dart
// ✅ Use AppColors constants
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)

// ❌ Avoid hardcoded colors
Container(
  color: Color(0xFF0066FF), // Don't do this
)
```

### Typography

```dart
// ✅ Use AppFonts utilities
Text(
  'Welcome',
  style: AppFonts.poppinsSemiBold(
    fontSize: 20.sp,
    color: AppColors.primary,
  ),
)

// ✅ Use predefined text styles
Text(
  'Body text',
  style: AppFonts.bodyMedium,
)
```

### Responsive Sizing

```dart
// Use flutter_screenutil for responsive sizing
SizedBox(height: 24.h),  // Height
SizedBox(width: 16.w),   // Width
Text(
  'Text',
  style: TextStyle(fontSize: 16.sp),  // Font size
)
BorderRadius.circular(12.r),  // Radius
```

**Design Base:**
- Design Width: 393
- Design Height: 852

### Spacing System

```dart
// Use Dimentions for consistent spacing
SizedBox(height: Dimentions.spacingSM),   // 8.h
SizedBox(height: Dimentions.spacingMD),   // 16.h
SizedBox(height: Dimentions.spacingLG),   // 24.h

EdgeInsets.all(Dimentions.paddingMD),      // 16.w
```

### Container Decoration Pattern

```dart
Container(
  width: 350.w,
  padding: EdgeInsets.all(16.w),
  decoration: ShapeDecoration(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        width: 1,
        color: const Color(0xFFD2D6DB),
      ),
      borderRadius: BorderRadius.circular(12.r),
    ),
    shadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: child,
)
```

---

## ✅ Best Practices

### 1. Widget Organization
```dart
// ✅ Good - Organized with private widgets
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeContent(),
    );
  }
}

class _HomeContent extends StatelessWidget { }
class _Header extends StatelessWidget { }
class _Body extends StatelessWidget { }
```

### 2. Error Handling
```dart
Future<void> performAction() async {
  _setLoading(true);
  
  try {
    // Perform action
    await someOperation();
    _showSuccess('Operation completed');
  } catch (e) {
    print('❌ Error: $e');
    _showError('Operation failed: $e');
  } finally {
    _setLoading(false);
  }
}
```

### 3. Null Safety
```dart
// ✅ Use null checks for navigation
if (context.mounted) {
  context.push(AppPath.home);
}

// ✅ Safe access with null-aware operators
final email = state.uri.queryParameters['email'];
return VerificationCodeScreen(email: email);
```

### 4. Asset Management
```dart
// ✅ Use CustomAssets class
Image.asset(CustomAssets.splashLogo)
SvgPicture.asset(CustomAssets.google)

// ❌ Avoid hardcoded paths
Image.asset('assets/images/logo.png')  // Don't do this
```

### 5. Form Validation
```dart
// Validation in controller
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email';
  }
  
  return null;
}
```

### 6. Loading States
```dart
// UI with loading state
Obx(() => CustomButton(
  label: 'Sign In',
  onPressed: controller.isLoading ? null : () => controller.signIn(),
  isLoading: controller.isLoading,
))
```

### 7. Dependency Injection
```dart
// Initialize in main.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Binding.init();  // Initialize all controllers
  runApp(const MyApp());
}

// Access in widgets
final controller = Get.find<ProfileController>();
```

### 8. Constants Configuration
```dart
// Organize constants by feature
class SplashConfig {
  SplashConfig._();
  
  static const Duration splashDuration = Duration(seconds: 3);
  static Color get backgroundColor => AppColors.splashBackground;
  static double get logoWidth => Dimentions.splashLogoWidth;
}
```

### 9. Debug Logging
```dart
// Use emoji prefixes for visibility
print('🔵 Navigate to Edit Profile');
print('✅ Profile saved successfully');
print('❌ Error: $e');
print('⏳ Loading data...');
```

### 10. BuildContext Safety
```dart
// Always check if context is mounted before navigation
Future<void> navigateToHome() async {
  await someAsyncOperation();
  
  if (context.mounted) {
    context.push(AppPath.home);
  }
}
```

---

## 📦 Project Structure Example

```
lib/
├── main.dart
├── controllers/
│   ├── splash_controller/
│   │   └── splash_controller.dart
│   ├── log_in_controller/
│   │   └── log_in_controller.dart
│   └── profile_controller/
│       └── profile_controller.dart
├── views/
│   ├── splash_screen/
│   │   └── splash_screen.dart
│   ├── log_in/
│   │   └── log_in.dart
│   └── profile/
│       ├── profile.dart
│       ├── edit_profile/
│       │   └── edit_profile.dart
│       └── security/
│           └── security.dart
├── widgets/
│   ├── custom_button.dart
│   ├── custom_textfield.dart
│   ├── custom_back_button.dart
│   ├── custom_nav_bar_widgets.dart
│   ├── product_selection_dialog.dart
│   └── dialogs/
│       ├── logout_dialog.dart
│       └── delete_account_dialog.dart
├── utils/
│   ├── app_colors.dart
│   ├── app_fonts.dart
│   ├── app_constants.dart
│   ├── dimentions.dart
│   ├── page_transitions.dart
│   └── toast_message.dart
├── routes/
│   ├── app_path.dart
│   └── route_path.dart
├── dependency/
│   └── binding.dart
└── models/
    └── (future use)
```

---

## 🎓 Code Review Checklist

Before committing code, ensure:

- [ ] Uses private constructors for utility classes
- [ ] Private widgets start with `_`
- [ ] Private methods/properties start with `_`
- [ ] Documentation comments on public classes/methods
- [ ] Uses AppColors instead of hardcoded colors
- [ ] Uses AppFonts instead of inline TextStyle
- [ ] Uses Dimentions for spacing/sizing
- [ ] Responsive sizing with `.w`, `.h`, `.sp`, `.r`
- [ ] Proper error handling with try-catch
- [ ] Loading states managed correctly
- [ ] Context.mounted checks before navigation
- [ ] GetX controller lifecycle implemented
- [ ] Assets use CustomAssets constants
- [ ] No magic strings (use AppConstants)
- [ ] Widget composition with private sub-widgets
- [ ] Consistent naming conventions
- [ ] Debug prints with emoji prefixes
- [ ] Null safety handled properly

---

## 📚 Common Patterns Reference

### Dialog Pattern
```dart
void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (BuildContext context) => CustomDialog(
      onConfirm: () => handleConfirm(),
    ),
  );
}
```

### Bottom Sheet Pattern
```dart
void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content
        ],
      ),
    ),
  );
}
```

### Snackbar Pattern
```dart
void _showMessage(String message) {
  Get.snackbar(
    'Info',
    message,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}
```

---

## 🔧 Tools & Extensions

**Recommended VS Code Extensions:**
- Flutter
- Dart
- Pubspec Assist
- Flutter Widget Snippets
- Error Lens
- Better Comments

**Code Formatting:**
- Line length: 80-120 characters
- Use `dart format` before committing
- Enable format on save

---

## 📝 Notes

- This codebase prioritizes **readability** and **maintainability**
- **OOP principles** are strictly followed
- **Widget composition** over complex single widgets
- **GetX** for lightweight state management
- **GoRouter** for type-safe navigation
- **flutter_screenutil** ensures pixel-perfect responsive design
- **Private widgets pattern** keeps code organized and encapsulated

---

**Last Updated:** February 21, 2026  
**Maintained By:** Jeebz Development Team
