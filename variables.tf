variable "region" {
  description = "Region where resources will be deployed"
  type        = string
}
variable "access_key" {
  default = ""
  type    = string
}
variable "secret_key" {
  default = ""
  type    = string
}

variable "subnets_id" {
  type        = list(string)
  description = "Subnets where EKS Cluster will be deployed"
}

variable "node_group_subnets_id" {
  type        = list(string)
  description = "Subnets where EKS Node group will be deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to be used by the Security Group"
  default     = ""
}
