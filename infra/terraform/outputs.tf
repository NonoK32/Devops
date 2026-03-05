output "network_id" {
  description = "Hetzner network ID"
  value       = hcloud_network.main.id
}

output "subnet_id" {
  description = "Hetzner subnet ID"
  value       = hcloud_network_subnet.main.id
}

output "server_id" {
  description = "Hetzner server ID"
  value       = hcloud_server.app.id
}

output "server_public_ipv4" {
  description = "Public IPv4 address of the server"
  value       = hcloud_server.app.ipv4_address
}

output "server_private_ip" {
  description = "Private IP address inside Hetzner network"
  value       = hcloud_server_network.app_private_network.ip
}
