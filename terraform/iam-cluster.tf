resource "aws_iam_role" "eks_cluster_role" {

  name = "eks-cluster-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "eks.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

  tags = local.common_tags

}

#  Attach Cluster Policies

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {

  for_each = toset([

    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  ])

  role = aws_iam_role.eks_cluster_role.name

  policy_arn = each.value

}

