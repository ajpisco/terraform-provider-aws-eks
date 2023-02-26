data "aws_subnet" "tags" {
  count = length(var.subnets_id)
  id    = var.subnets_id[count.index]
}