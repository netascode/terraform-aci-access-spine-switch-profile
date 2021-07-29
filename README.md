<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-access-spine-switch-profile/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-access-spine-switch-profile/actions/workflows/test.yml)

# Terraform ACI Access Spine Switch Profile Module

Manages ACI Access Spine Switch Profile

Location in GUI:
`Fabric` » `Access Policies` » `Switches` » `Spine Switches` » `Profiles`

## Examples

```hcl
module "aci_access_spine_switch_profile" {
  source = "netascode/access-spine-switch-profile/aci"

  name               = "SPINE1001"
  interface_profiles = ["SPINE1001"]
  selectors = [{
    name = "SEL1"
    node_blocks = [{
      name = "BLOCK1"
      from = 1001
      to   = 1001
    }]
  }]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Spine switch profile name | `string` | n/a | yes |
| <a name="input_interface_profiles"></a> [interface\_profiles](#input\_interface\_profiles) | List of interface profile names | `list(string)` | `[]` | no |
| <a name="input_selectors"></a> [selectors](#input\_selectors) | List of Selectors | <pre>list(object({<br>    name = string<br>    node_blocks = list(object({<br>      name = string<br>      from = number<br>      to   = optional(number)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `infraSpineP` object |
| <a name="output_name"></a> [name](#output\_name) | Spine switch profile name |

## Resources

| Name | Type |
|------|------|
| [aci_rest.infraNodeBlk](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.infraRsSpAccPortP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.infraSpineP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.infraSpineS](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->