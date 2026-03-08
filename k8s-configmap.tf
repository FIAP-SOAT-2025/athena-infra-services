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
  CORS_ORIGINS: "*"
  CORS_ALLOWED_ORIGINS: "*"
  CORS_ALLOWED_METHODS: "GET,POST,PUT,DELETE,PATCH,OPTIONS"
  CORS_ALLOWED_HEADERS: "Content-Type,Authorization"
  CORS_ALLOW_CREDENTIALS: "true"
  NODE_TLS_REJECT_UNAUTHORIZED: "0"
  REDIS_HOST: "redis-service.athena-tc5.svc.cluster.local"
  REDIS_PORT: "6379"
  AWS_REGION: "us-east-1"
  AWS_S3_BUCKET: "${var.videos_bucket_name}"

YAML
}