########
# Label
########
variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = ""
}

######
# Data
######
//variable "vpc_id" {
//  description = "The vpc id of the subnet"
//  type        = string
//  default     = ""
//}

variable "eip_id" {
  description = "The elastic ip id to attach to active instance"
  type = string
}

variable "subnet_id_1" {
  description = "The id of the first subnet."
  type        = string
}

variable "subnet_id_2" {
  description = "The id of the second subnet."
  type        = string
}

variable "security_group_id_1" {
  description = "The id of the security group to run in"
  type        = string
}

variable "security_group_id_2" {
  description = "The id of the security group to run in"
  type        = string
  default = ""
}

#####
# ec2
#####
variable "node_name" {
  description = "Name of the node"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "Boolean for cloudwatch"
  type        = bool
  default     = false
}

variable "create_eip" {
  description = "Boolean to create elastic IP"
  type        = bool
  default     = false
}

variable "ebs_volume_size" {
  description = "EBS volume size"
  type        = string
  default     = 0
}

variable "root_volume_size" {
  description = "Root volume size"
  type        = string
  default     = 0
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "volume_path" {
  description = "Volume path"
  type        = string
  default     = "/dev/xvdf"
}

variable "public_key_path" {
  description = "The path to the public ssh key"
  type        = string
  default     = ""
}

variable "private_key_path" {
  description = "The path to the private ssh key"
  type        = string
  default     = ""
}

#########
# Ansible
#########
//variable "private_key_path" {
//  description = "Path to the private ssh key"
//  type        = string
//  default     = ""
//}
//
//variable "playbook_file_path" {
//  description = "The path to the playbook"
//  type        = string
//  default     = ""
//}
//
//variable "user" {
//  description = "The user for configuring node with ansible"
//  type        = string
//  default     = "ubuntu"
//}



