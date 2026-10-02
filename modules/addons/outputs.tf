output "aws_load_balancer_controller_status" {
  value = var.enable_aws_load_balancer_controller ? helm_release.aws_load_balancer_controller[0].status : "disabled"
}


