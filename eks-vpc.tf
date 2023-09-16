resource "aws_vpc" "kthamel-eks-vpc" {
  cidr_block = "172.32.0.0/16"

  tags = local.common_tags
}
