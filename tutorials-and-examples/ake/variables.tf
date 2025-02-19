variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 3
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

variable "resource_group_name" {
  type=string
}

variable "cluster_name" {
  type=string
}

variable "cluster_dns_prefix" {
  type=string
}

variable "workflow_identity_name" {
  type= string
}

variable "workload_sa_name" {
  type        = string
  description = "Kubernetes service account to permit"
}

variable "workload_sa_namespace" {
  type        = string
  description = "Kubernetes service account namespace to permit"
}
