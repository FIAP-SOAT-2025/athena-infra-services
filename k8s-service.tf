resource "kubernetes_service" "api_service" {
  metadata {
    name      = "api-service"
    namespace = "athena-tc5"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }
  spec {
    selector = {
      app = "athena-api"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
  depends_on = [kubernetes_namespace.athena_ns]
}