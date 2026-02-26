# Custom Navigation Bar Widget - Documentation

## 📦 File: `custom_nav_bar_widgets.dart`

### ✨ Overview
A modern, OOP-based bottom navigation bar widget with SVG icons, hover states, smooth animations, and elegant shadow effects.

---

## 🏗️ Architecture

### Main Components

#### 1. **CustomNavBar** (Primary Widget)
The main navigation bar widget that displays at the bottom of the screen.

```dart
CustomNavBar(
  currentIndex: 1, // 0=Create, 1=Collections, 2=Your Design, 3=Profile
  onTap: (index) => controller.updateSelectedIndex(index),
)
```

**Features:**
- ✅ Layered shadow effects (2 shadows for depth)
- ✅ SafeArea support
- ✅ Responsive sizing with ScreenUtil
- ✅ 4 navigation items in specified order

#### 2. **_NavBarItem** (Private Widget)
Individual navigation tab item with icon and label.

**Features:**
- ✅ Smooth animations (200ms duration)
- ✅ Active/inactive icon states
- ✅ Dynamic label styling
- ✅ GestureDetector for tap handling

#### 3. **_NavBarIcon** (Private Widget)
SVG icon with state transitions.

**Features:**
- ✅ AnimatedSwitcher for smooth transitions
- ✅ Scale and fade animations
- ✅ SVG icon support with flutter_svg
- ✅ Automatic state switching

#### 4. **_NavBarLabel** (Private Widget)
Text label with animated styling.

**Features:**
- ✅ AnimatedDefaultTextStyle
- ✅ Font size changes on selection
- ✅ Color transitions
- ✅ Poppins font family

---

## 📊 Tab Order & Flow

```
Index 0: Create       → create_with_hovar.svg / create_without_hovar.svg
Index 1: Collections  → collections_with_hovar.svg / collections_without_hovar.svg (DEFAULT)
Index 2: Your Design  → your_design_with_hovar.svg / your_design_without_hovar.svg
Index 3: Profile      → profile_with_hovar.svg / profile_without_hovar.svg
```

**Default Tab:** Collections (Index 1)

---

## 🎨 Visual Design

### Shadow Effect
```dart
BoxShadow(
  color: Colors.black.withValues(alpha: 0.08),
  blurRadius: 16,
  offset: Offset(0, -4),
)
BoxShadow(
  color: Colors.black.withValues(alpha: 0.04),
  blurRadius: 8,
  offset: Offset(0, -2),
)
```

### Icon Sizing
- Width: 24.w
- Height: 24.h

### Label Styling
- **Selected:**
  - Font Size: 11.sp
  - Font Weight: 600 (SemiBold)
  - Color: #1F7CD5 (Primary Blue)

- **Unselected:**
  - Font Size: 10.sp
  - Font Weight: 400 (Regular)
  - Color: #9DA4AE (Gray)

### Container
- Height: 70.h
- Background: White
- Padding: 16.w horizontal, 8.h vertical

---

## 💡 Usage Examples

### Basic Usage (with GetX)
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      body: Obx(() => _getTabContent(controller.selectedIndex)),
      bottomNavigationBar: Obx(() => CustomNavBar(
        currentIndex: controller.selectedIndex,
        onTap: (index) => controller.updateSelectedIndex(index),
      )),
    );
  }
}
```

### With CustomNavBarBuilder (Alternative)
```dart
CustomNavBarBuilder(
  initialIndex: 1, // Start at Collections
  builder: (context, currentIndex) {
    switch (currentIndex) {
      case 0: return CreateScreen();
      case 1: return CollectionsScreen();
      case 2: return YourDesignScreen();
      case 3: return ProfileScreen();
      default: return CollectionsScreen();
    }
  },
)
```

### With CustomNavBarController (Standalone)
```dart
final navController = CustomNavBarController();

// Navigate programmatically
navController.navigateToCreate();
navController.navigateToCollections();
navController.navigateToYourDesign();
navController.navigateToProfile();

// Listen to changes
navController.addListener(() {
  print('Current index: ${navController.currentIndex}');
});

// Don't forget to dispose
@override
void dispose() {
  navController.dispose();
  super.dispose();
}
```

---

## 🔧 OOP Principles Followed

### 1. **Encapsulation**
- Private widgets (_NavBarItem, _NavBarIcon, _NavBarLabel)
- Private controller fields (_currentIndex, _listeners)
- Public getters for controlled access

### 2. **Single Responsibility**
- CustomNavBar: Main navigation container
- _NavBarItem: Individual tab logic
- _NavBarIcon: Icon state management
- _NavBarLabel: Label styling
- CustomNavBarController: State management
- NavBarConfig: Configuration data

### 3. **Composition**
- CustomNavBar composed of multiple _NavBarItem
- _NavBarItem composed of _NavBarIcon + _NavBarLabel
- Builder pattern with CustomNavBarBuilder

### 4. **Abstraction**
- NavBarConfig for configuration abstraction
- Controller pattern for state abstraction
- Builder pattern for flexible usage

---

## 📋 NavBarConfig (Configuration Class)

### Purpose
Data class for navigation item configuration.

### Properties
```dart
class NavBarConfig {
  final String iconWithoutHover;
  final String iconWithHover;
  final String label;
  final int index;
}
```

### Default Configuration
```dart
NavBarConfig.defaultItems // Returns all 4 items
```

---

## 🎯 CustomNavBarController

### Purpose
Standalone controller for navigation state management.

### Properties
- `currentIndex` - Current selected index (0-3)

### Methods
- `updateIndex(int index)` - Update index
- `navigateToCreate()` - Go to Create tab
- `navigateToCollections()` - Go to Collections tab
- `navigateToYourDesign()` - Go to Your Design tab
- `navigateToProfile()` - Go to Profile tab
- `addListener(VoidCallback)` - Add state listener
- `removeListener(VoidCallback)` - Remove listener
- `dispose()` - Clean up resources

---

## 🎬 Animations

### Icon Transition
- **Duration:** 200ms
- **Type:** Scale + Fade
- **Curve:** Default (linear)

### Label Transition
- **Duration:** 200ms
- **Type:** TextStyle animation
- **Curve:** easeInOut

### Container
- **Duration:** 200ms
- **Curve:** easeInOut

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_screenutil: ^5.x.x
  flutter_svg: ^2.x.x
```

---

## 🚀 Integration with Home Screen

### Updated Flow
```
HomeScreen
├── body: SafeArea
│   └── Obx → _HomeContent
│       ├── case 0: _CreateTab
│       ├── case 1: _CollectionsTab (default)
│       ├── case 2: _YourDesignTab
│       └── case 3: _ProfileTab
└── bottomNavigationBar: Obx → CustomNavBar
```

### HomeController Updates
```dart
// Default index changed to 1 (Collections)
final _selectedIndex = 1.obs;

// Navigation methods updated:
// 0 = Create
// 1 = Collections
// 2 = Your Design
// 3 = Profile
```

---

## ✅ Features Checklist

- ✅ OOP design with private widgets
- ✅ SVG icon support with hover states
- ✅ Smooth animations (scale, fade, text style)
- ✅ Elegant shadow effects (dual layer)
- ✅ Responsive sizing (ScreenUtil)
- ✅ SafeArea support
- ✅ Custom controller option
- ✅ Builder pattern support
- ✅ Configuration class
- ✅ Proper tab order (Create, Collections, Your Design, Profile)
- ✅ Collections as default tab
- ✅ Type-safe asset paths
- ✅ No hardcoded values
- ✅ Clean code structure

---

## 🎨 Color Scheme

| State | Color | Hex |
|-------|-------|-----|
| Selected Label | Primary Blue | #1F7CD5 |
| Unselected Label | Gray | #9DA4AE |
| Background | White | #FFFFFF |
| Shadow 1 | Black (8% opacity) | #000000 14 |
| Shadow 2 | Black (4% opacity) | #000000 0A |

---

## 📝 Notes

1. **Icons must be SVG format** for proper rendering
2. **flutter_svg package required** for SVG support
3. **Two icon states required** per tab (hover/non-hover)
4. **Default tab is Collections** (index 1)
5. **Controller must be initialized** before HomeScreen
6. **Icons located** in `assets/icons/` folder
7. **Asset paths defined** in `custom_assets.dart`

---

## 🔄 Migration from Old NavBar

### Changes Made:
1. ✅ Replaced Material Icons with SVG icons
2. ✅ Changed tab order: Collections → Create, Collections, Your Design, Profile
3. ✅ Enhanced shadow effects (dual layer)
4. ✅ Improved animations (scale + fade)
5. ✅ Added hover state support
6. ✅ Increased container height (70.h)
7. ✅ Updated default index (0 → 1)

### Breaking Changes:
- Tab indices changed (Collections moved from 0 to 1)
- Icon properties changed (iconActive/iconInactive → iconWithHover/iconWithoutHover)
- Asset type changed (IconData → String SVG path)

---

## 🏆 Summary

**CustomNavBar** is a production-ready, OOP-based navigation widget with:
- ✨ Beautiful animations
- 🎨 Professional design
- 🔧 Flexible architecture
- 📱 Responsive layout
- ♿ Accessibility support
- 🚀 High performance

**Status:** ✅ READY FOR PRODUCTION
