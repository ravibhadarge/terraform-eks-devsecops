output "node_role_arn" {
  value = aws_iam_role.node.arn
}

output "node_role_name" {
  value = aws_iam_role.node.name
}

output "node_group_arn" {
  value = aws_eks_node_group.general.arn
}
