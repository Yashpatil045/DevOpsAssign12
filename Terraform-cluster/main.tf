
# Terraform-cluster/main.tf

resource "aws_key_pair" "yashKey" {
  key_name   = "yash-devops-key"
  public_key = file("${path.module}/yash-devops-key.pem.pub")
}

data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "cluster_sg" {
  name        = "cluster-sg"
  description = "Allow SSH, HTTP, Jenkins, Swarm and Database traffic"
  vpc_id      = data.aws_vpc.default.id

  # SSH access (restricted to your IP)
  ingress {
    description = "SSH/Ansible Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # Jenkins UI - restricted to your IP (default var.my_ip_cidr)
  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  # HTTP - allow public so you can reach app (change to var.my_ip_cidr for restricted access)
  ingress {
    description = "HTTP (App Frontend)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Postgres internal (only allow from other instances in same SG)
  ingress {
    description = "Postgres internal (SG self)"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    self        = true
  }

  # Django development/internal port (only allow from same SG)
  ingress {
    description = "Django internal (SG self)"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    self        = true
  }

  # Docker Swarm control plane (2377) - required for swarm join
  ingress {
    description = "Swarm control plane"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Swarm node communication (TCP)
  ingress {
    description = "Swarm node comms TCP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Swarm overlay network (UDP)
  ingress {
    description = "Swarm overlay (UDP)"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------
# Spot Instances via aws_instance + instance_market_options
# -------------------------

resource "aws_instance" "yash_controller" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.yashKey.key_name
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]

  instance_market_options {
    market_type = "spot"

    spot_options {

      max_price = var.spot_max_price
      spot_instance_type = "one-time"
    }
  }

  

  tags = {
    Name = "Yash-Controller"
    Owner = "Yash-Patil"
    Project = "DevOps-Assignment-A751"
  }
}

resource "aws_instance" "yash_swarm_manager" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.yashKey.key_name
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price = var.spot_max_price
      spot_instance_type = "one-time"
    }
  }


  tags = {
    Name = "Yash-Swarm-Manager"
    Owner = "Yash-Patil"
    Project = "DevOps-Assignment-A751"
  }
}

resource "aws_instance" "yash_worker1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.yashKey.key_name
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price = var.spot_max_price
      spot_instance_type = "one-time"
    }
  }


  tags = {
    Name = "Yash-Worker-1"
    Owner = "Yash-Patil"
    Project = "DevOps-Assignment-A751"
  }
}

resource "aws_instance" "yash_worker2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.yashKey.key_name
  vpc_security_group_ids = [aws_security_group.cluster_sg.id]

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price = var.spot_max_price
      spot_instance_type = "one-time"
    }
  }


  tags = {
    Name = "Yash-Worker-2"
    Owner = "Yash-Patil"
    Project = "DevOps-Assignment-A751"
  }
}

