resource "kubectl_manifest" "frontend_configmap" {
  depends_on = [
    kubernetes_namespace.athena_ns,
    kubernetes_service.api_service
  ]

  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: frontend-configmap
  namespace: athena-tc5
data:
  VITE_API_URL: "http://${kubernetes_service.api_service.status[0].load_balancer[0].ingress[0].hostname}"

YAML
}