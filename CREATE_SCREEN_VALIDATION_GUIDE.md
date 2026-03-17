# Create Screen Validation Guide

## Overview
The Create screen now has proper validation to ensure users select a bag type before proceeding with Upload or Generate AI options.

## User Flow

### Step 1: Select Bag Type First
Users must choose one of the two bag types:
- **Create Full Graphic Bag** (left option)
- **Create Label Bag** (right option)

### Step 2: Choose Creation Method
After selecting a bag type, users can choose:
- **Upload Image/Logo** - Add your logo or completed design
- **Generate with AI** - Generate a label with artificial intelligence

## Validation Logic

### Scenario 1: User Clicks Without Selecting Bag Type ❌
**What happens:**
- User clicks "Upload Image/Logo" or "Generate with AI"
- **No bag type is selected**
- A **red toast notification** appears at the bottom:
  ```
  Please select Create Label Bag or Create Full Graphics Bag first
  ```
- No navigation occurs
- No popup dialog is shown

### Scenario 2: User Selects Bag Type Then Clicks ✅
**What happens:**
- User first selects a bag type (Full Graphic or Label)
- User then clicks "Upload Image/Logo" or "Generate with AI"
- Animation plays on the selected option
- Product selection popup appears
- User can proceed with their design

## Toast Notification Styles

### Error/Warning Messages (Red)
- **Background:** `#F44336` (Red)
- **Duration:** LONG (3-4 seconds)
- **Use case:** Validation errors, missing selections
- **Example:** "Please select Create Label Bag or Create Full Graphics Bag first"

### Success Messages (Green)
- **Background:** `#4CAF50` (Green)
- **Duration:** SHORT (2-3 seconds)
- **Use case:** Successful actions
- **Example:** "Product selected successfully!"

## Toggle Behavior

### Bag Type Selection
- Clicking a bag type **selects** it
- Clicking the **same** bag type again **deselects** it
- Selecting a different bag type **switches** the selection
- Deselecting resets all animation states

### Creation Method Selection
- Clicking a creation method toggles its animation
- Only one method can be animating at a time
- Clicking the same method again stops the animation
- No popup shows when deselecting

## Code Implementation

### Controller Location
`lib/controllers/create_controller/create_controller.dart`

### Key Methods
- `onUploadTap(BuildContext context)` - Handles Upload button with validation
- `onGenerateAITap(BuildContext context)` - Handles AI button with validation
- `_showMessage(String message)` - Shows red error/warning toast
- `_showSuccess(String message)` - Shows green success toast

### Validation Check
```dart
if (_selectedOption.value == null) {
  _showMessage('Please select Create Label Bag or Create Full Graphics Bag first');
  return;
}
```

## UI Consistency

This validation pattern follows the same OOP and toast notification style used throughout the app:
- Sign Up validation
- Login validation
- Profile update validation
- Password change validation
- OTP verification validation

All use **Fluttertoast** for consistent user feedback.

## Testing Checklist

- [ ] Click Upload without selecting bag type → Red toast appears
- [ ] Click Generate AI without selecting bag type → Red toast appears
- [ ] Select Full Graphic → Click Upload → Popup appears
- [ ] Select Full Graphic → Click Generate AI → Popup appears
- [ ] Select Label Bag → Click Upload → Popup appears
- [ ] Select Label Bag → Click Generate AI → Popup appears
- [ ] Select bag type → Deselect → Click Upload → Red toast appears
- [ ] Toast message is readable and appears at bottom of screen
- [ ] Toast disappears after appropriate duration

## Related Files
- `lib/views/create/create.dart` - Create screen UI
- `lib/controllers/create_controller/create_controller.dart` - Business logic
- `lib/widgets/product_selection_dialog.dart` - Product selection popup
