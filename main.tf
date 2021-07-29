locals {
  spine_interface_profiles = [for v in var.interface_profiles : "uni/infra/spaccportprof-${v}"]
  node_blocks = flatten([
    for selector in var.selectors : [
      for node_block in selector.node_blocks : {
        key = "${selector.name}/${node_block.name}"
        value = {
          selector = selector.name
          name     = node_block.name
          from     = node_block.from
          to       = lookup(node_block, "to", node_block.from)
        }
      }
    ]
  ])
}

resource "aci_rest" "infraSpineP" {
  dn         = "uni/infra/spprof-${var.name}"
  class_name = "infraSpineP"
  content = {
    name = var.name
  }
}

resource "aci_rest" "infraSpineS" {
  for_each   = { for sel in var.selectors : sel.name => sel }
  dn         = "${aci_rest.infraSpineP.id}/spines-${each.value.name}-typ-range"
  class_name = "infraSpineS"
  content = {
    name = each.value.name
  }
}

resource "aci_rest" "infraNodeBlk" {
  for_each   = { for item in local.node_blocks : item.key => item.value }
  dn         = "${aci_rest.infraSpineS[each.value.selector].id}/nodeblk-${each.value.name}"
  class_name = "infraNodeBlk"
  content = {
    name  = each.value.name
    from_ = each.value.from
    to_   = each.value.to
  }
}

resource "aci_rest" "infraRsSpAccPortP" {
  for_each   = toset(local.spine_interface_profiles)
  dn         = "${aci_rest.infraSpineP.id}/rsspAccPortP-[${each.value}]"
  class_name = "infraRsSpAccPortP"
  content = {
    tDn = each.value
  }
}