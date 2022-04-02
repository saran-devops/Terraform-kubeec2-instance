provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "cluster_sg_group_traffic" {
  name        = "Allow traffic to jenkins server"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"
  vpc_id      = data.aws_vpc.selected.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Kubernetes-cluster-sg" = "true"
  }
}

resource "aws_instance" "k8s_master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.cluster_sg_group_traffic.id]
  subnet_id              = tolist(data.aws_subnets.default_subnets.ids)[0]
  key_name               = "ubuntukey"
  count                  = 1
  tags = {
    "Name" = "master"
  }
}

resource "aws_instance" "k8s_slave" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.cluster_sg_group_traffic.id]
  subnet_id              = tolist(data.aws_subnets.default_subnets.ids)[1]
  key_name               = "ubuntukey"
  count                  = 2
  tags = {
    "Name" = "slave"
  }
}
