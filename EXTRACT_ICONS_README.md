# Extract PNG from SVG Files

Your SVG files contain embedded PNG images as base64 data. That's why they're not displaying properly with flutter_svg.

## Quick Fix: Run This Python Script

1. **Save this script** as `extract_icons.py` in your BMS folder
2. **Run it**: `python extract_icons.py`
3. **Hot reload** your app

```python
import base64
import re
import os

# Directory containing SVG files
svg_dir = r"C:\Users\Hp\Desktop\BMS\bms\assets\images\3d_icons"

svg_files = ['nearby_players.svg', 'host_game.svg', 'bookings.svg', 'shop.svg']

for svg_file in svg_files:
    svg_path = os.path.join(svg_dir, svg_file)
    png_path = svg_path.replace('.svg', '.png')
    
    print(f"Processing {svg_file}...")
    
    try:
        # Read SVG file
        with open(svg_path, 'r', encoding='utf-8') as f:
            svg_content = f.read()
        
        # Find base64 PNG data
        match = re.search(r'data:image/png;base64,([^"]+)', svg_content)
        
        if match:
            base64_data = match.group(1)
            
            # Decode base64 to PNG
            png_data = base64.b64decode(base64_data)
            
            # Write PNG file
            with open(png_path, 'wb') as f:
                f.write(png_data)
            
            print(f"✓ Extracted {png_path}")
        else:
            print(f"✗ No base64 PNG found in {svg_file}")
    
    except Exception as e:
        print(f"✗ Error processing {svg_file}: {e}")

print("\nDone! PNG files created.")
```

## What This Does:
- Reads each SVG file
- Extracts the embedded PNG data (base64 encoded)
- Saves as proper PNG files
- Creates: `nearby_players.png`, `host_game.png`, `bookings.png`, `shop.png`

## Then:
```bash
flutter run -d emulator-5554
```

The icons will now load perfectly! ✅
