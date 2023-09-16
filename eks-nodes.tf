resource "aws_iam_role" "kthamel-eks-nodes-iam-role" {
  name = "kthamel-eks-nodes-iam-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17"
    Statement : [
      {
        "Sid" : "Statement1",
        "Action" : "sts:AssumeRole"
        "Effect" : "Allow",
        "Principal" : {
          "service" : "ec2.amazonaws.com"
        },
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "kthamel-eks-node-iam-role-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.kthamel-eks-nodes-iam-role.name
}

resource "aws_iam_role_policy_attachment" "kthamel-eks-ecr-iam-role-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPolicy"
  role       = aws_iam_role.kthamel-eks-nodes-iam-role.name
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.kthamel-eks-cluster.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.kthamel-eks-nodes-iam-role.arn

  subnet_ids = "${aws_subnet.kthamel-eks-subnet-.*.id}"
  # subnet_ids = [
  #   aws_subnet.kthamel-eks-subnet-1,
  #   aws_subnet.kthamel-eks-subnet-2,
  #   aws_subnet.kthamel-eks-subnet-3
  # ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.micro"]
  scaling_config {
    desired_size = 1
    min_size     = 0
    max_size     = 2
  }
  update_config {
    max_unavailable = 1
  }
  labels = {
    node_type = "workers"
  }
}
