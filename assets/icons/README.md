# Icon Replacement Guide

## How to Replace Placeholder Icons with Figma Icons

### Step 1: Export Icons from Figma
1. Open your Figma design
2. For each icon below, select it in Figma
3. Right-click → Export → SVG
4. Save to the corresponding file path

### Icons to Replace:

#### 1. Search Icon
- **Figma Selection**: Select the search icon in the header
- **Save to**: `C:\Users\Hp\Desktop\BMS\bms\assets\icons\search_icon.svg`
- **Current**: Placeholder search icon

#### 2. Notification/Bell Icon  
- **Figma Selection**: Select the "outline/bell-alert" icon
- **Save to**: `C:\Users\Hp\Desktop\BMS\bms\assets\icons\notification_icon.svg`
- **Current**: Placeholder notification with red dot

#### 3. Message Icon
- **Figma Selection**: Select the "mingcute:message-3-line" icon
- **Save to**: `C:\Users\Hp\Desktop\BMS\bms\assets\icons\message_icon.svg`
- **Current**: Placeholder envelope icon

#### 4. Location Pin Icon
- **Figma Selection**: Select the "outline/map-pin" icon  
- **Save to**: `C:\Users\Hp\Desktop\BMS\bms\assets\icons\location_icon.svg`
- **Current**: Placeholder location pin

#### 5. User/Profile Icon
- **Figma Selection**: Select the "outline/user-circle" icon
- **Save to**: `C:\Users\Hp\Desktop\BMS\bms\assets\icons\user_circle_icon.svg`
- **Current**: Placeholder user circle (Note: This might be replaced by the yellow circle in the design)

### Step 2: Run Flutter Commands
After replacing the SVG files, run:
```bash
flutter pub get
flutter run
```

### Notes:
- All placeholder SVGs are white and will use the colorFilter to match your design
- The icons are sized correctly (20x20 for header icons, 12x12 for location)
- If you want to keep the yellow profile circle from the design, we can update that separately
