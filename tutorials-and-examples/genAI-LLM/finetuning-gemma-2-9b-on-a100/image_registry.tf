resource "google_artifact_registry_repository" "finetune-repo" {
  location      = "us"
  repository_id = var.image_registry_name
  description   = "Image repository for gemma-2-9b finetuning tutorial"
  format        = "DOCKER"
}


resource "local_file" "cloudbuild_yaml" {
  content = templatefile("${path.root}/templates/cloudbuild.yaml", {
    registry = var.image_registry_name
    image    = "finetune:latest"
  
  })
  filename = "${path.root}/cloudbuild.yaml"
}


resource "local_file" "flow_config_file" {
  content = templatefile("${path.root}/templates/flow_config.json", {
    project_id = var.project_id
    registry   = var.image_registry_name
    image    = "finetune:latest"
  })
  filename = "${path.root}/flow/flow_config.json"
}
