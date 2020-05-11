variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "keyname" {
  default = "jenkins-master-slave"
}
variable "vpc_jenkins" {
  default = "vpc-0811b47f12823fddd"
}

variable "fe_target_group_name" {
  default = "frontend-target-group"
}

variable "vpc_gateway_id" {
  default = "igw-0df2f630179ae60bb"
}

variable "fe_instance_names"{
  default = {
    "0" = "Swarm-FrontEnd-Manager"
    "1" = "Swarm-FrontEnd-Worker-1"
    "2" = "Swarm-FrontEnd-Worker-2"
  }
}

variable "be_instance_names"{
  default = {
    "0" = "Swarm-BackEnd-Manager"
    "1" = "Swarm-BackEnd-Worker-1"
    "2" = "Swarm-BackEnd-Worker-2"
  }
}