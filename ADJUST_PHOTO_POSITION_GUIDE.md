# 📐 Guide: Adjusting Main Photo Position

## Current Settings (Line ~89 in bms_welcome_screen.dart)

```dart
Positioned(
  top: 0,        // Move up/down
  left: -50,     // Move left/right
  right: -50,    // Adjust width from right
  bottom: 0,     // Adjust from bottom
  child: Image.asset(
    'assets/images/screens/main_person.png',
    fit: BoxFit.cover,
    alignment: Alignment.center,
    ...
  ),
),
```

## 🎯 How to Adjust Position

### 1. **Vertical Position** (Move Up/Down)

Change the `top` value:

```dart
top: -50,   // Move image UP by 50 pixels
top: 0,     // Original position (no offset)
top: 50,    // Move image DOWN by 50 pixels
top: 100,   // Move image DOWN more
```

### 2. **Horizontal Position** (Move Left/Right)

Change the `left` value:

```dart
left: -100,  // Move image LEFT (more zoomed in)
left: -50,   // Current setting
left: 0,     // Original position
left: 50,    // Move image RIGHT
```

### 3. **Image Width/Zoom**

Adjust `left` and `right` together:

```dart
// More zoomed in (person bigger):
left: -100,
right: -100,

// Current (slightly zoomed):
left: -50,
right: -50,

// Normal width (no zoom):
left: 0,
right: 0,

// Narrower (person smaller):
left: 50,
right: 50,
```

### 4. **Image Fit Options**

Change the `fit` property:

```dart
// Current - scales to cover entire space, may crop:
fit: BoxFit.cover,

// Contain - shows entire image, may have borders:
fit: BoxFit.contain,

// Fill - stretches to fill (may distort):
fit: BoxFit.fill,

// Fit height - matches height, may crop width:
fit: BoxFit.fitHeight,

// Fit width - matches width, may crop height:
fit: BoxFit.fitWidth,
```

### 5. **Alignment Options**

Change the `alignment` property:

```dart
// Center (current):
alignment: Alignment.center,

// Top aligned:
alignment: Alignment.topCenter,

// Bottom aligned:
alignment: Alignment.bottomCenter,

// Custom alignment (x, y from -1 to 1):
alignment: Alignment(0, -0.3),  // Slightly above center
alignment: Alignment(0, 0.2),   // Slightly below center
```

## 🎨 Common Adjustments

### Example 1: Center the person's face more
```dart
Positioned(
  top: -30,      // Move up slightly
  left: -50,
  right: -50,
  bottom: 0,
  child: Image.asset(
    'assets/images/screens/main_person.png',
    fit: BoxFit.cover,
    alignment: Alignment(0, -0.2),  // Focus slightly higher
```

### Example 2: Show more of the person
```dart
Positioned(
  top: 0,
  left: 0,       // Less zoom
  right: 0,      // Less zoom
  bottom: 0,
  child: Image.asset(
    'assets/images/screens/main_person.png',
    fit: BoxFit.contain,  // Show full image
    alignment: Alignment.center,
```

### Example 3: Zoom in on the person
```dart
Positioned(
  top: -20,
  left: -100,    // More zoom
  right: -100,   // More zoom
  bottom: 0,
  child: Image.asset(
    'assets/images/screens/main_person.png',
    fit: BoxFit.cover,
    alignment: Alignment.center,
```

### Example 4: Position person lower
```dart
Positioned(
  top: 100,      // Move down
  left: -50,
  right: -50,
  bottom: 0,
  child: Image.asset(
    'assets/images/screens/main_person.png',
    fit: BoxFit.cover,
    alignment: Alignment.topCenter,  // Align to top
```

## 🔧 Step-by-Step Process

1. **Open the file:**
   ```
   C:\Users\Hp\Desktop\BMS\bms\lib\screens\bms_welcome_screen.dart
   ```

2. **Find line ~89** (the Positioned widget with the main_person.png)

3. **Adjust one value at a time:**
   - Start with `top` to move vertically
   - Then adjust `left/right` for horizontal positioning
   - Change `fit` if needed
   - Fine-tune with `alignment`

4. **Hot reload to see changes:**
   - Press `r` in the terminal running flutter
   - Or press the hot reload button in your IDE

5. **Save your changes** when you're happy with the position

## 💡 Pro Tips

### Quick Positioning
- **Person too low?** → Decrease `top` (make it negative)
- **Person too high?** → Increase `top`
- **Person too left?** → Increase `left`
- **Person too right?** → Decrease `left` (make it negative)
- **Want to zoom in?** → Make `left` and `right` more negative (e.g., -100, -100)
- **Want to zoom out?** → Make `left` and `right` closer to 0 or positive

### Testing Different Options

Try these quick settings:

**Option A - Centered & Zoomed:**
```dart
top: -20,
left: -80,
right: -80,
fit: BoxFit.cover,
alignment: Alignment.center,
```

**Option B - Full View:**
```dart
top: 50,
left: 0,
right: 0,
fit: BoxFit.contain,
alignment: Alignment.center,
```

**Option C - Upper Body Focus:**
```dart
top: -50,
left: -50,
right: -50,
fit: BoxFit.cover,
alignment: Alignment(0, -0.3),
```

## 📱 Testing

After each change:

```bash
# In your Flutter terminal, press:
r  # Hot reload (fast)

# Or if that doesn't work:
R  # Hot restart (slower but complete)
```

## ⚠️ Common Issues

**Image looks stretched?**
- Change `fit: BoxFit.cover` to `fit: BoxFit.contain`

**Can't see the whole person?**
- Set `left: 0` and `right: 0`
- Or change to `fit: BoxFit.contain`

**Image is blurry?**
- Export a higher resolution image from Figma (3x scale)

**Position looks different on different devices?**
- Use `BoxFit.cover` with `alignment` for consistency
- Test on multiple screen sizes

## 🎯 Recommended Settings

Based on the Figma design, I recommend:

```dart
Positioned(
  top: 0,
  left: -50,
  right: -50,
  bottom: 0,
  child: Image.asset(
    'assets/images/screens/main_person.png',
    fit: BoxFit.cover,
    alignment: Alignment.center,
```

This gives a nice zoomed-in look that matches the design while keeping the person centered.

**Need more help?** Let me know what specific adjustment you want (e.g., "move person up", "zoom in more") and I'll give you the exact values!
