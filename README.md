# TXT Search API

## Ejecutar

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
```

## Endpoint principal

`GET /?palabra=python`

Busca la palabra en todos los `.txt` dentro de `txt_files/` y devuelve los nombres de archivos que la contienen.
