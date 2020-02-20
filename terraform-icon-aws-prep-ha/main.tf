resource "random_pet" "this" {}

locals {
  security_group_id_2 = var.security_group_id_2 == "" ? var.security_group_id_1 : var.security_group_id_2
}

module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

//module "packer" {
//  source = "github.com/insight-infrastructure/terraform-aws-packer-ami.git?ref=master"
//
//}

module "ec2_a" {
  source = "github.com/insight-infrastructure/terraform-aws-ec2-basic.git?ref=master"

  name = var.node_name

  monitoring = var.monitoring
  create_eip = var.create_eip

  ebs_volume_size  = var.ebs_volume_size
  root_volume_size = var.root_volume_size

  instance_type = var.instance_type
  volume_path   = var.volume_path

  subnet_id              = var.subnet_id_1
  vpc_security_group_ids = [var.security_group_id_1]

  user_data        = ""
  local_public_key = var.public_key_path

  tags = module.label.tags
}

resource "aws_eip_association" "ec2_a" {
  instance_id = module.ec2_a.instance_id
  allocation_id = var.eip_id
}

module "ec2_b" {
  source = "github.com/insight-infrastructure/terraform-aws-ec2-basic.git?ref=master"

  name = var.node_name

  monitoring = var.monitoring
  create_eip = var.create_eip

  ebs_volume_size  = var.ebs_volume_size
  root_volume_size = var.root_volume_size

  instance_type = var.instance_type
  volume_path   = var.volume_path

  subnet_id              = var.subnet_id_2
  vpc_security_group_ids = [local.security_group_id_2]

  user_data        = ""
  local_public_key = var.public_key_path

  tags = module.label.tags
}

module "ansible" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=master"

  inventory_template = "${path.module}/ansible/ansible_inventory.tpl"

  inventory_template_vars = {
    ec2_a_ip   = module.ec2_a.public_ip
    ec2_a_vars = <<-EOT
    stuff = "things"
EOT
    ec2_b_ip   = module.ec2_b.public_ip
    ec2_b_vars = <<-EOT
    stuff = "things"
EOT
  }

  playbook_file_path = "${path.module}/ansible/playbook.yml"
  user               = "ubuntu"
  private_key_path   = var.private_key_path
}