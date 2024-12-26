resource "google_storage_bucket" "metaflow_datastore_bucket" {
 name          = var.metaflow_datastore_bucket_name

 location      = "US"
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
 force_destroy = true
}
