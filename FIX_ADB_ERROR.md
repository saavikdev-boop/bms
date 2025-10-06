# 🔧 Fix: ADB Device Not Found Error

## Error: `adb.exe: device 'emulator-5554' not found`

This means your Android emulator disconnected or crashed.

## ✅ Quick Fix (Choose One)

### Option 1: Restart Emulator (Fastest)

1. **Close the emulator window** completely
2. **Restart the emulator** from Android Studio or AVD Manager
3. **Wait for it to fully boot** (shows home screen)
4. **Run flutter again:**
   ```bash
   flutter run
   ```

### Option 2: Use ADB to Restart

```bash
# Kill the adb server
adb kill-server

# Start it again
adb start-server

# Check connected devices
adb devices

# Run flutter
flutter run
```

### Option 3: Full Reset

```bash
# Stop Flutter
Ctrl + C (if still running)

# Kill ADB server
adb kill-server

# Close emulator completely

# Start emulator fresh from Android Studio

# Wait for boot (30-60 seconds)

# Start ADB
adb start-server

# Run Flutter
flutter run
```

### Option 4: Use Physical Device Instead

If emulator keeps failing:

1. **Enable USB Debugging** on your Android phone:
   - Settings → About Phone → Tap "Build Number" 7 times
   - Settings → Developer Options → Enable "USB Debugging"

2. **Connect phone via USB**

3. **Check device:**
   ```bash
   flutter devices
   ```

4. **Run on phone:**
   ```bash
   flutter run
   ```

## 🔍 Check What Devices Are Available

```bash
flutter devices
```

This shows all connected devices/emulators.

## 💡 Prevent This Issue

### Keep Emulator Stable:

1. **Allocate more RAM to emulator:**
   - Android Studio → AVD Manager
   - Edit your emulator
   - Advanced Settings → RAM: 2048 MB or more

2. **Use a simpler emulator:**
   - Pixel 5 API 30 (recommended)
   - Less demanding than newer versions

3. **Close other apps:**
   - Free up system resources
   - Close unnecessary programs

## 🚀 Quick Recovery Steps

**Do this right now:**

```bash
# 1. Kill everything
taskkill /F /IM qemu-system-x86_64.exe /T
adb kill-server

# 2. Wait 5 seconds

# 3. Start ADB
adb start-server

# 4. Launch emulator from Android Studio AVD Manager

# 5. Wait for emulator home screen

# 6. Check connection
adb devices

# 7. Run Flutter
cd C:\Users\Hp\Desktop\BMS\bms
flutter run
```

## ⚠️ If Still Failing

### Check if emulator is actually running:

```bash
adb devices
```

**Expected output:**
```
List of devices attached
emulator-5554    device
```

**If empty, emulator isn't running - start it!**

### Force specific device:

```bash
flutter run -d emulator-5554
```

### Or let Flutter choose:

```bash
flutter run
# Then select device from the list
```

## 🎯 Best Practice

**Always check devices before running:**

```bash
flutter devices
flutter run
```

## 📱 Alternative: Use Chrome for Testing

During development, you can use Chrome:

```bash
flutter run -d chrome
```

This is faster for UI testing (but won't test native Android features).

## 🔄 Current Situation

Your app is built and ready! You just need to:
1. ✅ Make sure emulator is running
2. ✅ Run `flutter run` again

The code changes (decreased photo size) are already saved and ready to hot reload once you reconnect!

---

**Quick Command to Run Now:**

```bash
adb devices
# Check if emulator shows up

# If not, restart emulator from Android Studio

# Once emulator is ready:
flutter run
```

Your app will launch with the updated smaller person image! 🎉
