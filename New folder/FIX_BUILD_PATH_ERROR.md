# Fix: Build Path Error

## Error
`The system cannot find the path specified` for build\app\intermediates directory

## Root Cause
The build directory has become corrupted or has permission issues.

## SOLUTION: Complete Clean Build

Run these commands in order:

```powershell
cd C:\Users\Hp\Desktop\BMS\bms

# Step 1: Stop any running processes
flutter clean

# Step 2: Delete build folders manually
Remove-Item -Recurse -Force .\build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .\android\build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .\android\app\build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .\.dart_tool -ErrorAction SilentlyContinue

# Step 3: Get dependencies fresh
flutter pub get

# Step 4: Build fresh
flutter run
```

## Alternative: If PowerShell commands don't work

### Method 1: Manual Deletion
1. Close Android Studio / VS Code / any IDE
2. Close any running emulators
3. Manually delete these folders:
   - `C:\Users\Hp\Desktop\BMS\bms\build`
   - `C:\Users\Hp\Desktop\BMS\bms\android\build`
   - `C:\Users\Hp\Desktop\BMS\bms\android\app\build`
   - `C:\Users\Hp\Desktop\BMS\bms\.dart_tool`
4. Run:
   ```bash
   flutter pub get
   flutter run
   ```

### Method 2: Use Git Clean (if you have git)
```bash
git clean -xfd
flutter pub get
flutter run
```

### Method 3: Check Permissions
1. Right-click on the `BMS\bms` folder
2. Properties → Security
3. Make sure your user has "Full Control"
4. Apply to all subfolders

### Method 4: Run as Administrator
1. Open PowerShell as Administrator
2. Navigate to project:
   ```bash
   cd C:\Users\Hp\Desktop\BMS\bms
   ```
3. Run clean commands:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## If Still Failing

### Check for Long Path Issues
Windows has a 260 character path limit. Your path might be too long:

1. **Enable Long Paths in Windows:**
   - Open Registry Editor (Win + R, type `regedit`)
   - Navigate to: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem`
   - Set `LongPathsEnabled` to `1`
   - Restart computer

2. **Or move project closer to root:**
   ```bash
   # Move project to shorter path
   move C:\Users\Hp\Desktop\BMS C:\BMS
   cd C:\BMS\bms
   flutter clean
   flutter run
   ```

## Quick Nuclear Option 🚀

If nothing else works, create a fresh build:

```bash
# Navigate to parent directory
cd C:\Users\Hp\Desktop\BMS

# Rename old project
Rename-Item bms bms_old

# Create fresh flutter project
flutter create bms

# Copy your lib folder
Copy-Item bms_old\lib\* bms\lib\ -Recurse -Force

# Copy assets
Copy-Item bms_old\assets bms\ -Recurse -Force

# Copy pubspec.yaml
Copy-Item bms_old\pubspec.yaml bms\pubspec.yaml -Force

# Copy android configs (if customized)
Copy-Item bms_old\android\app\build.gradle bms\android\app\build.gradle -Force

# Navigate to new project
cd bms

# Run
flutter pub get
flutter run
```

## Most Common Solution ✅

This usually works:

```bash
flutter clean
Remove-Item -Recurse -Force .\build
flutter pub get
flutter run
```

Try this first!
