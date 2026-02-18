resource "kubernetes_namespace" "athena_ns" {
  metadata {
    name = "athena-tc5"
  }
}