terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      # Setting the provider version is a strongly recommended practice
      # version = "..."
    }
  }
  # Provider functions require Terraform 1.8 and later.
  required_version = ">= 1.8.0"
}

provider "google" {
  project = var.project_id
}


module "gke-cluster" {
  source  = "../../../../../infrastructure"
  project_id        = var.project_id
  cluster_name      = var.cluster_name
  cluster_location  = var.cluster_location
  autopilot_cluster = var.autopilot_cluster
  private_cluster   = var.private_cluster
  create_network    = false
  network_name      = "default"
  subnetwork_name   = "default"
  cpu_pools         = var.cpu_pools
  enable_gpu        = var.enable_gpu
  gpu_pools         = var.gpu_pools
  #   source  = "../../../../../infrastructure"
  #   project_id                              = var.project_id
  #   region                                  = var.region
  #   create_network                          = var.create_network
  #   network_name                            = var.network_name
  #   subnetwork_name                         = var.subnetwork_name
  #   subnetwork_cidr                         = var.subnetwork_cidr
  #   subnetwork_region                       = var.subnetwork_region
  #   subnetwork_private_access               = var.subnetwork_private_access
  #   subnetwork_description                  = var.subnetwork_description
  #   network_secondary_ranges                = var.network_secondary_ranges
  #   create_cluster                          = var.create_cluster
  #   private_cluster                         = var.private_cluster
  #   autopilot_cluster                       = var.autopilot_cluster
  #   cluster_regional                        = var.cluster_regional
  #   cluster_name                            = var.cluster_name
  #   cluster_labels                          = var.cluster_labels
  #   kubernetes_version                      = var.kubernetes_version
  #   release_channel                         = var.release_channel
  #   cluster_location                        = var.cluster_location
  #   ip_range_pods                           = var.ip_range_pods
  #   ip_range_services                       = var.ip_range_services
  #   monitoring_enable_managed_prometheus    = var.monitoring_enable_managed_prometheus
  #   gcs_fuse_csi_driver                     = var.gcs_fuse_csi_driver
  #   deletion_protection                     = var.deletion_protection
  #   ray_addon_enabled                       = var.ray_addon_enabled
  #   master_authorized_networks              = var.master_authorized_networks
  #   master_ipv4_cidr_block                  = var.master_ipv4_cidr_block
  #   all_node_pools_oauth_scopes             = var.all_node_pools_oauth_scopes
  #   all_node_pools_labels                   = var.all_node_pools_labels
  #   all_node_pools_metadata                 = var.all_node_pools_metadata
  #   all_node_pools_tags                     = var.all_node_pools_tags
  #   enable_tpu                              = var.enable_tpu
  #   enable_gpu                              = var.enable_gpu
  #   cpu_pools                               = var.cpu_pools
  #   gpu_pools                               = var.gpu_pools
  #   tpu_pools                               = var.tpu_pools
}

resource "google_storage_bucket" "metaflow_artifact_bucket" {
 name          = "akamalov-metaflow-artifact-store"

 location      = "US"
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
 force_destroy = true
}





# 
# resource "google_service_account_iam_binding" "metaflow_sa_bucket_role_binding" {
# }


# resource google_service_account "metaflow_kubernetes_workload_identity_service_account" {
#   provider     = google
#   account_id   = var.metaflow_workload_identity_gsa_name
#   display_name = "Service Account for Kubernetes Workload Identity (${terraform.workspace})"
#   # provisioner "local-exec" {
#   #   command = "echo 'Wait a bit for GSA to be ready' && sleep 10"
#   # }
# }


