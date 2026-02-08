resource "kubectl_manifest" "configmap" {
  depends_on = [kubernetes_namespace.athena_ns]
  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: api-configmap
  namespace: athena-tc5
data:
  API_BASE_URL: "https://api.mercadopago.com/v1/payments"
  NODE_TLS_REJECT_UNAUTHORIZED: "0"

YAML
}