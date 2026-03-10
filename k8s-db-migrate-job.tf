resource "kubectl_manifest" "db_migrate_job" {
  depends_on = [
    kubernetes_namespace.athena_ns,
    kubectl_manifest.secrets,
    kubectl_manifest.configmap
  ]

  yaml_body = yamlencode({
    apiVersion = "batch/v1"
    kind       = "Job"
    metadata = {
      name      = "db-migrate-seed-job"
      namespace = "athena-tc5"
    }
    spec = {
      template = {
        spec = {
          initContainers = [
            {
              name            = "create-db-if-missing"
              image           = "postgres:16-alpine"
              imagePullPolicy = "IfNotPresent"
              command = [
                "sh",
                "-c",
                "PGPASSWORD=\"$DB_PASSWORD\" psql -h \"$DB_HOST\" -p \"$DB_PORT\" -U \"$DB_USER\" -d postgres -tc \"SELECT 1 FROM pg_database WHERE datname='$DB_NAME'\" | grep -q 1 || PGPASSWORD=\"$DB_PASSWORD\" psql -h \"$DB_HOST\" -p \"$DB_PORT\" -U \"$DB_USER\" -d postgres -c \"CREATE DATABASE \\\"$DB_NAME\\\";\""
              ]
              envFrom = [
                {
                  secretRef = {
                    name = "api-secrets"
                  }
                }
              ]
            }
          ]
          containers = [
            {
              name            = "migrate-db"
              image           = "dianabianca/tc5-athena:latest"
              imagePullPolicy = "IfNotPresent"
              command = [
                "sh",
                "-c",
                "npx prisma migrate deploy && (command -v ts-node >/dev/null 2>&1 && npx prisma db seed || echo 'ts-node not found, skipping seed')"
              ]
              envFrom = [
                {
                  configMapRef = {
                    name = "api-configmap"
                  }
                },
                {
                  secretRef = {
                    name = "api-secrets"
                  }
                }
              ]
              resources = {
                requests = {
                  memory = "256Mi"
                  cpu    = "100m"
                }
                limits = {
                  memory = "512Mi"
                  cpu    = "200m"
                }
              }
            }
          ]
          restartPolicy = "Never"
        }
      }
      backoffLimit = 4
    }
  })
}
