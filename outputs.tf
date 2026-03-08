output "api_service_name" {
  description = "Nome do service da API"
  value       = "api-service"
}

output "api_namespace" {
  description = "Namespace da API"
  value       = "athena-tc5"
}


output "athena_api_listener_arn" {
  description = "The ARN of the NLB Listener for the Athena API service."
  value       = data.aws_lb_listener.api_listener.arn
}

output "api_load_balancer_hostname" {
  description = "The public hostname of the API's Network Load Balancer."
  value       = kubernetes_service.api_service.status[0].load_balancer[0].ingress[0].hostname
}

output "frontend_service_name" {
  description = "Nome do service do frontend"
  value       = kubernetes_service.frontend_service.metadata[0].name
}

output "frontend_load_balancer_hostname" {
  description = "The public hostname of the frontend Network Load Balancer."
  value       = kubernetes_service.frontend_service.status[0].load_balancer[0].ingress[0].hostname
}

output "frontend_url" {
  description = "URL publica completa do frontend."
  value       = "http://${kubernetes_service.frontend_service.status[0].load_balancer[0].ingress[0].hostname}:8080"
}

output "videoprocessor_service_name" {
  description = "Nome do service do videoprocessor"
  value       = kubernetes_service.videoprocessor_service.metadata[0].name
}

output "videoprocessor_internal_url" {
  description = "URL interna do videoprocessor no cluster"
  value       = "http://${kubernetes_service.videoprocessor_service.metadata[0].name}.athena-tc5.svc.cluster.local:8000"
}

output "videoprocessor_load_balancer_hostname" {
  description = "Hostname publico do NLB do videoprocessor"
  value       = try(kubernetes_service.videoprocessor_service.status[0].load_balancer[0].ingress[0].hostname, null)
}

output "videoprocessor_monitoring_url" {
  description = "URL publica de monitoramento do videoprocessor"
  value       = try("http://${kubernetes_service.videoprocessor_service.status[0].load_balancer[0].ingress[0].hostname}/metrics", null)
}