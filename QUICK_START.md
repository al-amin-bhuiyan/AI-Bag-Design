# 🚀 Quick Start Guide - OOP Splash Screen

## Assets Used
- **Background**: `assets/images/main_background.png`
- **Logo**: `assets/images/splash_logo.png`

## File Structure
```
lib/
├── utils/
│   ├── app_colors.dart      ← All colors
│   ├── app_fonts.dart       ← All fonts/text styles
│   ├── dimentions.dart      ← All dimensions
│   └── app_constants.dart   ← All configuration
├── widgets/
│   └── custom_assets.dart   ← All asset paths
├── controllers/
│   └── splash_controller/
│       └── splash_controller.dart
├── views/
│   └── splash_screen/
│       └── splash_screen.dart
└── routes/
    ├── app_path.dart
    └── route_path.dart
```

## Quick Examples

### Use Colors
```dart
import 'package:your_app/utils/app_colors.dart';

Container(color: AppColors.primary)
Container(color: AppColors.splashBackground)
Text(style: TextStyle(color: AppColors.textPrimary))
```

### Use Fonts
```dart
import 'package:your_app/utils/app_fonts.dart';

Text('Title', style: AppFonts.h1)
Text('Body', style: AppFonts.poppinsRegular(fontSize: 16))
Text('Bold', style: AppFonts.poppinsBold(
  fontSize: 20, 
  color: AppColors.primary
))
```

### Use Dimensions
```dart
import 'package:your_app/utils/dimentions.dart';

SizedBox(height: Dimentions.spacingLG)
Container(
  width: Dimentions.splashLogoWidth,
  height: Dimentions.splashLogoHeight,
)
Padding(padding: EdgeInsets.all(Dimentions.paddingMD))
```

### Use Constants
```dart
import 'package:your_app/utils/app_constants.dart';

// Splash config
await Future.delayed(SplashConfig.splashDuration);
Container(color: SplashConfig.backgroundColor)

// Animation config
AnimatedContainer(
  duration: AnimationConfig.medium,
  curve: AnimationConfig.defaultCurve,
)
```

### Use Assets
```dart
import 'package:your_app/widgets/custom_assets.dart';

Image.asset(CustomAssets.splashLogo)
Image.asset(CustomAssets.splashBackground)
Image.asset(CustomAssets.onBoardingFirst)
```

## Running the App
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run app
flutter run
```

## Key Benefits
✅ No hardcoded values
✅ Single point of change
✅ Type-safe
✅ Responsive
✅ Easy to maintain
✅ 100% OOP

## Customization
Want to change something? Just update the constant file:
- **Colors** → `lib/utils/app_colors.dart`
- **Fonts** → `lib/utils/app_fonts.dart`
- **Sizes** → `lib/utils/dimentions.dart`
- **Config** → `lib/utils/app_constants.dart`
- **Assets** → `lib/widgets/custom_assets.dart`

## ✨ Ready to Code!
Your splash screen is fully implemented with 100% OOP principles.
All utility files are created and properly integrated.

**Happy Coding! 🎉**
