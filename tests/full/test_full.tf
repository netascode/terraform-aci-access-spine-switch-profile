terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

module "main" {
  source = "../.."

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

data "aci_rest" "infraSpineP" {
  dn = "uni/infra/spprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "infraSpineP" {
  component = "infraSpineP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraSpineP.content.name
    want        = module.main.name
  }
}

data "aci_rest" "infraSpineS" {
  dn = "${data.aci_rest.infraSpineP.id}/spines-SEL1-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraSpineS" {
  component = "infraSpineS"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraSpineS.content.name
    want        = "SEL1"
  }
}

data "aci_rest" "infraNodeBlk" {
  dn = "${data.aci_rest.infraSpineS.id}/nodeblk-BLOCK1"

  depends_on = [module.main]
}

resource "test_assertions" "infraNodeBlk" {
  component = "infraNodeBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraNodeBlk.content.name
    want        = "BLOCK1"
  }

  equal "from_" {
    description = "from_"
    got         = data.aci_rest.infraNodeBlk.content.from_
    want        = "1001"
  }

  equal "to_" {
    description = "to_"
    got         = data.aci_rest.infraNodeBlk.content.to_
    want        = "1001"
  }
}

data "aci_rest" "infraRsSpAccPortP" {
  dn = "${data.aci_rest.infraSpineP.id}/rsspAccPortP-[uni/infra/spaccportprof-SPINE1001]"

  depends_on = [module.main]
}

resource "test_assertions" "infraRsSpAccPortP" {
  component = "infraRsSpAccPortP"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.infraRsSpAccPortP.content.tDn
    want        = "uni/infra/spaccportprof-SPINE1001"
  }
}
