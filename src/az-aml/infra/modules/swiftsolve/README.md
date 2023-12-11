<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The location to provision the resources in | `any` | n/a | yes |
| <a name="input_pep_dnsz_rg_name"></a> [pep\_dnsz\_rg\_name](#input\_pep\_dnsz\_rg\_name) | The resource group of the DNS Zones for the Private Endpoints | `any` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The resource group to provision the resources in | `any` | n/a | yes |
| <a name="input_storageaccounts"></a> [storageaccounts](#input\_storageaccounts) | n/a | <pre>map(object({<br>        name      = optional(string)<br>        location  = optional(string)<br>        container = optional(string)<br>      }))</pre> | `{}` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The name the subnet for the PEP | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to apply to the VM resource | `map(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name the virtual network to provision the resource in. The VM will be provisioned in the same location as this virtual network | `any` | n/a | yes |
| <a name="input_vnet_rg_name"></a> [vnet\_rg\_name](#input\_vnet\_rg\_name) | The resource group of the virtual network for Private Endpoints | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->