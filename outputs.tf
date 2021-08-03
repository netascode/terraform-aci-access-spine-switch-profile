output "dn" {
  value       = aci_rest.infraSpineP.id
  description = "Distinguished name of `infraSpineP` object."
}

output "name" {
  value       = aci_rest.infraSpineP.content.name
  description = "Spine switch profile name."
}
