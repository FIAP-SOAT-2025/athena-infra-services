resource "kubernetes_service" "frontend_service" {
  metadata {
    name      = "frontend-service"
    namespace = "athena-tc5"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }

  spec {
    selector = {
      app = "athena-frontend"
    }

    port {
      protocol    = "TCP"
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }

  depends_on = [
    kubernetes_namespace.athena_ns,
    kubectl_manifest.frontend_deployment
  ]
}