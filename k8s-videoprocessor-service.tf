resource "kubernetes_service" "videoprocessor_service" {
  metadata {
    name      = "videoprocessor-service"
    namespace = "athena-tc5"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
    }
  }

  spec {
    selector = {
      app = "athena-videoprocessor"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 8000
    }

    type = "LoadBalancer"
  }

  depends_on = [
    kubernetes_namespace.athena_ns,
    kubectl_manifest.videoprocessor_deployment
  ]
}
