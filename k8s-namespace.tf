resource "kubernetes_namespace" "lanchonete_ns" {
  metadata {
    name = "lanchonete-tc2"
  }
}