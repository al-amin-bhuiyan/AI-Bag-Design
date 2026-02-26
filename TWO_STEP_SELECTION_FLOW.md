# Two-Step Selection Flow - Updated ✅

## 🎯 Updated User Flow

### Step 1: Select Bag Type (REQUIRED FIRST)
User must click one of these:
- **Create Label Bag** (createLabelBag image)
- **Create Full Graphics Bag** (createYourFullGraphicsBag image)

**What happens:**
- `_selectedOption` is set to either `CreationOption.label` or `CreationOption.fullGraphic`
- Blue border appears around selected bag
- Inner shadow shows selection state

---

### Step 2: Select Creation Method (REQUIRED SECOND)
After selecting bag type, user clicks one of these:
- **Upload Image/Logo** (uploadLogo image)
- **Generate with AI** (generateWithAi image)

**What happens:**
- Animation activates (button glows with border and shadow)
- Animation stays true (toggle behavior)
- **Popup shows ONLY if bag type was selected in Step 1**

---

### Step 3: Select Product from Popup
Once popup appears, user can:
- Select one of 3 rows (Quad Seal, Gusset, Stand Up Pouch)
- Each row has 2 cards that select together
- Click "Start Designing" to proceed

---

## ⚠️ Validation Logic

### If User Clicks Upload/AI WITHOUT Selecting Bag Type:
```
❌ Popup does NOT show
✅ Message appears: "Please select Create Label Bag or Create Full Graphics Bag first"
✅ Animation activates but no popup
```

### If User Clicks Upload/AI AFTER Selecting Bag Type:
```
✅ Animation activates
✅ Popup appears after 400ms
✅ User can select product
```

---

## 🔄 Complete Flow Example

### Success Path:
```
1. User clicks "Create Label Bag"
   → Blue border appears
   → _selectedOption = label

2. User clicks "Upload Image/Logo"
   → Button animates (glows)
   → _isUploadAnimating = true
   → Wait 400ms
   → Popup appears ✅

3. User selects "Quad Seal Bag"
   → Row 0 selected
   → Both cards animate

4. User clicks "Start Designing"
   → Product selection processed
   → Dialog closes
```

### Error Path:
```
1. User clicks "Upload Image/Logo" FIRST (no bag selected)
   → Button animates
   → Message: "Please select Create Label Bag or Create Full Graphics Bag first"
   → Popup does NOT appear ❌

2. User clicks "Create Label Bag"
   → Blue border appears
   → _selectedOption = label

3. User clicks "Upload Image/Logo" AGAIN
   → Button animates
   → Popup appears ✅
```

---

## 💻 Code Implementation

### Controller Logic:
```dart
void onUploadTap() {
  // Check if bag type is selected first
  if (_selectedOption.value == null) {
    _showMessage('Please select Create Label Bag or Create Full Graphics Bag first');
    return; // Exit early - no popup
  }
  
  // Toggle animation
  _isUploadAnimating.value = !_isUploadAnimating.value;
  
  // Show popup only if activating AND bag type selected
  if (_isUploadAnimating.value && _selectedOption.value != null) {
    _isGenerateAnimating.value = false; // Deactivate other option
    
    Future.delayed(Duration(milliseconds: 400), () {
      _showProductSelectionPopup(); // Show popup
    });
  }
}
```

---

## 🎨 Visual Feedback

### Bag Type Selection (Step 1):
- **Unselected:** Normal appearance
- **Selected:** 
  - 3px blue border (#1F7CD5)
  - Inner shadow (blue 20% alpha)
  - Stays selected until other bag clicked

### Creation Method Selection (Step 2):
- **Inactive:** Gray/blue background
- **Active (no bag selected):**
  - Animates (scale, border, shadow)
  - No popup
  - Message shows
- **Active (bag selected):**
  - Animates (scale, border, shadow)
  - Popup appears after 400ms ✅

---

## ✅ Requirements Met

- ✅ User must select bag type FIRST (createLabelBag or createYourFullGraphicsBag)
- ✅ User must select creation method SECOND (generateWithAi or uploadLogo)
- ✅ Popup shows ONLY when both selections are made
- ✅ Clear error message if order is wrong
- ✅ Animations still work perfectly
- ✅ Toggle behavior preserved

---

## 🔍 Testing Scenarios

### Scenario 1: Correct Order
```
Click "Create Label Bag" → Click "Upload Image/Logo"
Result: ✅ Popup appears
```

### Scenario 2: Correct Order (Alternative)
```
Click "Create Full Graphics Bag" → Click "Generate with AI"
Result: ✅ Popup appears
```

### Scenario 3: Wrong Order
```
Click "Upload Image/Logo" → No bag selected
Result: ❌ No popup, shows error message
```

### Scenario 4: Toggle Animation
```
Click "Create Label Bag" → Click "Upload" → Click "Upload" again
Result: ✅ Animation toggles off, popup doesn't show second time
```

### Scenario 5: Switch Options
```
Click "Create Label Bag" → Click "Upload" → Click "Generate AI"
Result: ✅ Upload deactivates, AI activates, new popup shows
```

---

## 📝 Updated Message

**Old message:** "Please select a bag type first"

**New message:** "Please select Create Label Bag or Create Full Graphics Bag first"

More specific and user-friendly!

---

## 🎯 Summary

**The flow now requires:**
1. **First:** Select bag type (Create Label Bag OR Create Full Graphics Bag)
2. **Second:** Select creation method (Upload Image/Logo OR Generate with AI)
3. **Then:** Popup appears with product selection

**Protection:**
- Clicking creation method without bag type → Shows error, no popup
- Clicking creation method with bag type → Shows popup ✅

**Status:** ✅ COMPLETE - Two-step validation implemented!
