from PIL import Image

sizes = {
    "xxxhdpi": (640, 640),
    "xxhdpi": (480, 480),
    "xhdpi": (320, 320),
    "hdpi": (240, 240),
    "mdpi": (160, 160)
}

logo_path = "logo.png"  # Path to your original logo
image = Image.open(logo_path)

for label, size in sizes.items():
    resized_image = image.resize(size, Image.ANTIALIAS)
    resized_image.save(f"{label}_{size[0]}x{size[1]}.png")

