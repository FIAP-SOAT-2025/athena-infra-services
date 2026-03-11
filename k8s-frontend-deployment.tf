resource "kubectl_manifest" "frontend_deployment" {
  depends_on = [
    kubernetes_namespace.athena_ns,
    kubectl_manifest.frontend_configmap
  ]

  yaml_body = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: athena-frontend
  namespace: athena-tc5
spec:
  replicas: 1
  selector:
    matchLabels:
      app: athena-frontend
  template:
    metadata:
      labels:
        app: athena-frontend
    spec:
      containers:
      - name: frontend
        image: dianabianca/tc5-athena-frontend:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 80
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        envFrom:
        - configMapRef:
            name: frontend-configmap
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "250m"

YAML
}