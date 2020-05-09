variable "access_key" {

}
variable "secret_key" {
  
}
variable "region" {
  default = "us-east-1"
}
variable "keyname" {
  default = "jenkins-master-slave"
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