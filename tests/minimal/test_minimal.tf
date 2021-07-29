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

  name = "SPINE1001"
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
