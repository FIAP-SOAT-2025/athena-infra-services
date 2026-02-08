resource "kubernetes_service" "api_service" {
  metadata {
    name      = "api-service"
    namespace = "lanchonete-tc2"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }
  spec {
    selector = {
      app = "lanchonete-api"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
  depends_on = [kubernetes_namespace.lanchonete_ns]
}