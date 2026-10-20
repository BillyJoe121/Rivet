"""Exporta un nodo de Figma a PNG usando la API REST.

El token se lee SIEMPRE de la variable de entorno FIGMA_TOKEN (nunca se
guarda en archivos).

Uso:
    FIGMA_TOKEN=... python -I tools/visual/figma_export.py <node_id> <salida.png> [escala]

Ejemplo:
    python -I tools/visual/figma_export.py 12:345 build/visual/figma/welcome.png 2
"""
import json
import os
import sys
import urllib.parse
import urllib.request

FILE_KEY = "43n3WC3GWNJZSPOCNRGzVT"


def main(argv):
    if len(argv) < 3:
        sys.exit(__doc__)
    token = os.environ.get("FIGMA_TOKEN")
    if not token:
        sys.exit("Define la variable de entorno FIGMA_TOKEN.")
    node_id, out = argv[1], argv[2]
    scale = argv[3] if len(argv) > 3 else "2"
    query = urllib.parse.urlencode(
        {"ids": node_id, "format": "png", "scale": scale})
    req = urllib.request.Request(
        f"https://api.figma.com/v1/images/{FILE_KEY}?{query}",
        headers={"X-Figma-Token": token})
    with urllib.request.urlopen(req, timeout=60) as resp:
        data = json.load(resp)
    if data.get("err"):
        sys.exit(f"Error de Figma: {data['err']}")
    url = data["images"].get(node_id)
    if not url:
        sys.exit(f"Figma no devolvió imagen para {node_id}: {data}")
    os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
    with urllib.request.urlopen(url, timeout=120) as resp, open(out, "wb") as f:
        f.write(resp.read())
    print(f"Guardado: {out}")


if __name__ == "__main__":
    main(sys.argv)
