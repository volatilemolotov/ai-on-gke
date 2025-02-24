data "azurerm_subscription" "current" {}

resource "azurerm_user_assigned_identity" "myworkload_identity" {
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  name = var.workflow_identity_name
}

resource "azurerm_federated_identity_credential" "myworkload_identity" {
  name                = azurerm_user_assigned_identity.myworkload_identity.name
  resource_group_name = azurerm_user_assigned_identity.myworkload_identity.resource_group_name
  parent_id           = azurerm_user_assigned_identity.myworkload_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.k8s.oidc_issuer_url
  subject             = "system:serviceaccount:${var.workload_sa_namespace}:${var.workload_sa_name}"
}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

#resource "azurerm_role_assignment" "example" {
#  scope              = data.azurerm_subscription.current.id
#  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"
#  principal_id       = azurerm_user_assigned_identity.myworkload_identity.principal_id
#}

#output "myworkload_identity_client_id" {
#  description = "The client ID of the created managed identity to use for the annotation 'azure.workload.identity/client-id' on your service account"
#  value       = azurerm_user_assigned_identity.myworkload_identity.client_id
#}
