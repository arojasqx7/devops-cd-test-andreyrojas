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
variable "instance_names"{
  default = {
    "0" = "Swarm-FE-1"
    "1" = "Swarm-FE-2"
    "2" = "Swarm-FE-3"
  }
}