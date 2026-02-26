# Splash Screen - Background Image Configuration

## ✅ Updated: Using main_background.png as Splash Background

### Configuration Change

**Before:** Solid color background (#EBFCFF)  
**After:** Image background (main_background.png)

### Why This Is Better

✅ **Visual Appeal:** Full branded background image
✅ **Professional:** Rich, custom splash screen
✅ **Brand Identity:** Shows your complete brand design
✅ **Consistent:** Matches your app's visual theme

### Updated Configuration

```yaml
flutter_native_splash:
  # Background image instead of solid color
  background_image: "assets/images/main_background.png"
  
  # Splash screen logo
  image: "assets/images/splash_logo.png"
  
  android: true
  android_12:
    image: "assets/images/splash_logo.png"
    color: "#EBFCFF"  # Fallback for Android 12+
    icon_background_color: "#EBFCFF"
  
  ios: true
  fullscreen: true
  android_gravity: center
  ios_content_mode: center
```

### What Users Will See

#### Android 5.0 - 11 (API 21-30)
```
┌─────────────────────┐
│                     │
│  main_background    │  ← Full background image
│       .png          │
│                     │
│   [Splash Logo]     │  ← Logo centered over background
│                     │
│                     │
└─────────────────────┘
```

#### Android 12+ (API 31+)
```
┌─────────────────────┐
│                     │
│   Light Blue        │  ← #EBFCFF color (Android 12 limitation)
│   Background        │
│                     │
│   [Splash Logo]     │  ← Logo centered
│                     │
└─────────────────────┘
```

**Note:** Android 12+ splash API doesn't support custom background images, so it falls back to the color.

#### iOS
```
┌─────────────────────┐
│                     │
│  main_background    │  ← Full background image
│       .png          │
│                     │
│   [Splash Logo]     │  ← Logo centered over background
│                     │
└─────────────────────┘
```

### Platform Support

| Platform | Background Image Support | What Shows |
|----------|------------------------|------------|
| Android 5.0-11 | ✅ Full Support | main_background.png |
| Android 12+ | ❌ No Support | #EBFCFF color fallback |
| iOS | ✅ Full Support | main_background.png |

### Important: Android 12+ Limitation

**Android 12 introduced a new Splash Screen API that doesn't support custom background images.**

**Options:**
1. ✅ **Use color fallback** (current setup) - Clean, works everywhere
2. Use custom splash implementation (complex)
3. Accept that Android 12+ users see color background

**Recommendation:** Current setup is ideal because:
- Most users (Android 5-11, all iOS) see the image
- Android 12+ users see clean branded color
- Simple, maintainable configuration

### Background Image Specifications

**File:** `assets/images/main_background.png`

**Recommended:**
- **Size:** 1080x1920px (portrait) or larger
- **Format:** PNG or JPG
- **Aspect Ratio:** 9:16 for portrait apps
- **File Size:** Keep under 500KB for fast loading
- **Content:** Avoid important content at edges (safe area)

**Scaling:**
- Image will scale to cover entire screen
- Center region is always visible
- Edges may be cropped on different aspect ratios

### What Changed

#### Files Regenerated
✅ `android/app/src/main/res/drawable/launch_background.xml` - Now includes background image
✅ `android/app/src/main/res/drawable-v21/launch_background.xml` - Updated with image
✅ `android/app/src/main/res/values/styles.xml` - Updated
✅ `android/app/src/main/res/values-v31/styles.xml` - Android 12+ with color
✅ `ios/Runner/Assets.xcassets/LaunchBackground.imageset/` - iOS background images

#### pubspec.yaml
```yaml
# REMOVED:
color: "#EBFCFF"

# ADDED:
background_image: "assets/images/main_background.png"
```

### Testing

#### Test Splash Screen
```bash
flutter run
```

**Check:**
1. ✅ Background image appears (Android 5-11, iOS)
2. ✅ Logo centered over background
3. ✅ No stretching or distortion
4. ✅ Image scales properly

#### Test Android 12+ Specifically
If you have an Android 12+ device/emulator:
```bash
flutter run
```
- Should see light blue background with logo
- This is expected behavior (API limitation)

### Troubleshooting

#### Background Not Showing
1. Verify image exists: `assets/images/main_background.png`
2. Clean and rebuild:
   ```bash
   flutter clean
   dart run flutter_native_splash:create
   flutter run
   ```

#### Image Looks Stretched
- Check image dimensions
- Recommended: 1080x1920px or larger
- Maintain 9:16 aspect ratio

#### Want Different Image
1. Replace `assets/images/main_background.png`
2. Regenerate:
   ```bash
   dart run flutter_native_splash:create
   ```

### Reverting to Solid Color (If Needed)

If you want to go back to solid color:

```yaml
flutter_native_splash:
  color: "#EBFCFF"  # Instead of background_image
  image: "assets/images/splash_logo.png"
  # ... rest of config
```

Then regenerate:
```bash
dart run flutter_native_splash:create
```

### Best Practices

✅ **Do:**
- Use high-quality background image
- Keep file size reasonable (<500KB)
- Test on multiple devices
- Ensure logo is visible against background

❌ **Don't:**
- Use very large images (slow loading)
- Put critical info at edges
- Forget Android 12+ has color fallback
- Ignore aspect ratio differences

### Summary

**Current Setup:**
- ✅ Background: `main_background.png` (Android 5-11, iOS)
- ✅ Fallback: `#EBFCFF` color (Android 12+)
- ✅ Logo: `splash_logo.png` (centered on all platforms)
- ✅ App Icon: `lOGOss.png` (with #EBFCFF adaptive background)

**Result:**
🎨 **Rich, branded splash screen with custom background image for maximum visual impact!**

### Files Updated

- ✅ `pubspec.yaml` - Configuration changed
- ✅ Android drawable XMLs - Background image added
- ✅ iOS assets - Background images generated
- ✅ Style files - Updated

### Status

✅ **Background Image:** Configured (main_background.png)
✅ **Solid Color:** Removed (except Android 12+ fallback)
✅ **Files Generated:** Complete
✅ **Android 5-11:** Background image ✓
✅ **Android 12+:** Color fallback ✓
✅ **iOS:** Background image ✓
✅ **Ready to Test:** YES

---

**Your splash screen now uses the full main_background.png image! Test with `flutter run` to see your branded splash screen in action! 🎨🚀**

**Note:** Android 12+ devices will show the light blue color due to API limitations, but all other devices will show your beautiful background image.
