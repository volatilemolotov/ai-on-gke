output "gke_cluster_name" {
  value       = local.cluster_name
  description = "GKE cluster name"
}

output "gke_cluster_location" {
  value       = var.cluster_location
  description = "GKE cluster location"
}

output "project_id" {
  value       = var.project_id
  description = "GKE cluster location"
}

output "bucket_name" {
  value       = var.gcs_bucket
  description = "Name of the GCS bucket that will store the model files"
}

output "service_account" {
  value       = data.google_service_account.gke_service_account.email
  description = "Service Account for the GKE cluster"
}

output "cloudsql_ip" {
  value       = google_sql_database_instance.flyte_storage.private_ip_address
  description = "Ip of cloudsql"
}

output "cloudsql_user" {
  value       = var.cloudsql_user
  description = "Username for the cloudsql database"
}

output "cloudsql_password" {
  sensitive   = true
  value       = random_password.db_password.result
  description = "Password for the Cloud SQL database"
}
