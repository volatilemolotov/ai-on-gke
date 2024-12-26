module "gke_workload_identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = var.metaflow_google_service_account
  namespace  = "default"
  roles      = ["roles/storage.objectUser"]
  project_id = var.project_id
  depends_on = [module.gke-cluster]
}
