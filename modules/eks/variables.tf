variable "cluster_name" {
  type = string
}

variable "subnets_id" {
  type        = list(string)
  description = "List of subnets to be used by EKS"
}

variable "vpc_config" {
  default     = {}
  description = "VPC configuration for the EKS resources"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = null
  description = "List of the desired control plane logging to enable"
}

variable "cluster_version" {
  description = "Desired Kubernetes master version"
  type        = string
  default     = null
}

variable "encryption_config" {
  default     = {}
  description = "Cluster encryption configuration"

  validation {
    condition = !(
      (lookup(var.encryption_config, "key_arn", null) != null && lookup(var.encryption_config, "resources", null) == null) ||
      (lookup(var.encryption_config, "key_arn", null) == null && lookup(var.encryption_config, "resources", null) != null)
    )
    error_message = "The attributes encryption_config.key_arn and encryption_config.resources are required"
  }
}

variable "kubernetes_network_config" {
  type        = map(string)
  default     = {}
  description = "Configuration block with kubernetes network configuration for the cluster"
}

variable "outpost_config" {
  default     = {}
  description = "Configuration block representing the configuration of your local Amazon EKS cluster on an AWS Outpost"

  validation {
    condition     = !(length(var.outpost_config) > 0 && (lookup(var.outpost_config, "control_plane_instance_type", null) == null || lookup(var.outpost_config, "outpost_arns", null) == null))
    error_message = "The attributes outpost_config.control_plane_instance_type and outpost_config.outpost_arns are required"
  }
}

variable "scaling_config_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "scaling_config_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "scaling_config_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "update_config" {
  description = "Desired max number or percentage of unavailable worker nodes during node group update"
  type        = map(number)
  default = {
    "max_unavailable_percentage" = 50
  }

  validation {
    condition = (
      (lookup(var.update_config, "max_unavailable", null) != null && lookup(var.update_config, "max_unavailable_percentage", null) == null) ||
      (lookup(var.update_config, "max_unavailable", null) == null && lookup(var.update_config, "max_unavailable_percentage", null) != null)
    )
    error_message = "The attributes update_config.max_unavailable and update_config.max_unavailable_percentage are mutually exclusive"
  }
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
  default     = null
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
  type        = string
  default     = null
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = null
}

variable "force_update_version" {
  description = "Force version update if existing pods are unable to be drained due to a pod disruption budget issue"
  type        = bool
  default     = null
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = null
}

variable "labels" {
  description = "Key-value map of Kubernetes labels"
  type        = map(string)
  default     = null
}

variable "launch_template" {
  description = "EC2 Launch Template details"
  type        = map(string)
  default     = {}

  validation {
    condition = !(
      (lookup(var.launch_template, "id", null) != null && lookup(var.launch_template, "name", null) != null)
    )
    error_message = "The attributes launch_template.id and launch_template.name are mutually exclusive"
  }

  validation {
    condition     = !(length(var.launch_template) > 0 && lookup(var.launch_template, "version", null) == null)
    error_message = "The attribute launch_template.version is required to set the launch_template"
  }
}

variable "release_version" {
  description = "AMI version of the EKS Node Group"
  type        = string
  default     = null
}

variable "remote_access" {
  description = "Configuration for the remote access. Has 2 attributes: ec2_ssh_key and source_security_group_ids"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(any)
  default     = null
}

variable "taint" {
  description = "The taint configuration whose keys are: key, value and effect"
  type        = map(string)
  default     = {}

  validation {
    condition = !(
      (lookup(var.taint, "key", null) != null && lookup(var.taint, "effect", null) == null) ||
      (lookup(var.taint, "key", null) == null && lookup(var.taint, "effect", null) != null)
    )
    error_message = "The attributes taint.key and taint.effect are required for setting kubernetes taints"
  }
}

variable "node_group_version" {
  description = "Node group kubernetes version"
  type        = string
  default     = null
}