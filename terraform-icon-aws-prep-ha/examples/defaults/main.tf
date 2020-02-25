resource "random_pet" "this" {
  length = 2
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b"]
  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"]
  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"]

  enable_nat_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "this" {
  vpc_id = module.vpc.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 7100
    to_port = 7100
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 5404
    to_port = 5404
    protocol = "udp"
    description = "Corosync sync port"
    self = true
  }

  ingress {
    from_port = 5406
    to_port = 5406
    protocol = "udp"
    description = "Corosync sync port"
    self = true
  }
}

resource "aws_eip" "this" {}

module "defaults" {
  source = "../.."

  eip_id = aws_eip.this.id

  private_key_path = var.private_key_path
  public_key_path = var.public_key_path
  security_group_id_1 = aws_security_group.this.id
  subnet_id_1 = module.vpc.public_subnets[0]
  subnet_id_2 = module.vpc.public_subnets[1]
} 