locals {
  videoprocessor_dashboard = jsondecode(file("${path.module}/monitoring/grafana-dashboard-videoprocessor.json")).dashboard
}

resource "kubectl_manifest" "monitoring_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
YAML
}

resource "kubernetes_config_map" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = "monitoring"
    labels = {
      grafana_datasource = "1"
    }
  }

  data = {
    "prometheus.yaml" = <<-YAML
      apiVersion: 1
      datasources:
        - name: Prometheus
          type: prometheus
          access: proxy
          url: http://prometheus-server.monitoring.svc.cluster.local
          isDefault: true
          editable: true
    YAML
  }

  depends_on = [kubectl_manifest.monitoring_namespace]
}

resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name      = "grafana-dashboards"
    namespace = "monitoring"
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "athena-videoprocessor-overview.json" = jsonencode(local.videoprocessor_dashboard)
  }

  depends_on = [kubectl_manifest.monitoring_namespace]
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "monitoring"
  create_namespace = false

  values = [yamlencode({
    alertmanager = {
      enabled = false
    }
    kube-state-metrics = {
      enabled = false
    }
    prometheus-node-exporter = {
      enabled = false
    }
    server = {
      service = {
        type = "ClusterIP"
      }
      global = {
        scrape_interval = "15s"
      }
      persistentVolume = {
        enabled = false
      }
    }
  })]

  depends_on = [kubectl_manifest.monitoring_namespace]
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = false

  values = [yamlencode({
    service = {
      type = "LoadBalancer"
      port = 80
    }
    adminPassword = var.grafana_admin_password
    persistence = {
      enabled = false
    }
    sidecar = {
      dashboards = {
        enabled         = true
        label           = "grafana_dashboard"
        searchNamespace = "ALL"
      }
      datasources = {
        enabled         = true
        label           = "grafana_datasource"
        searchNamespace = "ALL"
      }
    }
  })]

  depends_on = [
    kubectl_manifest.monitoring_namespace,
    helm_release.prometheus,
    kubernetes_config_map.grafana_datasources,
    kubernetes_config_map.grafana_dashboards
  ]
}
