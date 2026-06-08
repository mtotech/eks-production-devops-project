resource "aws_eks_cluster" "eks" { # create eks cluster

  name = "eks-production"

  version = "1.33"

  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {

    subnet_ids = concat(

      aws_subnet.public[*].id,
      aws_subnet.private[*].id

    )

    endpoint_private_access = true

    endpoint_public_access = true

    public_access_cidrs = [
      "0.0.0.0/0"
    ]

    security_group_ids = [
      aws_security_group.eks_cluster.id
    ]

  }

  enabled_cluster_log_types = [

    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"

  ]

  depends_on = [

    aws_iam_role_policy_attachment.eks_cluster_policy

  ]

  tags = {

    Name = "eks-production"

  }

}

# Data Source for OIDC

data "tls_certificate" "eks" {

  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer

}

# Create OIDC Provider

resource "aws_iam_openid_connect_provider" "eks" {

  client_id_list = [

    "sts.amazonaws.com"

  ]

  thumbprint_list = [

    data.tls_certificate.eks.certificates[0].sha1_fingerprint

  ]

  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer

}

