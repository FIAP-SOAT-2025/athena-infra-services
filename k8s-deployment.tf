resource "kubectl_manifest" "deployment" {
  depends_on = [
    kubernetes_namespace.athena_ns,
    kubectl_manifest.db_migrate_job,
    kubectl_manifest.secrets,
    kubectl_manifest.configmap
  ]
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: athena-api
  namespace: athena-tc5
spec:
  replicas: 1
  selector:
    matchLabels:
      app: athena-api
  template:
    metadata:
      labels:
        app: athena-api
    spec:
      containers:
      - name: api
        image: tlnob/tc2-g38:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 3000
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 15
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        envFrom:
        - configMapRef:
            name: api-configmap
        - secretRef:
            name: api-secrets
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"

YAML
}