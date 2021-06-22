// ----------------------------------------------------------------------------
// Add the Terraform generated jx-requirements.yml to a configmap so it can be
// sync'd with the Git repository
//
// https://www.terraform.io/docs/providers/kubernetes/r/namespace.html
// ----------------------------------------------------------------------------
resource "kubernetes_config_map" "jenkins_x_requirements" {
  count = var.is_jx2 ? 0 : 1
  metadata {
    name      = "terraform-jx-requirements"
    namespace = "default"
  }
  data = {
    "jx-requirements.yml" = var.content
  }

  lifecycle {
    ignore_changes = [
      metadata,
      data
    ]
  }
}

// ----------------------------------------------------------------------------
// Create the necessary K8s namespaces that we will need to add the
// Service Accounts later
// ----------------------------------------------------------------------------
resource "kubernetes_namespace" "jx" {
  count = var.is_jx2 ? 1 : 0
  depends_on = [
    null_resource.kubeconfig
  ]
  metadata {
    name = "jx"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }
}

resource "kubernetes_namespace" "cert_manager" {
  count = var.is_jx2 ? 1 : 0
  depends_on = [
    null_resource.kubeconfig
  ]
  metadata {
    name = "cert-manager"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations,
    ]
  }
}
