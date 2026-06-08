output "vpc_id" {

  value = aws_vpc.main.id

}

output "public_subnets" {

  value = aws_subnet.public[*].id

}

output "private_subnets" {

  value = aws_subnet.private[*].id

}

output "security_group_id" {

  value = aws_security_group.eks_cluster.id

}

output "eks_cluster_role_arn" {

  value = aws_iam_role.eks_cluster_role.arn

}

output "eks_node_role_arn" {

  value = aws_iam_role.eks_node_role.arn

}

output "eks_cluster_name" {

  value = aws_eks_cluster.eks.name

}

output "eks_cluster_arn" {

  value = aws_eks_cluster.eks.arn

}

output "eks_endpoint" {

  value = aws_eks_cluster.eks.endpoint

}

output "oidc_provider_arn" {

  value = aws_iam_openid_connect_provider.eks.arn

}

# phase 7: output of node group name and node group arn

output "node_group_name" {

  value = aws_eks_node_group.workers.node_group_name

}

output "node_group_arn" {

  value = aws_eks_node_group.workers.arn

}

