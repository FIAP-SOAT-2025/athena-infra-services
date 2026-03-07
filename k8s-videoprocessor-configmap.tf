resource "kubectl_manifest" "videoprocessor_configmap" {
  depends_on = [kubernetes_namespace.athena_ns]
  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: videoprocessor-configmap
  namespace: athena-tc5
data:
  REDIS_HOST: "redis-service.athena-tc5.svc.cluster.local"
  REDIS_PORT: "6379"
  NODE_TLS_REJECT_UNAUTHORIZED: "0"
  AWS_REGION: "us-east-1"
  AWS_S3_BUCKET: "athena-videos-tc5-g192-v1"

YAML
}
