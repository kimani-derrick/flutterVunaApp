from PIL import Image

# Define the desired sizes
sizes = {
    "xxxhdpi": (640, 640),
    "xxhdpi": (480, 480),
    "xhdpi": (320, 320),
    "hdpi": (240, 240),
    "mdpi": (160, 160)
}

# Path to your original logo
logo_path = "logo.png"  # Replace with the actual path to your logo file

# Open the original image
try:
    image = Image.open(logo_path)
except FileNotFoundError:
    print(f"Error: The file {logo_path} was not found.")
    exit(1)

# Resize the image for each size and save
for label, size in sizes.items():
    resized_image = image.resize(size, Image.Resampling.LANCZOS)
    resized_image.save(f"{label}_{size[0]}x{size[1]}.png")
    print(f"Saved: {label}_{size[0]}x{size[1]}.png")

print("All resized images have been saved successfully.")

