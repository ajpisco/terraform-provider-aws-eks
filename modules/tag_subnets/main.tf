resource "aws_ec2_tag" "subnet_tag" {
  count       = length(data.aws_subnet.tags)
  resource_id = data.aws_subnet.tags[count.index].id
  key         = "${var.tag_prefix}${var.tag_key}"
  value       = var.tag_value
} 