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
  description = "Subnets where EKS resources will be deployed"
}
