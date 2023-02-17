resource "aws_ecs_cluster" "selleraxis_ecs" {
  name = "${var.ecs_cluster_name}-${var.environment_name}"
}
