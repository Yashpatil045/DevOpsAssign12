#Terraform-cluster/outputs.tf

output "controller_public_ip" {
  value       = aws_instance.yash_controller.public_ip
  description = "Yash Controller (spot) public IP"
}

output "swarm_manager_public_ip" {
  value       = aws_instance.yash_swarm_manager.public_ip
  description = "Yash Swarm manager (spot) public IP"
}

output "worker1_public_ip" {
  value       = aws_instance.yash_worker1.public_ip
  description = "Yash Worker1 (spot) public IP"
}

output "worker2_public_ip" {
  value       = aws_instance.yash_worker2.public_ip
  description = "Yash Worker2 (spot) public IP"
}
