# AI Generation Animation - Visual Flow

## User Journey

```
┌─────────────────────────────────────────────────────────────────┐
│  STEP 1: Upload Image Screen                                    │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  [Back]         Create              [Refresh]             │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │                                                           │  │
│  │              ┌─────────────────────┐                     │  │
│  │              │ Start Designing     │                     │  │
│  │              │ Select an image to  │                     │  │
│  │              │ add to your label   │                     │  │
│  │              │                     │                     │  │
│  │              │  [Upload from       │                     │  │
│  │              │   your Gallery]     │                     │  │
│  │              └─────────────────────┘                     │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

                            ↓ User selects image

┌─────────────────────────────────────────────────────────────────┐
│  STEP 2: Image Preview Screen                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  [Back]         Create              [Refresh]             │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │  [💾 Save]                                                │  │
│  │                                                           │  │
│  │              ┌─────────────────────┐                     │  │
│  │              │                     │                     │  │
│  │              │   [UPLOADED IMAGE]  │                     │  │
│  │              │                     │                     │  │
│  │              └─────────────────────┘                     │  │
│  │                                                           │  │
│  │              [👜 Show Bag Design]  ← USER CLICKS HERE    │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

                            ↓ Animation starts

┌─────────────────────────────────────────────────────────────────┐
│  STEP 3: AI Generation Loading Animation (3 seconds)            │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │        Creating Bag Design                          [X]   │  │
│  ├───────────────────────────────────────────────────────────┤  │
│  │                                                           │  │
│  │              ┌─────────────────────┐                     │  │
│  │              │  ╔═════════════╗   │                     │  │
│  │              │  ║             ║   │                     │  │
│  │              │  ║   ⚪ ⚪ ⚪   ║   │  ← Animated        │  │
│  │              │  ║  ⚪  ✨  ⚪  ║   │    Neural Network  │  │
│  │              │  ║   ⚪ ⚪ ⚪   ║   │                     │  │
│  │              │  ║   (Glowing)  ║   │                     │  │
│  │              │  ╚═════════════╝   │                     │  │
│  │              └─────────────────────┘                     │  │
│  │                                                           │  │
│  │  We're hard at work making your ideas come to life!     │  │
│  │  Your bag design will be ready in 10-20 seconds.        │  │
│  │                                                           │  │
│  │                    ⭕ Loading...                          │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

                            ↓ Generation complete

┌─────────────────────────────────────────────────────────────────┐
│  STEP 4: Mockup Dialog                                          │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                                                      [X]   │  │
│  │  ┌─────────────────────────────────────────────────────┐  │  │
│  │  │                                                     │  │  │
│  │  │         ┌─────────────────────────┐               │  │  │
│  │  │         │  [BAG MOCKUP IMAGE 1]   │               │  │  │
│  │  │         └─────────────────────────┘               │  │  │
│  │  │                                                     │  │  │
│  │  │  < >   [BAG MOCKUP IMAGE 2]                        │  │  │
│  │  │                                                     │  │  │
│  │  └─────────────────────────────────────────────────────┘  │  │
│  │                                                           │  │
│  │  [💾 Save Images]  [📁 Add to Collections]              │  │
│  │                                                           │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Animation Details

### Neural Network Animation Components

```
   ⚪ ─────── ⚪
   │ ╲     ╱ │        ← Particles (nodes)
   │   ✨ ← Glowing center orb (AI icon)
   │ ╱     ╲ │
   ⚪ ─────── ⚪
```

**1. Expanding Ripples (Pulse)**
- 3 concentric circles expanding outward
- Fade out as they expand
- Creates wave effect
- Speed: 1500ms per cycle

**2. Neural Network Particles**
- 8 nodes positioned in circle
- Connected by lines when close
- Rotating slowly around center
- Pulsing size animation
- Alternating colors (primary/secondary)

**3. Central Glowing Orb**
- Radial gradient glow effect
- Contains sparkle icon (✨)
- Multiple shadow layers
- Constant bright presence

**4. Data Flow Lines**
- Animated arcs showing data transfer
- 3 flow paths rotating
- Fade in/out effect
- Shows "processing" motion

### Color Scheme
- Primary: `#1F7CD5` (Blue)
- Secondary: `#008BA6` (Teal)
- Background: `#F5F5F5` (Light Gray)
- Accent: `#FFF5E1` (Light Gold)

### Timing
- Pulse Animation: 1500ms (reverse repeat)
- Rotation Animation: 3000ms (continuous)
- Generation Delay: 3000ms (simulated)
- Total User Wait: ~3 seconds

## Code Flow

```
User clicks "Show Bag Design"
         ↓
showDialog() displays AIGenerationLoadingWidget
         ↓
Widget initiates animation controllers
         ↓
Pulse + Rotation animations start
         ↓
onGenerate callback executes
         ↓
await Future.delayed(3 seconds)
         ↓
onClose callback triggered
         ↓
Dialog closes
         ↓
MockupDialog.show() displays result
         ↓
User can save or add to collections
```

## Key Features

✅ **Smooth Animations**: 60fps performance
✅ **Custom Painting**: Efficient canvas rendering
✅ **Responsive Design**: Scales with screen size
✅ **Dismissible**: Close button available
✅ **Informative**: Clear messaging about wait time
✅ **Professional**: Premium feel with glows and shadows

## Customization Options

```dart
// Adjust generation time
await Future.delayed(const Duration(seconds: 5)); // Default: 3

// Change colors
primaryColor: Color(0xFFFF0000),  // Red
secondaryColor: Color(0xFF00FF00), // Green

// Adjust animation speed
duration: Duration(milliseconds: 2000), // Faster/Slower

// Change particle count
for (int i = 0; i < 12; i++) // More particles
```

## Performance Notes

- Uses `CustomPainter` for efficient rendering
- Only repaints when animation progress changes
- Animation controllers properly disposed
- Minimal widget rebuilds with `AnimatedBuilder`
- No memory leaks

## Integration Points

1. **Upload Image Screen** → Shows animation
2. **AI Generation Widget** → Handles animation display
3. **Mockup Dialog** → Shows final result
4. **Controller** → Manages business logic

## Future Enhancements

🔄 Progress percentage (0-100%)
🌐 Real AI API integration
❌ Cancel generation mid-process
💾 Cache generated results
🎨 Multiple animation styles
📊 Detailed progress messages
