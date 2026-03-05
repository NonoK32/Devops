# Terraform Bootstrap (Hetzner Cloud)

Este stack crea una base para desplegar la app en Hetzner Cloud:
- 1 red privada (`hcloud_network`)
- 1 subnet privada (`hcloud_network_subnet`)
- 1 firewall (SSH `22` + app `8000`)
- 1 servidor (`hcloud_server`) con IP publica y privada
- 1 SSH key importada desde tu equipo

## Requisitos

- Terraform `>= 1.5`
- Token de Hetzner Cloud API
- Clave SSH publica local

## Uso

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
export TF_VAR_hcloud_token="TU_TOKEN_HETZNER"
terraform init
terraform plan
terraform apply
```

Al finalizar, Terraform te mostrara la IP publica del servidor en los outputs.

## Destruir recursos

```bash
terraform destroy
```
