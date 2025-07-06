output "kube_config" {
  value     = module.aks.kube_config_raw
  sensitive = true
}

output "aks_fqdn" {
  value = module.aks.kube_admin_config[0].host
}