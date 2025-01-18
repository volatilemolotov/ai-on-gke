data "google_client_config" "default" {}


data "google_project" "project" {
  project_id = var.project_id
}

module "gke_cluster" {
  source = "../../../../infrastructure"
  count  = var.create_cluster ? 1 : 0

  project_id        = var.project_id
  cluster_name      = var.cluster_name
  cluster_location  = var.cluster_location
  autopilot_cluster = true
  private_cluster   = var.private_cluster
  create_network    = false
  network_name      = "default"
  subnetwork_name   = "default" 
  enable_gpu        = true
  #gpu_pools         = var.gpu_pools
  ray_addon_enabled = false
}

data "google_container_cluster" "existing_cluster" {
  count    = var.create_cluster ? 0 : 1
  name     = var.cluster_name
  location = var.cluster_location
}

locals {
  cluster_info = var.create_cluster ? {
    endpoint        = module.gke_cluster[0].endpoint
    ca_certificate  = module.gke_cluster[0].ca_certificate
    private_cluster = var.private_cluster
    } : {
    endpoint        = data.google_container_cluster.existing_cluster[0].endpoint
    ca_certificate  = data.google_container_cluster.existing_cluster[0].master_auth[0].cluster_ca_certificate
    private_cluster = data.google_container_cluster.existing_cluster[0].private_cluster_config.0.enable_private_endpoint
  }
}

locals {
  ca_certificate        = base64decode(local.cluster_info.ca_certificate)
  private_cluster       = local.cluster_info.private_cluster
  cluster_membership_id = var.cluster_membership_id == "" ? var.cluster_name : var.cluster_membership_id
  host                  = local.private_cluster ? "https://connectgateway.googleapis.com/v1/projects/${data.google_project.project.number}/locations/${var.cluster_location}/gkeMemberships/${local.cluster_membership_id}" : "https://${local.cluster_info.endpoint}"

}

provider "kubernetes" {
  alias                  = "llamaindex"
  host                   = local.host
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = local.private_cluster ? "" : local.ca_certificate
  dynamic "exec" {
    for_each = local.private_cluster ? [1] : []
    content {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}


resource "google_storage_bucket" "datastore_bucket" {
  project = var.project_id
  name = "akamalov-llamaindex-test"

  location      = "US"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  force_destroy               = true
}

module "llamaindex_workload_identity" {
  providers = {
    kubernetes = kubernetes.llamaindex
  }
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                            = "llamaindex-rag-sa"
  #automount_service_account_token = true
  namespace                       = "default"
  roles                           = ["roles/storage.objectUser"]
  project_id                      = var.project_id
}



resource "google_artifact_registry_repository" "image_repo" {
  project = var.project_id
  location      = "us"
  repository_id = "akamalov-llamaindex-test"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository_iam_binding" "binding" {
  project    = var.project_id
  location   = "us"
  repository = "akamalov-llamaindex-test"
  role       = "roles/artifactregistry.reader"
  members = [
    "serviceAccount:${module.gke_cluster[0].service_account}",
  ]
  depends_on = ["google_artifact_registry_repository.image_repo", module.gke_cluster]
}
