#!/usr/bin/env python3
"""Generate a crimson phone icon matching the app palette."""

from math import cos, sin, radians
from pathlib import Path

from PIL import Image, ImageDraw

SIZE = 1024
BG = (155, 28, 46, 255)
WHITE = (255, 255, 255, 255)


def main() -> None:
    image = Image.new("RGBA", (SIZE, SIZE), BG)
    draw = ImageDraw.Draw(image)
    # White circular badge
    pad = 150
    draw.ellipse([pad, pad, SIZE - pad, SIZE - pad], fill=WHITE)
    # Crimson handset
    color = BG
    draw.rounded_rectangle([390, 250, 634, 774], radius=90, fill=color)
    draw.ellipse([230, 300, 470, 540], fill=color)
    draw.ellipse([554, 484, 794, 724], fill=color)
    # Cut the middle to leave a handset look
    draw.ellipse([430, 390, 594, 634], fill=WHITE)

    root = Path(__file__).resolve().parents[1]
    icons = root / "assets" / "icons"
    icons.mkdir(parents=True, exist_ok=True)
    image.save(icons / "app_icon.png")
    print(f"Wrote {icons / 'app_icon.png'}")


if __name__ == "__main__":
    main()
