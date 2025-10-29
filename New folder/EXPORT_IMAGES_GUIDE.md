# 📸 Export Images from Figma - Step by Step Guide

## Images You Need to Export

I've identified all the images from your Figma design. Here's exactly what to export:

### 1. **Logo** (Node: 18:50)
- **File name:** `logo.png`
- **Location:** `C:\Users\Hp\Desktop\BMS\bms\assets\images\screens\`
- **Export settings:** PNG, 3x scale
- **How to find:** The "BOOK MY SPORTZ" logo at the top

### 2. **Main Background** (Node: 18:47 - Mask group)
- **File name:** `main_person.png`
- **Location:** `C:\Users\Hp\Desktop\BMS\bms\assets\images\screens\`
- **Export settings:** PNG, 2x or 3x scale
- **How to find:** The main person with phone, soccer ball, and basketball

### 3. **Profile Images** (From chat bubbles)

#### Profile 1 (Node: 18:65 - Top left, green bubble)
- **File name:** `profile1.png`
- **Location:** `C:\Users\Hp\Desktop\BMS\bms\assets\images\`
- **Export:** Just the circular profile image (person in green frame)
- **Export settings:** PNG, 300x300px or larger

#### Profile 2 (Node: 18:61 - Top right, yellow bubble)  
- **File name:** `profile2.png`
- **Location:** `C:\Users\Hp\Desktop\BMS\bms\assets\images\`
- **Export:** Just the circular profile image (person in yellow frame)
- **Export settings:** PNG, 300x300px or larger

#### Profile 3 (Node: 18:57 - Middle left, orange bubble)
- **File name:** `profile3.png`
- **Location:** `C:\Users\Hp\Desktop\BMS\bms\assets\images\`
- **Export:** Just the circular profile image (person in orange frame)
- **Export settings:** PNG, 300x300px or larger

#### Profile 4 (Node: 18:42 - Bottom right, pink bubble)
- **File name:** `profile4.png`
- **Location:** `C:\Users\Hp\Desktop\BMS\bms\assets\images\`
- **Export:** Just the circular profile image (person in pink frame)
- **Export settings:** PNG, 300x300px or larger

---

## 🎯 Step-by-Step Export Process

### Method 1: Using Figma Desktop App

1. **Open your Figma file** in the desktop app
2. **For each element:**
   
   **For Logo:**
   - Click on the Logo layer (shows "BOOK MY SPORTZ")
   - Right panel → Scroll to "Export" section
   - Click "+" to add export setting
   - Select "PNG" format
   - Set scale to "3x"
   - Click "Export Logo"
   - Save as `logo.png` in `C:\Users\Hp\Desktop\BMS\bms\assets\images\screens\`

   **For Main Background:**
   - Click on the "Mask group" layer (the main person image)
   - Export section → Add "PNG", "2x" or "3x" scale
   - Click "Export Mask group"
   - Save as `main_person.png` in `C:\Users\Hp\Desktop\BMS\bms\assets\images\screens\`

   **For Profile Images:**
   - For each chat bubble group (Group 1000002883, 1000002880, 1000002881, 1000002882)
   - Click on the **circle/ellipse** inside each group (the profile picture part)
   - Export as PNG
   - Save as profile1.png, profile2.png, profile3.png, profile4.png in `C:\Users\Hp\Desktop\BMS\bms\assets\images\`

### Method 2: Bulk Export (Faster)

1. **Select all items you want to export** (hold Ctrl/Cmd and click each):
   - Logo
   - Mask group
   - Each ellipse from the 4 chat bubble groups

2. **In the right panel:**
   - Export section → Add PNG export
   - Set scale to 2x or 3x
   - Click "Export [number] layers"

3. **Rename the exported files:**
   - Rename according to the list above
   - Move to correct folders

### Method 3: Using Figma Export Feature

1. Right-click on the canvas or layer
2. Select "Export as..."
3. Choose PNG format
4. Save with the correct filename

---

## 📁 Final Folder Structure

After exporting, your folder structure should be:

```
C:\Users\Hp\Desktop\BMS\bms\assets\images\
├── screens\
│   ├── logo.png              ← Logo
│   └── main_person.png       ← Background person
├── profile1.png              ← Green bubble profile
├── profile2.png              ← Yellow bubble profile
├── profile3.png              ← Orange bubble profile
└── profile4.png              ← Pink bubble profile
```

---

## ✅ Verification Steps

After exporting all images:

1. **Check that all files exist:**
   ```powershell
   cd C:\Users\Hp\Desktop\BMS\bms
   dir assets\images\*.png
   dir assets\images\screens\*.png
   ```

2. **Verify file sizes:**
   - Logo: ~50-200 KB
   - Main person: ~500KB - 2MB
   - Profile images: ~100-500 KB each

3. **Run the app:**
   ```bash
   flutter pub get
   flutter run
   ```

---

## 🎨 Export Quality Tips

- **Use 2x or 3x scale** for crisp images on high-DPI screens
- **PNG format** for transparency support
- **Profile images** should be square (same width and height)
- **Compress images** if file sizes are very large (use TinyPNG.com)

---

## 🚨 Alternative: Quick Placeholder Solution

If you can't export right now, you can use free placeholder images:

**For profile images, download from:**
- https://thispersondoesnotexist.com/ (AI generated faces)
- https://unsplash.com/s/photos/portrait (free stock photos)
- https://ui-avatars.com/api/?name=User+1&size=300 (generated avatars)

Just save 4 different images as profile1.png through profile4.png!

---

## ⚡ After Exporting

Once all images are in place:

```bash
cd C:\Users\Hp\Desktop\BMS\bms
flutter clean
flutter pub get
flutter run
```

Your app will now look exactly like the Figma design! 🎉
