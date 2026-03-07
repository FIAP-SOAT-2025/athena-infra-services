resource "kubectl_manifest" "videoprocessor_deployment" {
  depends_on = [
    kubernetes_namespace.athena_ns,
    kubectl_manifest.secrets,
    kubectl_manifest.videoprocessor_configmap,
    kubectl_manifest.redis_deployment
  ]
  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: athena-videoprocessor
  namespace: athena-tc5
spec:
  replicas: 1
  selector:
    matchLabels:
      app: athena-videoprocessor
  template:
    metadata:
      labels:
        app: athena-videoprocessor
    spec:
      containers:
      - name: videoprocessor
        image: dianabianca/tc5-athena-videoprocessor:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8000
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 15
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        envFrom:
        - configMapRef:
            name: videoprocessor-configmap
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
