# Welcome Screen Update Guide

## ✅ What Has Been Updated

1. **Updated File**: `lib/screens/bms_welcome_screen.dart`
   - Changed to match Figma design exactly
   - Added support for real background image
   - Updated logo display
   - Added profile images for chat bubbles
   - Adjusted colors to match Figma (Green: #A3FF05, Yellow: #FFC403, Orange: #FF730F, Pink: #FF0F3B)

2. **Created Directory**: `assets/images/screens/`

3. **Updated**: `pubspec.yaml` to include profile image assets

## 📋 What You Need To Do

### Step 1: Export Images from Figma

Open your Figma file and export these images:

1. **Logo (Node ID: 18:7)**
   - Right-click → Export
   - Format: PNG
   - Scale: 2x or 3x
   - Save as: `logo.png`

2. **Main Background Image (Node ID: 18:47 - Mask group)**
   - Right-click → Export
   - Format: PNG
   - Scale: 2x or 3x
   - Save as: `main_person.png`

### Step 2: Add Images to Project

Copy the exported images to:
```
C:\Users\Hp\Desktop\BMS\bms\assets\images\screens\
```

Your final structure should look like:
```
assets/
  images/
    screens/
      logo.png          ← Add this
      main_person.png   ← Add this
    profile1.png        ← Already exists
    profile2.png        ← Already exists
    profile3.png        ← Already exists
    profile4.png        ← Already exists
```

### Step 3: Run Flutter Commands

In your terminal, navigate to the project and run:

```bash
cd C:\Users\Hp\Desktop\BMS\bms
flutter pub get
flutter clean
flutter run
```

## 🎨 Design Details Implemented

- **Background**: Real person image with dark overlay
- **Logo**: "BOOK MY SPORTZ" logo at the top
- **Chat Bubbles**: 
  - Top left (Green): "Lets play..."
  - Top right (Yellow): "Lets play..."
  - Middle left (Orange): "I'm in."
  - Bottom right (Pink): "I'm in."
- **Central Message**: "Wanna play today?" in green bubble
- **Button**: "Get Started" with green background
- **Skip Option**: White text at the bottom

## 🔧 Fallback Behavior

If images are not found, the app will:
- Show a placeholder logo with "BOOK MY SPORTZ" text
- Display a dark gradient background
- Use colored avatars with person icons instead of profile images

## ⚠️ Important Notes

1. Make sure image file names are exactly as specified (case-sensitive)
2. Use high-resolution images (2x or 3x) for better quality on different devices
3. The profile images (profile1-4.png) should be square and at least 300x300px
4. After adding images, always run `flutter pub get` and restart the app

## 📱 Expected Result

The welcome screen will now match your Figma design with:
- Real background image of person with phone
- Proper logo
- Profile pictures in chat bubbles
- Exact color scheme
- Same layout and positioning

## 🐛 Troubleshooting

**Images not showing?**
1. Check file paths are correct
2. Verify image files are in the right folder
3. Run `flutter clean` then `flutter pub get`
4. Restart the app completely

**Colors look different?**
- The exact colors from Figma are already implemented in the code

**Layout issues?**
- The positioning matches the Figma design
- May need minor adjustments based on actual image dimensions
