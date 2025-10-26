# Terraform-cluster/variable.tf

variable "aws_region" {
    description = "AWS Region"
    type        = string
    default     = "us-east-1" # Set to match provider.tf or vice versa
}

variable "instance_type" {
    description = "Controller Instance Type (using t2.medium as requested)"
    type        = string
    default     = "t2.medium"
}



variable "my_ip_cidr" {
  description = "Your IP/CIDR for SSH access (e.g. 1.2.3.4/32). Default 0.0.0.0/0 (less secure)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "jenkins_admin_user" {
  description = "Jenkins admin user (created by postinstall script)"
  type        = string
  default     = "admin"
}

variable "jenkins_admin_pass" {
  description = "Jenkins admin password (initial) - change in prod"
  type        = string
  default     = "Admin@123"
}

variable "spot_max_price" {
  description = "Maximum hourly price to pay for the Spot Instance (e.g. 0.05 is a safe bid for t2.medium)"
  type        = string
  default     = "0.05"
}