terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40" # stable recent
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
  }
}

# Use Application Default Credentials (what you just set up)
provider "google" {
  project = var.project_id
  region  = var.region
}

# These two will work after cluster exists and kubeconfig is configured.
# We'll leave them declared for later Helm/K8s resources.
provider "kubernetes" {
  host                   = var.kube_host
  token                  = var.kube_token
  cluster_ca_certificate = var.kube_ca_cert
}

provider "helm" {
  kubernetes {
    host                   = var.kube_host
    token                  = var.kube_token
    cluster_ca_certificate = var.kube_ca_cert
  }
}
