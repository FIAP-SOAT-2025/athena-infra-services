
resource "time_sleep" "wait_for_lb" {
  create_duration = "60s"
  depends_on      = [kubernetes_service.api_service]
}

data "aws_lb" "api_lb" {
  tags = {
    "kubernetes.io/service-name" = "athena-tc5/api-service"
  }
  depends_on = [time_sleep.wait_for_lb]
}

data "aws_lb_listener" "api_listener" {
  load_balancer_arn = data.aws_lb.api_lb.arn
  port              = 80
}

data "terraform_remote_state" "db" {
  count   = var.use_db_remote_state ? 1 : 0
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.projectName}/db/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "infra" {
  count   = var.use_infra_remote_state ? 1 : 0
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket_name
    key    = "${var.projectName}/infra/terraform.tfstate"
    region = var.aws_region
  }
}

locals {
  db_host = var.use_db_remote_state ? data.terraform_remote_state.db[0].outputs.db_instance_address : "${var.db_service_name}.${var.db_namespace}.svc.cluster.local"
  db_port = var.use_db_remote_state ? data.terraform_remote_state.db[0].outputs.db_instance_port : var.db_port
}