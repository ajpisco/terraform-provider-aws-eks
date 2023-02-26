resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = var.subnets_id
    endpoint_private_access = lookup(var.vpc_config, "endpoint_private_access", null)
    endpoint_public_access  = lookup(var.vpc_config, "endpoint_public_access", null)
    public_access_cidrs     = lookup(var.vpc_config, "public_access_cidrs", null)
    security_group_ids      = lookup(var.vpc_config, "security_group_ids", null)
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types
  tags                      = var.tags
  version                   = var.cluster_version

  dynamic "encryption_config" {
    for_each = length(var.encryption_config) > 0 ? [var.encryption_config] : []
    content {
      provider {
        key_arn = encryption_config.value.key_arn
      }
      resources = encryption_config.value.resources
    }
  }

  kubernetes_network_config {
    service_ipv4_cidr = lookup(var.kubernetes_network_config, "service_ipv4_cidr", null)
    ip_family         = lookup(var.kubernetes_network_config, "ip_family", null)
  }

  dynamic "outpost_config" {
    for_each = length(var.outpost_config) > 0 ? [var.outpost_config] : []
    content {
      control_plane_instance_type = outpost_config.value.control_plane_instance_type
      outpost_arns                = outpost_config.value.outpost_arns

      control_plane_placement {
        group_name = outpost_config.value.placement_group_name
      }
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "main" {
  cluster_name           = aws_eks_cluster.main.name
  node_group_name_prefix = var.cluster_name
  node_role_arn          = aws_iam_role.nodegroup.arn
  subnet_ids             = var.subnets_id

  scaling_config {
    desired_size = var.scaling_config_desired_size
    max_size     = var.scaling_config_max_size
    min_size     = var.scaling_config_min_size
  }

  update_config {
    max_unavailable            = lookup(var.update_config, "max_unavailable", null)
    max_unavailable_percentage = lookup(var.update_config, "max_unavailable_percentage", null)
  }

  ami_type             = var.ami_type
  capacity_type        = var.capacity_type
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = var.instance_types
  labels               = var.labels
  release_version      = var.release_version
  tags                 = var.tags
  version              = var.node_group_version

  dynamic "launch_template" {
    for_each = length(var.launch_template) > 0 ? [var.launch_template] : []
    content {
      id      = try(launch_template.value.id, null)
      name    = try(launch_template.value.name, null)
      version = launch_template.value.version
    }
  }

  dynamic "remote_access" {
    for_each = length(var.remote_access) > 0 ? [var.remote_access] : []
    content {
      ec2_ssh_key               = remote_access.value.ec2_ssh_key
      source_security_group_ids = remote_access.value.source_security_group_ids
    }
  }

  dynamic "taint" {
    for_each = length(var.taint) > 0 ? [var.taint] : []
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodegroup-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodegroup-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodegroup-AmazonEC2ContainerRegistryReadOnly,
  ]
}