variable "project_name" {
  description = "Project name used in resource names"
  type        = string
  default     = "devops-api"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Hetzner datacenter location (e.g. fsn1, nbg1, hel1)"
  type        = string
  default     = "nbg1"
}

variable "server_type" {
  description = "Hetzner server type"
  type        = string
  default     = "cx22"
}

variable "image" {
  description = "Server image"
  type        = string
  default     = "ubuntu-24.04"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used to access the server"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "network_cidr" {
  description = "CIDR block for Hetzner private network"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for Hetzner private subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "subnet_zone" {
  description = "Hetzner network zone"
  type        = string
  default     = "eu-central"
}

variable "server_private_ip" {
  description = "Private IP address for the server inside the Hetzner network"
  type        = string
  default     = "10.10.1.10"
}

variable "app_image" {
  description = "Docker image to run on first boot"
  type        = string
  default     = "ghcr.io/nonok32/devops:latest"
}

variable "app_container_name" {
  description = "Container name for the deployed app"
  type        = string
  default     = "devops-api"
}

variable "app_port" {
  description = "Container port exposed by the app"
  type        = number
  default     = 8000
}

variable "host_port" {
  description = "Host port to map for the app"
  type        = number
  default     = 8000
}
