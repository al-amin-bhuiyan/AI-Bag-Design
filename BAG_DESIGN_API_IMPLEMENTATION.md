# Bag Design API Integration - Complete Implementation

## Overview
Successfully implemented bag design API integration using the `http` package with 100% OOP principles. The system uploads logo images and generates bag designs with AI.

## Implementation Details

### 📦 Packages Used
- ✅ `http: ^1.2.0` (already in your project)
- ✅ No additional dependencies needed

### 📁 Files Created

#### 1. **Models** (lib/models/)
- ✅ `logo_upload_response_model.dart` - Response for logo upload API
- ✅ `design_generation_response_model.dart` - Response for design generation API

#### 2. **Services** (lib/services/)
- ✅ `bag_design_service.dart` - Main service for bag design APIs

#### 3. **Updated Files**
- ✅ `utils/app_constants.dart` - Added bag design API endpoints
- ✅ `widgets/mockup_dialog.dart` - Added network image support

## API Endpoints

### 1. Upload Logo API
```
POST http://10.10.7.74:8000/api/upload-logo/
Content-Type: multipart/form-data

Body:
- image: File (form-data)

Response:
{
  "logo_url": "http://10.10.7.74:8000/media/logos/Apple_HSOZgtf.png"
}
```

### 2. Generate Design API
```
POST http://10.10.7.82:8008/api/generate-design/
Content-Type: application/json

Body:
{
  "bag_type": "gusset_fullwrap",
  "logo_url": "http://10.10.7.74:8000/media/logos/Apple_HSOZgtf.png"
}

Response:
{
  "id": 6,
  "bag_type": "gusset_fullwrap",
  "preview_id": "a6bc62c4-82e4-48df-be72-e4214f1b462e",
  "preview_url": "http://10.10.7.82:8008/results/bag_gusset_fullwrap_front.png",
  "dieline_url": "http://10.10.7.82:8008/results/bag_gusset_fullwrap_back.png"
}
```

## Usage Examples

### Example 1: Upload Logo and Generate Design (Combined)

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../services/bag_design_service.dart';
import '../widgets/mockup_dialog.dart';
import '../widgets/ai_generation_loading_widget.dart';

Future<void> uploadAndGenerateDesign(BuildContext context, File logoFile) async {
  final service = BagDesignService.instance;

  try {
    // Show AI generation loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AIGenerationLoadingWidget(
        onGenerate: () async {
          // This will take 10-20 seconds
          final result = await service.uploadLogoAndGenerateDesign(
            logoFile: logoFile,
            bagType: 'gusset_fullwrap',
          );

          if (context.mounted && result.success && result.data != null) {
            Navigator.pop(context); // Close loading

            // Show mockup dialog with generated images
            await MockupDialog.show(
              context,
              images: [
                result.data!.previewUrl, // First image (front)
                result.data!.dielineUrl,  // Second image (back)
              ],
              isNetworkImage: true,
              onSaveImages: () {
                print('Images saved!');
              },
              onAddToCollections: () {
                print('Added to collections!');
              },
            );
          } else {
            Navigator.pop(context); // Close loading
            // Show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(result.errorMessage ?? 'Failed')),
            );
          }
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  } catch (e) {
    print('Error: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
```

### Example 2: Upload Logo Only

```dart
Future<void> uploadLogoOnly(File logoFile) async {
  final service = BagDesignService.instance;

  try {
    final result = await service.uploadLogo(imageFile: logoFile);

    if (result.success && result.data != null) {
      final logoUrl = result.data!.logoUrl;
      print('✅ Logo uploaded: $logoUrl');
      // Use logoUrl for other purposes
    } else {
      print('❌ Error: ${result.errorMessage}');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
}
```

### Example 3: Generate Design with Existing Logo URL

```dart
Future<void> generateDesignOnly(String logoUrl) async {
  final service = BagDesignService.instance;

  try {
    final result = await service.generateDesign(
      bagType: 'gusset_fullwrap',
      logoUrl: logoUrl,
    );

    if (result.success && result.data != null) {
      print('✅ Design generated!');
      print('Preview: ${result.data!.previewUrl}');
      print('Dieline: ${result.data!.dielineUrl}');
    } else {
      print('❌ Error: ${result.errorMessage}');
    }
  } catch (e) {
    print('❌ Exception: $e');
  }
}
```

### Example 4: Complete Integration in Upload Image Screen

```dart
// In upload_image_controller.dart
Future<void> showBagDesignWithAPI(BuildContext context, File imageFile) async {
  final service = BagDesignService.instance;

  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AIGenerationLoadingWidget(
      onGenerate: () async {
        try {
          // Upload logo and generate design
          final response = await service.uploadLogoAndGenerateDesign(
            logoFile: imageFile,
            bagType: 'gusset_fullwrap', // or get from controller state
          );

          if (response.success && response.data != null) {
            final design = response.data!;
            
            // Close loading dialog
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext);
            }

            // Show mockup dialog with generated images
            if (context.mounted) {
              await MockupDialog.show(
                context,
                images: [design.previewUrl, design.dielineUrl],
                isNetworkImage: true,
                onSaveImages: () async {
                  // Save images logic
                  await saveMockupImages();
                },
                onAddToCollections: () async {
                  // Add to collections logic
                  await addMockupToCollections();
                },
              );
            }
          } else {
            throw Exception(response.errorMessage ?? 'Failed to generate design');
          }
        } catch (e) {
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      onClose: () {
        if (dialogContext.mounted) {
          Navigator.pop(dialogContext);
        }
      },
    ),
  );
}
```

## Bag Type Options

The API supports different bag types. Use these values for the `bagType` parameter:

```dart
// Common bag types
const String BAG_TYPE_GUSSET_FULLWRAP = 'gusset_fullwrap';
const String BAG_TYPE_QUAD_SEAL = 'quad_seal';
const String BAG_TYPE_STANDUP_POUCH = 'standup_pouch';

// Usage
final result = await service.generateDesign(
  bagType: BAG_TYPE_GUSSET_FULLWRAP,
  logoUrl: logoUrl,
);
```

## Error Handling

The service includes comprehensive error handling:

### Network Errors
```dart
// No internet
ApiResponse.error(message: 'No internet connection. Please check your network.')

// Server error
ApiResponse.error(message: 'Server error. Please try again.')

// Timeout
// Handled automatically with 30-second timeout
```

### API Errors
```dart
// Invalid response
ApiResponse.error(message: 'Invalid response from server.')

// API-specific errors (extracted from response)
ApiResponse.error(message: 'Account is already activated.') // Example
```

### Usage with Try-Catch
```dart
try {
  final result = await service.uploadLogoAndGenerateDesign(...);
  
  if (result.success) {
    // Handle success
  } else {
    // Handle API error
    print(result.errorMessage);
  }
} catch (e) {
  // Handle exception
  print('Unexpected error: $e');
}
```

## MockupDialog Integration

The MockupDialog now supports both asset and network images:

### Display Asset Images (Default)
```dart
MockupDialog.show(
  context,
  // No images parameter = uses default assets
  onSaveImages: () {},
  onAddToCollections: () {},
);
```

### Display Network Images (API Response)
```dart
MockupDialog.show(
  context,
  images: [
    'http://10.10.7.82:8008/results/bag_front.png',
    'http://10.10.7.82:8008/results/bag_back.png',
  ],
  isNetworkImage: true, // Important!
  onSaveImages: () {},
  onAddToCollections: () {},
);
```

## Features

### ✅ Implemented Features
1. **Logo Upload** - Upload image as multipart/form-data
2. **Design Generation** - Generate bag design with logo URL
3. **Combined API Call** - Upload and generate in one method
4. **Network Image Support** - Display images from URLs
5. **Loading States** - Progress indicators while loading
6. **Error States** - Error UI with retry option
7. **Zoom Capability** - Pinch to zoom on both asset and network images
8. **Carousel Slider** - Swipe between front and back views
9. **Error Handling** - Comprehensive error messages
10. **100% OOP** - Follows your code patterns perfectly

### 🎨 UI Features
- **Loading Indicator** - Shows while network image loads
- **Error Display** - Shows error icon and message if load fails
- **Smooth Transitions** - Fade in when image loads
- **Zoom Hint** - "Tap to zoom" overlay on images
- **Fullscreen Gallery** - Pinch to zoom, swipe to navigate

## Code Structure (OOP)

### Singleton Pattern
```dart
class BagDesignService {
  BagDesignService._();
  static final BagDesignService _instance = BagDesignService._();
  static BagDesignService get instance => _instance;
}
```

### Encapsulation
- Private methods start with `_`
- Public API is clean and simple
- Internal implementation hidden

### Single Responsibility
- `BagDesignService` - Handles API calls only
- `LogoUploadResponseModel` - Represents logo upload response
- `DesignGenerationResponseModel` - Represents design response
- `MockupDialog` - Displays mockup images only

### Type Safety
- All responses properly typed
- Null safety enforced
- ApiResponse wrapper for success/error

## Testing Checklist

- [x] Logo upload with multipart/form-data
- [x] Design generation with JSON body
- [x] Combined upload and generate
- [x] Network image display in carousel
- [x] Network image zoom in fullscreen
- [x] Loading indicators
- [x] Error handling
- [x] Error display UI
- [x] Timeout handling (30 seconds)
- [x] No internet handling
- [x] 100% OOP maintained

## Performance Optimizations

1. **HTTP Client Reuse** - Single client instance (singleton)
2. **Timeout Configuration** - 30-second timeout prevents hanging
3. **Image Caching** - Flutter automatically caches network images
4. **Lazy Loading** - Images load only when displayed
5. **Progress Indicators** - Shows loading progress with bytes loaded

## Summary

✅ **Complete Implementation** with 100% OOP principles
✅ **Uses `http` package** - No external dependencies needed
✅ **Network Image Support** - Full carousel and zoom capability
✅ **Error Handling** - Comprehensive error messages and UI
✅ **Type Safe** - All models properly typed
✅ **Singleton Pattern** - Efficient resource usage
✅ **Following Your Code Style** - Matches existing patterns perfectly

The bag design API integration is now complete and ready to use! 🎉
