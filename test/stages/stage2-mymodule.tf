module "ocp_proxy_module" {
  # source = "./module"
  source = "../../"

  ibmcloud_api_key    = var.ibmcloud_api_key
  proxy-host          = var.proxy-host
  proxy-port          = var.proxy-port
  cluster_config_file = module.dev_cluster.platform.kubeconfig
}

# output "cluster_config_file" {
#   value = module.dev_cluster.config_file_path
# }

# output "preferred-cluster-config" {
#   value = module.dev_cluster.platform.kubeconfig
#   sensitive = true
# }
