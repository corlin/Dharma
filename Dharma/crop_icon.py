from PIL import Image, ImageChops, ImageStat
import sys

def crop_smart(image_path, output_path):
    img = Image.open(image_path).convert("RGB")
    
    # 1. Convert to grayscale for analysis
    gray = img.convert("L")
    
    # 2. Sample corners to find background intensity
    w, h = gray.size
    corners = [
        gray.getpixel((0,0)), gray.getpixel((w-1,0)),
        gray.getpixel((0,h-1)), gray.getpixel((w-1,h-1))
    ]
    bg_threshold = max(corners) + 15 # Tolerance
    
    # 3. Create binary mask of "Content" (pixels brighter than background)
    # 255 if content, 0 if background
    mask = gray.point(lambda p: 255 if p > bg_threshold else 0)
    
    # 4. Get bounding box of content
    bbox = mask.getbbox()
    
    if bbox:
        left, upper, right, lower = bbox
        
        # 5. Make bbox square (to preserve aspect ratio of the icon itself)
        width = right - left
        height = lower - upper
        side = max(width, height)
        
        # Center the square crop
        center_x = (left + right) // 2
        center_y = (upper + lower) // 2
        
        new_left = max(0, center_x - side // 2)
        new_upper = max(0, center_y - side // 2)
        new_right = min(w, center_x + side // 2)
        new_lower = min(h, center_y + side // 2)
        
        # 6. Crop
        cropped = img.crop((new_left, new_upper, new_right, new_lower))
        
        # 7. Resize to 1024x1024 standard
        final = cropped.resize((1024, 1024), Image.LANCZOS)
        final.save(output_path)
        print(f"Smart Cropped from {bbox} to ({new_left},{new_upper},{new_right},{new_lower}) and saved to {output_path}")
    else:
        # Fallback: Just crop 10% from edges if no distinct content found
        print("No distinct content found. Falling back to center crop.")
        margin = int(w * 0.1)
        cropped = img.crop((margin, margin, w-margin, h-margin))
        final = cropped.resize((1024, 1024), Image.LANCZOS)
        final.save(output_path)

if __name__ == "__main__":
    src = "/Users/corlin/.gemini/antigravity/brain/a5c50f10-97b0-4671-a7d9-363103d4eefc/app_icon_north_star_complex_1768897137822.png"
    dest = "/Users/corlin/2026/Dharma/Dharma/Assets.xcassets/AppIcon_FullBleed.png"
    crop_smart(src, dest)
