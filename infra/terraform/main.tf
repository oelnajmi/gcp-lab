# We will add resources in the next step:
# - Artifact Registry (Docker repo)
# - GKE Autopilot cluster
# - App namespace
# - (later) Helm releases for backend/frontend
# ---------- Network for GKE ----------
resource "google_compute_network" "gke_vpc" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-subnet"
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
  network       = google_compute_network.gke_vpc.id

  # Required by VPC-native GKE
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.20.0.0/14" # room for many pods
  }
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.30.0.0/20" # room for services
  }
}

# ---------- GKE Autopilot Cluster ----------
resource "google_container_cluster" "gke" {
  name       = "gke-dev"
  location   = var.region # regional (e.g., us-central1)
  network    = google_compute_network.gke_vpc.id
  subnetwork = google_compute_subnetwork.gke_subnet.id

  # VPC-native mode using our secondary ranges
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  enable_autopilot = true

  # Autopilot mode (serverless nodes)
  # autopilot {}

  # (Optional but recommended) use a release channel
  release_channel {
    channel = "REGULAR"
  }

  # Handy: enable Gateway API (off by default)
  # gateway_api_config {
  #   channel = "CHANNEL_STANDARD"
  # }

  # Let Google manage logging/monitoring defaults.
  logging_config {
    enable_components = ["WORKLOADS", "SYSTEM_COMPONENTS", "APISERVER"]
  }
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }

  lifecycle {
    prevent_destroy = false
  }
}

# ---------- Artifact Registry (Docker repo) ----------
resource "google_artifact_registry_repository" "apps" {
  location      = var.region
  repository_id = "apps"
  description   = "Docker images for gcp-lab frontend/backend"
  format        = "DOCKER"
}
