provider "google" {
  project = var.project_id
}

module "gke-cluster" {
  source  = "../../../infrastructure"
  project_id        = var.project_id
  cluster_name      = var.cluster_name
  cluster_location  = "us-central1"
  private_cluster   = false
  autopilot_cluster = false
  create_network    = false
  network_name      = "default"
  subnetwork_name   = "default"
  enable_gpu        = true
  grant_registry_access = true
  gpu_pools = [
    {
      name               = "gpu-pool-a100"
      machine_type       = "a2-highgpu-1g"
      node_locations     = "us-central1-a" ## comment to autofill node_location based on cluster_location
      autoscaling        = true
      min_count          = 1
      max_count          = 3
      disk_size_gb       = 100
      disk_type          = "pd-balanced"
      enable_gcfs        = true
      logging_variant    = "DEFAULT"
      accelerator_count  = 1
      accelerator_type   = "nvidia-tesla-a100"
      gpu_driver_version = "DEFAULT"
    }
  ]
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "local_file" "metaflow_config_file" {
  content = templatefile("${path.root}/templates/metaflow_config.json", {
    metaflow_datastore_bucket         = var.metaflow_datastore_bucket_name
    kubernetes_service_account_name   = var.metaflow_google_service_account
    project_id                        = var.project_id
  })
  filename = "${path.root}/metaflow_config.json"
}
