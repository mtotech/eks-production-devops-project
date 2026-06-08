# phase 7: Create Managed Node Group

resource "aws_eks_node_group" "workers" {

  cluster_name = aws_eks_cluster.eks.name

  node_group_name = "production-workers"

  node_role_arn = aws_iam_role.eks_node_role.arn

  subnet_ids = aws_subnet.private[*].id

  capacity_type = "ON_DEMAND"

  instance_types = [
    "t3.medium"
  ]

  ami_type = "AL2023_x86_64_STANDARD"

  disk_size = 20

  scaling_config {

    desired_size = 2

    min_size = 2

    max_size = 4

  }

  update_config {

    max_unavailable = 1

  }

  labels = {

    environment = "production"

    nodegroup = "workers"

  }

  lifecycle {

    create_before_destroy = true

  }

  depends_on = [

    aws_iam_role_policy_attachment.worker_policies,

    aws_eks_cluster.eks

  ]

  tags = {

    Name = "production-workers"

  }

}

