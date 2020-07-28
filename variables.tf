variable "env" {
}

variable "name" {
  default = "cloud9"
}

variable "app_name" {
  type = string
}


variable "environment" {
  type = map(string)
  default = {}
}

variable "secret_names" {
  type = list(string)
  default = []
}

//variable "ecs_cluster" {
//  type = string
//}

variable "docker_image_name" {
  type = string
  default = "linuxserver/cloud9"
}

variable "docker_image_tag" {
  type = string
  default = "latest"
}

variable "ecs_launch_type" {

}

variable "cloudwatch_log_group" {
  default = ""
}

variable "docker_container_port" {
  default = 8000
}

variable "ecs_network_mode" {
}

variable "resource_requirements" {
  default = []
}

variable "enabled" {
  default = true
}
