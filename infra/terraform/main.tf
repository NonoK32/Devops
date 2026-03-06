locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "hcloud_network" "main" {
  name     = "${local.name_prefix}-network"
  ip_range = var.network_cidr
}

resource "hcloud_network_subnet" "main" {
  network_id   = hcloud_network.main.id
  type         = "cloud"
  network_zone = var.subnet_zone
  ip_range     = var.subnet_cidr
}

resource "hcloud_firewall" "app" {
  name = "${local.name_prefix}-firewall"

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "8000"
    source_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    protocol        = "tcp"
    port            = "1-65535"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    protocol        = "udp"
    port            = "1-65535"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }

  rule {
    direction       = "out"
    protocol        = "icmp"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
}

resource "hcloud_ssh_key" "default" {
  name       = "${local.name_prefix}-ssh-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "hcloud_server" "app" {
  name        = "${local.name_prefix}-server"
  image       = var.image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  firewall_ids = [
    hcloud_firewall.app.id
  ]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  user_data = <<-EOF
#!/bin/sh
set -eux

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y ca-certificates curl

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

docker pull ${var.app_image}
docker rm -f ${var.app_container_name} || true
docker run -d \
  --name ${var.app_container_name} \
  --restart unless-stopped \
  -p ${var.host_port}:${var.app_port} \
  ${var.app_image}
EOF
}

resource "hcloud_server_network" "app_private_network" {
  server_id  = hcloud_server.app.id
  network_id = hcloud_network.main.id
  ip         = var.server_private_ip
}
