resource "kubernetes_service" "videoprocessor_service" {
  metadata {
    name      = "videoprocessor-service"
    namespace = "athena-tc5"
  }

  spec {
    selector = {
      app = "athena-videoprocessor"
    }

    port {
      protocol    = "TCP"
      port        = 8000
      target_port = 8000
    }

    type = "ClusterIP"
  }

  depends_on = [
    kubernetes_namespace.athena_ns,
    kubectl_manifest.videoprocessor_deployment
  ]
}
