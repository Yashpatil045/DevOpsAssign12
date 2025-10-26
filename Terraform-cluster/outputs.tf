#Terraform-cluster/outputs.tf

output "controller_public_ip" {
  value       = aws_instance.controller.public_ip
  description = "Controller (spot) public IP"
}

output "swarm_manager_public_ip" {
  value       = aws_instance.swarm_manager.public_ip
  description = "Swarm manager (spot) public IP"
}

output "worker1_public_ip" {
  value       = aws_instance.worker1.public_ip
  description = "Worker1 (spot) public IP"
}

output "worker2_public_ip" {
  value       = aws_instance.worker2.public_ip
  description = "Worker2 (spot) public IP"
}
