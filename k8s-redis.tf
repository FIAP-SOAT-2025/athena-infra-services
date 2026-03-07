resource "kubectl_manifest" "redis_deployment" {
  depends_on = [kubernetes_namespace.athena_ns]
  yaml_body  = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
  namespace: athena-tc5
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:7-alpine
        ports:
        - containerPort: 6379
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"

YAML
}

resource "kubernetes_service" "redis_service" {
  metadata {
    name      = "redis-service"
    namespace = "athena-tc5"
  }
  spec {
    selector = {
      app = "redis"
    }
    port {
      protocol    = "TCP"
      port        = 6379
      target_port = 6379
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_namespace.athena_ns]
}
