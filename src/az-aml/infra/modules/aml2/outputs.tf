# outputs.tf
output "aml_rg" {
  description = "AML Resource Group"
  value       = data.azurerm_resource_group.default.name
}

output "aml_mlw_name" {
  description = "AML Resource Group"
  value       = azurerm_machine_learning_workspace.default.name
}
