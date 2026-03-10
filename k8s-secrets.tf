resource "kubectl_manifest" "secrets" {
  depends_on = [kubernetes_namespace.athena_ns]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: api-secrets
  namespace: athena-tc5
type: Opaque
data:
  DB_USER: ${base64encode(var.db_user)}
  DB_PASSWORD: ${base64encode(var.db_password)}
  DB_NAME: ${base64encode(var.db_name)}
  DB_HOST: ${base64encode(local.db_host)}
  DB_PORT: ${base64encode(tostring(local.db_port))}
  ACCESS_TOKEN: ${base64encode(var.access_token)}
  JWT_SECRET: ${base64encode(var.jwt_secret)}
  DATABASE_URL: ${base64encode("postgresql://${var.db_user}:${var.db_password}@${local.db_host}:${local.db_port}/${var.db_name}?schema=public")}
  AWS_ACCESS_KEY_ID: ${base64encode(var.aws_access_key_id)}
  AWS_SECRET_ACCESS_KEY: ${base64encode(var.aws_secret_access_key)}
  AWS_SESSION_TOKEN: ${base64encode(var.aws_session_token)}
YAML
}