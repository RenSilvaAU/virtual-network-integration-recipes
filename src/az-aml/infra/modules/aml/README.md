<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_container_registry.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_key_vault.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_machine_learning_compute_cluster.compute](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_compute_cluster) | resource |
| [azurerm_machine_learning_compute_cluster.image-builder](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_compute_cluster) | resource |
| [azurerm_machine_learning_compute_instance.compute_instance](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_compute_instance) | resource |
| [azurerm_machine_learning_workspace.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_workspace) | resource |
| [azurerm_private_endpoint.cr_ple](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.kv_ple](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.mlw_ple](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.st_ple_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.storage_ple_file](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_storage_account.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [random_string.ci_prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.ml](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.training](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | Name of the ACR | `string` | n/a | yes |
| <a name="input_aks_subnet_name"></a> [aks\_subnet\_name](#input\_aks\_subnet\_name) | Name of the existing aks subnet | `string` | n/a | yes |
| <a name="input_akv_name"></a> [akv\_name](#input\_akv\_name) | Name of the Azure Key Vault | `string` | n/a | yes |
| <a name="input_appin_name"></a> [appin\_name](#input\_appin\_name) | Name of the Application Insights | `string` | n/a | yes |
| <a name="input_image_build_compute_name"></a> [image\_build\_compute\_name](#input\_image\_build\_compute\_name) | Name of the compute cluster to be created and set to build docker images | `string` | `"image-builder"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the resources | `string` | `"East US"` | no |
| <a name="input_ml_subnet_name"></a> [ml\_subnet\_name](#input\_ml\_subnet\_name) | Name of the existing ML workspace subnet | `string` | n/a | yes |
| <a name="input_mlw_name"></a> [mlw\_name](#input\_mlw\_name) | Name of the Machine Learning Workspace | `string` | n/a | yes |
| <a name="input_privatelink_api_azureml_ms_resource_id"></a> [privatelink\_api\_azureml\_ms\_resource\_id](#input\_privatelink\_api\_azureml\_ms\_resource\_id) | Resource ID of the existing privatelink.api.azureml.ms private dns zone | `string` | n/a | yes |
| <a name="input_privatelink_azurecr_io_resource_id"></a> [privatelink\_azurecr\_io\_resource\_id](#input\_privatelink\_azurecr\_io\_resource\_id) | Resource ID of the existing privatelink.azurecr.io private dns zone | `string` | n/a | yes |
| <a name="input_privatelink_blob_core_windows_net_resource_id"></a> [privatelink\_blob\_core\_windows\_net\_resource\_id](#input\_privatelink\_blob\_core\_windows\_net\_resource\_id) | Resource ID of the existing privatelink.blob.core.windows.net private dns zone | `string` | n/a | yes |
| <a name="input_privatelink_file_core_windows_net_resource_id"></a> [privatelink\_file\_core\_windows\_net\_resource\_id](#input\_privatelink\_file\_core\_windows\_net\_resource\_id) | Resource ID of the existing privatelink.file.core.windows.net private dns zone | `string` | n/a | yes |
| <a name="input_privatelink_notebooks_azure_net_resource_id"></a> [privatelink\_notebooks\_azure\_net\_resource\_id](#input\_privatelink\_notebooks\_azure\_net\_resource\_id) | Resource ID of the existing privatelink.notebooks.azure.net private dns zone | `string` | n/a | yes |
| <a name="input_privatelink_vaultcore_azure_net_resource_id"></a> [privatelink\_vaultcore\_azure\_net\_resource\_id](#input\_privatelink\_vaultcore\_azure\_net\_resource\_id) | Resource ID of the existing privatelink.vaultcore.azure.net private dns zone | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of the existing RG | `string` | n/a | yes |
| <a name="input_sta_name"></a> [sta\_name](#input\_sta\_name) | Name of the Storage Account | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to apply to the resources | `map(string)` | n/a | yes |
| <a name="input_training_subnet_name"></a> [training\_subnet\_name](#input\_training\_subnet\_name) | Name of the existing training subnet | `string` | n/a | yes |
| <a name="input_vm_cluster_name"></a> [vm\_cluster\_name](#input\_vm\_cluster\_name) | Name of the vm cluster | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the existing VNet | `string` | n/a | yes |
| <a name="input_vnet_resource_group_name"></a> [vnet\_resource\_group\_name](#input\_vnet\_resource\_group\_name) | Name of the resource group for the existing VNet | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->