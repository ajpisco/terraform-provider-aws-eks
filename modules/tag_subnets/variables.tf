variable "subnets_id" {
  type        = list(string)
  description = "List of subnets to be tagged"
}

variable "tag_prefix" {
  type        = string
  description = "Tag prefix"
  default     = ""
}

variable "tag_key" {
  type        = string
  description = "Tag key"
  default     = ""
}

variable "tag_value" {
  type        = string
  description = "Tag value"
  default     = ""
}