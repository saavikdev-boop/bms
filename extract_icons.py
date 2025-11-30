import base64
import re
import os
import shutil

# Directory containing icon files
icons_dir = r"C:\Users\Hp\Desktop\BMS\bms\assets\images\3d_icons"

svg_files = ['nearby_players.svg', 'host_game.svg', 'bookings.svg', 'shop.svg']

for svg_file in svg_files:
    svg_path = os.path.join(icons_dir, svg_file)
    png_path = svg_path.replace('.svg', '.png')
    
    print(f"Processing {svg_file}...")
    
    try:
        # First, try to read as binary to check if it's already a PNG
        with open(svg_path, 'rb') as f:
            first_bytes = f.read(8)
        
        # PNG files start with these bytes: 89 50 4E 47 0D 0A 1A 0A
        if first_bytes[:4] == b'\x89PNG':
            # It's already a PNG file, just copy it
            shutil.copy(svg_path, png_path)
            print(f"✓ File was already PNG, copied to {png_path}")
            continue
        
        # It's a real SVG, try to extract base64 PNG
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
            
            print(f"✓ Extracted PNG from SVG: {png_path}")
        else:
            print(f"✗ No base64 PNG found in {svg_file}")
    
    except Exception as e:
        print(f"✗ Error processing {svg_file}: {e}")

print("\n✅ Done! PNG files ready in assets/images/3d_icons/")
print("Now run: flutter run -d emulator-5554")
