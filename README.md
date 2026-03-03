# TXT Search API

[![CI](https://github.com/NonoK32/Devops/actions/workflows/ci.yml/badge.svg)](https://github.com/NonoK32/Devops/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/NonoK32/Devops/branch/main/graph/badge.svg)](https://codecov.io/gh/NonoK32/Devops)

## Ejecutar

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
```

## Tests y cobertura

```bash
source .venv/bin/activate
pip install -r requirements.txt
pytest --cov=main --cov-config=.coveragerc --cov-report=term-missing
```

Nota: si el repo es privado, configura `CODECOV_TOKEN` en `Settings > Secrets and variables > Actions`.

## Hook pre-push

Para ejecutar tests automaticamente antes de cada `git push`:

```bash
sh scripts/setup-hooks.sh
```

Esto activa el hook versionado en `.githooks/pre-push`.

## Endpoint principal

`GET /?palabra=python`

Busca la palabra en todos los `.txt` dentro de `txt_files/` y devuelve los nombres de archivos que la contienen.
