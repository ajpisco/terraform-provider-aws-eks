locals {
  cluster_name = "sample"

  tag_prefix_k8s = "kubernetes.io/cluster/"
  tag_key_k8s    = local.cluster_name
  tag_value_k8s  = "shared"
}

module "sample_tag_subnets" {
  source = "./modules/tag_subnets"

  subnets_id = var.node_group_subnets_id
  tag_prefix = local.tag_prefix_k8s
  tag_key    = local.tag_key_k8s
  tag_value  = local.tag_value_k8s
}

module "sample_eks" {
  source = "./modules/eks"

  cluster_name          = "sample-${local.cluster_name}"
  subnets_id            = var.subnets_id
  node_group_subnets_id = var.node_group_subnets_id
}

module "detailed_eks" {
  source = "./modules/eks"

  cluster_name          = "detailed-${local.cluster_name}"
  subnets_id            = var.subnets_id
  node_group_subnets_id = var.node_group_subnets_id

  tags = {
    "tag1" = "detailed"
  }

  # Security Group variables
  vpc_id = var.vpc_id
  security_group_config = [
    {
      "type"        = "ingress"
      "description" = "Rule 1"
      "from_port"   = "443"
      "to_port"     = "443"
      "protocol"    = "tcp"
      "cidr_blocks" = ["10.0.0.0/20"]
      # "prefix_list_ids" = ""
      # "self" = ""
      # "security_groups" = ""
    },
    {
      "type"        = "ingress"
      "description" = "Rule 2"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "cidr_blocks" = ["10.0.0.0/20"]
      # "prefix_list_ids" = ""
      # "self" = ""
      # "security_groups" = ""
    },
    {
      "type"        = "egress"
      "description" = "Rule 3"
      "from_port"   = "0"
      "to_port"     = "0"
      "protocol"    = "-1"
      "cidr_blocks" = ["0.0.0.0/0"]
      # "prefix_list_ids" = ""
      # "self" = ""
      # "security_groups" = ""
    }
  ]

  # Cluster variables
  vpc_config = {
    "endpoint_private_access" = false
    "endpoint_public_access"  = true
    "public_access_cidrs"     = ["0.0.0.0/0"]
    # "security_group_ids" = []
  }
  enabled_cluster_log_types = ["api", "audit"]
  cluster_version           = "1.24"
  # encryption_config = {
  #   "key_arn"   = "arn:aws:kms:eu-west-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  #   "resources" = ["secrets"]
  # }
  kubernetes_network_config = {
    service_ipv4_cidr = "172.20.0.0/16"
    ip_family         = "ipv4"
  }
  # outpost_config = {
  #   "control_plane_instance_type" = "m5d.large"
  #   "outpost_arns" = ["arn:aws:outposts:eu-west-1:123456789012:outpost/op-0ab23c4567EXAMPLE"]
  #   "placement_group_name" = "sample-placement-group"
  # }

  # Node group variables
  scaling_config_desired_size = 1
  scaling_config_max_size     = 2
  scaling_config_min_size     = 1
  update_config = {
    # "max_unavailable" = 0
    "max_unavailable_percentage" = 50
  }
  ami_type             = "AL2_x86_64"
  capacity_type        = "ON_DEMAND"
  disk_size            = 20
  force_update_version = null
  instance_types       = ["t3.medium"]
  labels = {
    "label1" = "detailed"
  }
  release_version    = "1.24.10-20230217"
  node_group_version = null
  # launch_template = {
  #   "id" = "lt-1"
  #   # "name" = "launch-template1"
  #   "version" = "1"
  # }
}