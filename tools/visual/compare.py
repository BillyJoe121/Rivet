"""Compara un PNG exportado de Figma con el PNG renderizado por las pruebas.

Genera una sola imagen con tres paneles: Figma | Flutter | Diferencia
(la diferencia se amplifica para que los desajustes pequeños se vean) e
imprime métricas simples.

Uso (desde la raíz del proyecto):
    python -I tools/visual/compare.py <figma.png> <render.png> [salida.png]

Si solo cambia la escala (1x contra 2x) el render se escala; si cambia la
proporción, ambos se alinean arriba a la izquierda sobre fondo magenta.
La salida por defecto es build/visual/compare/<nombre_render>.png.
"""
import os
import sys

try:
    from PIL import Image, ImageChops, ImageDraw
except ImportError:  # pragma: no cover
    sys.exit("Pillow no está instalado: python -m pip install pillow")

LABEL_H = 28
GAP = 12
AMPLIFY = 4


def _flatten(img, bg=(255, 255, 255)):
    img = img.convert("RGBA")
    base = Image.new("RGBA", img.size, bg + (255,))
    base.alpha_composite(img)
    return base.convert("RGB")


def _pad(img, size, fill=(255, 0, 255)):
    canvas = Image.new("RGB", size, fill)
    canvas.paste(img, (0, 0))
    return canvas


def main(argv):
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    if len(argv) < 3:
        sys.exit(__doc__)
    figma_path, render_path = argv[1], argv[2]
    out = argv[3] if len(argv) > 3 else os.path.join(
        "build", "visual", "compare", os.path.basename(render_path))

    figma = _flatten(Image.open(figma_path))
    render = _flatten(Image.open(render_path))
    if render.size != figma.size:
        fx = figma.size[0] / render.size[0]
        fy = figma.size[1] / render.size[1]
        if abs(fx - fy) < 0.01:
            # Misma proporción (p. ej. 1x contra 2x): se escala.
            print(f"Aviso: escala distinta figma={figma.size} "
                  f"render={render.size}; se escala el render x{fx:.2f}.")
            render = render.resize(figma.size, Image.LANCZOS)
        else:
            # Proporciones distintas: ambos arriba a la izquierda, sin deformar.
            print(f"Aviso: tamaños distintos figma={figma.size} "
                  f"render={render.size}; se alinean arriba a la izquierda.")
            size = (max(figma.size[0], render.size[0]),
                    max(figma.size[1], render.size[1]))
            figma, render = (_pad(figma, size), _pad(render, size))

    diff = ImageChops.difference(figma, render)
    gray = diff.convert("L")
    hist = gray.histogram()
    total = figma.size[0] * figma.size[1]
    mean = sum(i * n for i, n in enumerate(hist)) / total
    over = sum(hist[24:]) / total * 100
    amplified = gray.point(lambda v: min(255, v * AMPLIFY))
    heat = Image.merge("RGB", (amplified, Image.new("L", gray.size, 0),
                               Image.new("L", gray.size, 0)))

    w, h = figma.size
    sheet = Image.new("RGB", (w * 3 + GAP * 2, h + LABEL_H), (40, 40, 40))
    draw = ImageDraw.Draw(sheet)
    for i, (title, img) in enumerate((("Figma", figma), ("Flutter", render),
                                      ("Diferencia x%d" % AMPLIFY, heat))):
        x = i * (w + GAP)
        sheet.paste(img, (x, LABEL_H))
        draw.text((x + 8, 8), title, fill=(255, 255, 255))

    os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
    sheet.save(out)
    print(f"Comparación: {out}")
    print(f"Diferencia media: {mean:.2f}/255; píxeles con diferencia > 24: "
          f"{over:.2f}%")


if __name__ == "__main__":
    main(sys.argv)
