output "cluster_name" {
  value = google_container_cluster.gke.name
}

output "cluster_location" {
  value = google_container_cluster.gke.location
}

output "network_self_link" {
  value = google_compute_network.gke_vpc.self_link
}

output "subnet_self_link" {
  value = google_compute_subnetwork.gke_subnet.self_link
}

output "artifact_registry_repo" {
  value = "us-central1-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.apps.repository_id}"
}
