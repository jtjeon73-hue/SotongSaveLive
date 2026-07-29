"""Generate SotongSaveLive brand icons: forest green, gold sun, ivory S-path."""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "tool" / "icon_assets"
WEB = ROOT / "web"
ICONS = WEB / "icons"
OUT.mkdir(parents=True, exist_ok=True)
ICONS.mkdir(parents=True, exist_ok=True)

FOREST = (31, 77, 58, 255)  # #1F4D3A
FOREST_DEEP = (24, 58, 44, 255)
GOLD = (212, 168, 75, 255)  # warm gold
GOLD_SOFT = (232, 198, 120, 255)
IVORY = (247, 243, 235, 255)
IVORY_SOFT = (255, 252, 245, 255)


def rounded_rect_mask(size: int, radius: float) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle((0, 0, size - 1, size - 1), radius=radius, fill=255)
    return mask


def s_path_points(cx: float, top: float, bottom: float, amp: float, steps: int = 80):
    pts = []
    for i in range(steps + 1):
        t = i / steps
        y = top + (bottom - top) * t
        # subtle S: sin with phase so it reads as path, not letter
        x = cx + amp * math.sin(t * math.pi * 1.15 - 0.15)
        pts.append((x, y))
    return pts


def draw_icon(size: int, *, maskable: bool = False) -> Image.Image:
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # safe zone for maskable: keep core in ~80% center
    pad = int(size * 0.12) if maskable else int(size * 0.04)
    inner = size - 2 * pad
    radius = inner * 0.22

    # background rounded square
    bg_box = [pad, pad, size - pad - 1, size - pad - 1]
    draw.rounded_rectangle(bg_box, radius=radius, fill=FOREST)

    # subtle vignette top (deeper green)
    for i in range(int(inner * 0.35)):
        alpha = int(40 * (1 - i / (inner * 0.35)))
        y = pad + i
        draw.line([(pad + 2, y), (size - pad - 3, y)], fill=(20, 48, 36, alpha))

    # sun
    sun_cx = size * 0.50
    sun_cy = pad + inner * 0.22
    sun_r = inner * 0.11
    # soft glow
    for k in range(6, 0, -1):
        gr = sun_r * (1 + k * 0.18)
        a = int(28 / k)
        draw.ellipse(
            [sun_cx - gr, sun_cy - gr, sun_cx + gr, sun_cy + gr],
            fill=(232, 198, 120, a),
        )
    draw.ellipse(
        [sun_cx - sun_r, sun_cy - sun_r, sun_cx + sun_r, sun_cy + sun_r],
        fill=GOLD,
    )
    # highlight
    hr = sun_r * 0.35
    draw.ellipse(
        [
            sun_cx - sun_r * 0.35 - hr,
            sun_cy - sun_r * 0.4 - hr,
            sun_cx - sun_r * 0.35 + hr,
            sun_cy - sun_r * 0.4 + hr,
        ],
        fill=GOLD_SOFT,
    )

    # path (subtle S)
    path_top = sun_cy + sun_r * 1.35
    path_bottom = pad + inner * 0.92
    amp = inner * 0.12
    pts = s_path_points(size * 0.50, path_top, path_bottom, amp, steps=100)
    # width tapers slightly
    base_w = max(2, int(inner * 0.085))
    for i in range(len(pts) - 1):
        t = i / (len(pts) - 1)
        w = base_w * (1.05 - 0.25 * t)
        x0, y0 = pts[i]
        x1, y1 = pts[i + 1]
        # draw thick segment as polygon approx via line with width
        draw.line([(x0, y0), (x1, y1)], fill=IVORY, width=max(2, int(w)))
        # soft edge
        draw.line([(x0, y0), (x1, y1)], fill=IVORY_SOFT, width=max(1, int(w * 0.55)))

    # soft horizon under sun
    hx0 = pad + inner * 0.18
    hx1 = pad + inner * 0.82
    hy = sun_cy + sun_r * 0.9
    draw.arc([hx0, hy - inner * 0.08, hx1, hy + inner * 0.08], 200, 340, fill=(47, 107, 82, 90), width=max(1, size // 128))

    if not maskable:
        mask = rounded_rect_mask(size, radius + pad * 0.1)
        # apply rounded corners to full canvas
        out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        out.paste(img, (0, 0))
        # clip with outer rounded rect matching full size slightly inset
        full_mask = Image.new("L", (size, size), 0)
        md = ImageDraw.Draw(full_mask)
        md.rounded_rectangle((0, 0, size - 1, size - 1), radius=size * 0.22, fill=255)
        out.putalpha(Image.composite(full_mask, Image.new("L", (size, size), 0), full_mask))
        # better: use alpha channel of img with rounded bg already
        return img

    return img


def save_png(img: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, format="PNG", optimize=True)
    print(f"wrote {path} {img.size} {path.stat().st_size} bytes")


def write_svg(path: Path) -> None:
    svg = '''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024" role="img" aria-label="SotongSaveLive icon">
  <defs>
    <radialGradient id="sunGlow" cx="50%" cy="28%" r="22%">
      <stop offset="0%" stop-color="#E8C678" stop-opacity="0.55"/>
      <stop offset="100%" stop-color="#E8C678" stop-opacity="0"/>
    </radialGradient>
    <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#2F6B52"/>
      <stop offset="100%" stop-color="#1F4D3A"/>
    </linearGradient>
  </defs>
  <rect x="0" y="0" width="1024" height="1024" rx="220" ry="220" fill="url(#bg)"/>
  <circle cx="512" cy="286" r="180" fill="url(#sunGlow)"/>
  <circle cx="512" cy="286" r="92" fill="#D4A84B"/>
  <circle cx="478" cy="258" r="28" fill="#E8C678" opacity="0.85"/>
  <path d="M 470 390 C 560 450, 560 520, 470 580 C 380 640, 380 720, 490 820 C 540 866, 560 900, 540 940"
        fill="none" stroke="#F7F3EB" stroke-width="78" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
'''
    path.write_text(svg, encoding="utf-8")
    print(f"wrote {path}")


def main() -> None:
    write_svg(OUT / "sotong_save_live_icon.svg")
    master = draw_icon(1024, maskable=False)
    save_png(master, OUT / "sotong_save_live_icon_1024.png")

    sizes = {
        WEB / "favicon.png": 48,
        WEB / "apple-touch-icon.png": 180,
        ICONS / "Icon-192.png": 192,
        ICONS / "Icon-512.png": 512,
    }
    for path, sz in sizes.items():
        save_png(draw_icon(sz, maskable=False), path)

    for path, sz in {
        ICONS / "Icon-maskable-192.png": 192,
        ICONS / "Icon-maskable-512.png": 512,
    }.items():
        save_png(draw_icon(sz, maskable=True), path)

    # verify PNG signatures
    for p in [
        WEB / "favicon.png",
        WEB / "apple-touch-icon.png",
        ICONS / "Icon-192.png",
        ICONS / "Icon-512.png",
        ICONS / "Icon-maskable-192.png",
        ICONS / "Icon-maskable-512.png",
        OUT / "sotong_save_live_icon_1024.png",
    ]:
        data = p.read_bytes()[:8]
        assert data.startswith(b"\x89PNG\r\n\x1a\n"), f"not png: {p}"
        im = Image.open(p)
        print(f"ok {p.name} {im.size} mode={im.mode}")


if __name__ == "__main__":
    main()
