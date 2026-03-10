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

## Jenkins (paralelo)

Hay un pipeline paralelo en [Jenkinsfile](/Users/nono/Documents/Nono/DevopsCap/Jenkinsfile)

Requisitos:
- Jenkins con plugin Pipeline y acceso a `docker`.
- Variables de entorno en Jenkins (`GHCR_USER`, `GHCR_TOKEN`)
- Variable `SONAR_TOKEN` en Jenkins si quieres analisis con SonarQube.

Ejecuta el pipeline desde la misma rama o mediante Multibranch.

Notas:
- En ramas distintas de `main`, construye imagen pero no hace push (siempre configurable).
- En `main`, si están definidas `GHCR_USER` y `GHCR_TOKEN`, hace login y push de:
  - `ghcr.io/nonok32/devops:latest`
  - `ghcr.io/nonok32/devops:sha-<commit>`

Arranque local con Docker Compose:

```bash
docker compose up -d --build
docker compose logs -f jenkins
```

SonarQube quedara disponible en:

```bash
http://localhost:9000
```

Credenciales iniciales de SonarQube:
- user: `admin`
- pass: `admin` (te pedira cambio de password al primer login)

Para usar analisis en Jenkins:
1. Entra en SonarQube y crea un token de usuario.
2. En Jenkins define `SONAR_TOKEN` como variable de entorno del job.
3. Ejecuta el pipeline; el stage `SonarQube analysis (optional)` se activara.

Password inicial de Jenkins:

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Parar Jenkins:

```bash
docker compose down
```

## Endpoint principal

`GET /?palabra=python`

Busca la palabra en todos los `.txt` dentro de `txt_files/` y devuelve un booleano indicando si la encontró y en caso afirmativo, tambien devuelve los nombres de archivos que la contienen.
