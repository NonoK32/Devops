# TXT Search API

[![CI](https://github.com/NonoK32/Devops/actions/workflows/ci.yml/badge.svg)](https://github.com/NonoK32/Devops/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/NonoK32/Devops/graph/badge.svg?token=E9G47GBGTZ)](https://codecov.io/gh/NonoK32/Devops)

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

## Hook pre-push

Para ejecutar tests automaticamente antes de cada `git push`:

```bash
sh scripts/setup-hooks.sh
```

Esto activa el hook versionado en `.githooks/pre-push`.

## Docker

```bash
docker build -t devopscap-api:local .
docker run --rm -p 8000:8000 devopscap-api:local
```

Publicacion automatica en GHCR desde CI:
- En `push` a `main`: `ghcr.io/nonok32/devops:latest` y `ghcr.io/nonok32/devops:sha-<commit>`
- En tags tipo `v1.0.0`: `ghcr.io/nonok32/devops:v1.0.0`

Ejemplo de pull:

```bash
docker pull ghcr.io/nonok32/devops:latest
```

## Terraform

Bootstrap inicial en `infra/terraform` para crear red y servidor base en Hetzner Cloud.

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
export TF_VAR_hcloud_token="TU_TOKEN_HETZNER"
terraform init
terraform plan
terraform apply
```

## Endpoint principal

`GET /?palabra=python`

Busca la palabra en todos los `.txt` dentro de `txt_files/` y devuelve un booleano indicando si la encontró y en caso afirmativo, tambien devuelve los nombres de archivos que la contienen.
