# 📸 How to Update Profile Images - Complete Guide

## What You Need to Do

Update the 4 chat bubble profile images in your welcome screen.

## 📍 Where to Place Images

All profile images go here:
```
C:\Users\Hp\Desktop\BMS\bms\assets\images\
```

Required files:
- `profile1.png` - Top left bubble (green border)
- `profile2.png` - Top right bubble (yellow border)
- `profile3.png` - Middle left bubble (orange border)
- `profile4.png` - Bottom right bubble (pink/red border)

---

## 🎯 Method 1: Export from Figma (Recommended)

### Step-by-Step:

1. **Open your Figma file** in desktop app

2. **Navigate to the welcome screen** design (Page 1 / Frame 01)

3. **Export each profile circle:**

   **For Profile 1 (Green bubble - "Lets play..."):**
   - Click on the circular profile image in the top-left green bubble
   - Look for the ellipse/circle with the profile photo
   - Right panel → Export section
   - Add export: PNG, 2x or 3x scale
   - Export and save as `profile1.png`

   **For Profile 2 (Yellow bubble - "Lets play..."):**
   - Click on the circular profile image in the top-right yellow bubble
   - Export as PNG
   - Save as `profile2.png`

   **For Profile 3 (Orange bubble - "I'm in."):**
   - Click on the circular profile image in the middle-left orange bubble
   - Export as PNG
   - Save as `profile3.png`

   **For Profile 4 (Pink bubble - "I'm in."):**
   - Click on the circular profile image in the bottom-right pink bubble
   - Export as PNG
   - Save as `profile4.png`

4. **Move all 4 files to:**
   ```
   C:\Users\Hp\Desktop\BMS\bms\assets\images\
   ```

5. **Reload the app:**
   ```bash
   flutter pub get
   flutter run
   # Or press 'r' for hot reload
   ```

---

## 🎯 Method 2: Use Your Own Images (Quick)

If you have your own images or want to use different photos:

### Requirements:
- **Format:** PNG or JPG (PNG preferred)
- **Size:** 300x300 pixels or larger (square)
- **Quality:** Clear, good resolution
- **Content:** Face/portrait photos work best

### Steps:

1. **Prepare 4 images** (can be any photos)

2. **Rename them:**
   - First image → `profile1.png`
   - Second image → `profile2.png`
   - Third image → `profile3.png`
   - Fourth image → `profile4.png`

3. **Copy to:**
   ```
   C:\Users\Hp\Desktop\BMS\bms\assets\images\
   ```

4. **Run:**
   ```bash
   flutter pub get
   flutter run
   ```

---

## 🎯 Method 3: Download Free Stock Photos

### Option A: Unsplash (Free high-quality)

1. Go to: https://unsplash.com/s/photos/portrait
2. Download 4 different portrait photos
3. Rename as profile1.png through profile4.png
4. Place in `assets/images/`

### Option B: AI Generated Faces

1. Go to: https://thispersondoesnotexist.com/
2. Refresh page 4 times, save each face
3. Rename as profile1-4.png
4. Place in `assets/images/`

### Option C: UI Avatars (Generated)

1. Go to: https://ui-avatars.com/
2. Generate 4 different avatars with different:
   - Names
   - Background colors
   - Font sizes
3. Download and rename
4. Place in `assets/images/`

---

## 🎯 Method 4: Create Simple Placeholder (Fast)

### Using MS Paint or any editor:

1. **Create a 300x300 image**
2. **Fill with solid color:**
   - Profile 1: Light green
   - Profile 2: Light yellow
   - Profile 3: Light orange
   - Profile 4: Light pink
3. **Add text/icon if you want**
4. **Save as PNG** with correct names
5. **Place in assets folder**

---

## ✅ Verify Images Are Added

### Check files exist:

```bash
cd C:\Users\Hp\Desktop\BMS\bms\assets\images
dir *.png
```

You should see:
```
profile1.png
profile2.png
profile3.png
profile4.png
```

### Check file sizes:

Each file should be:
- **Minimum:** 10 KB
- **Recommended:** 50-500 KB
- **Maximum:** 2 MB (if larger, compress it)

---

## 🔄 After Adding Images

### Step 1: Tell Flutter about new assets
```bash
cd C:\Users\Hp\Desktop\BMS\bms
flutter pub get
```

### Step 2: Clean build (if images don't show)
```bash
flutter clean
flutter pub get
```

### Step 3: Run the app
```bash
flutter run
# Or press 'r' for hot reload if already running
```

---

## 🎨 Image Tips

### Best Practices:
- ✅ Use square images (same width and height)
- ✅ Clear, well-lit photos
- ✅ Face/upper body visible
- ✅ Good contrast
- ✅ PNG format for best quality

### Avoid:
- ❌ Rectangular images (will be cropped)
- ❌ Very large files (>2MB)
- ❌ Blurry or pixelated images
- ❌ Images with text overlays

### Image Quality:
- **300x300**: Minimum acceptable
- **600x600**: Good quality
- **1000x1000**: Excellent quality
- **2000x2000**: Overkill (too large)

---

## 🐛 Troubleshooting

### Problem: Images not showing

**Solution 1: Check file names**
```bash
# Exact names required (case-sensitive):
profile1.png
profile2.png
profile3.png
profile4.png
```

**Solution 2: Run pub get**
```bash
flutter pub get
flutter clean
flutter run
```

**Solution 3: Check file location**
Files must be in:
```
C:\Users\Hp\Desktop\BMS\bms\assets\images\
```
NOT in subdirectories!

**Solution 4: Restart app completely**
```bash
# Stop the app (Ctrl+C)
flutter clean
flutter pub get
flutter run
```

### Problem: Images look distorted

**Solution:**
- Use square images (1:1 aspect ratio)
- Minimum 300x300 pixels
- Don't use very wide or tall images

### Problem: App crashes after adding images

**Solution:**
- Check file formats (PNG or JPG only)
- Check file sizes (not too large)
- Make sure files aren't corrupted
- Try different images

---

## 📋 Quick Checklist

Before running the app:
- [ ] 4 image files created/downloaded
- [ ] Renamed to profile1.png, profile2.png, profile3.png, profile4.png
- [ ] Placed in `C:\Users\Hp\Desktop\BMS\bms\assets\images\`
- [ ] Files are square (same width/height)
- [ ] Files are PNG format
- [ ] Ran `flutter pub get`
- [ ] Ready to run `flutter run`

---

## 🎯 Expected Result

After adding images, your welcome screen will show:

```
┌─────────────────────┐
│ Logo                │
│                     │
│  🖼️ Lets play...    │  ← Real photo 1
│          🖼️ Lets... │  ← Real photo 2
│                     │
│  🖼️ I'm in.         │  ← Real photo 3
│          🖼️ I'm in. │  ← Real photo 4
│                     │
│ Wanna play today?   │
│                     │
│ [Get Started]       │
└─────────────────────┘
```

Each circle will show your profile image with colored borders!

---

## 💡 Recommendation

**Start simple:**
1. Download 4 free stock photos from Unsplash
2. Rename them as profile1-4.png
3. Place in assets/images/
4. Run `flutter pub get`
5. Launch app

This takes less than 5 minutes and looks great!

---

## 🚀 Ready to Update?

Which method do you want to use?
1. **Export from Figma** (best match to design)
2. **Download stock photos** (fastest - 5 minutes)
3. **Use your own images** (custom look)
4. **Create placeholders** (temporary solution)

Let me know and I'll provide more specific guidance!
