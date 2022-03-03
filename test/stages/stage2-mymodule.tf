module "ocp_proxy_module" {
  source = "./module"
  # source = "../../"

  ibmcloud_api_key    = var.ibmcloud_api_key
  resource_group_name = module.resource_group.name
  region              = var.region
  proxy_endpoint      = var.proxy_endpoint
  cluster_config_file = module.dev_cluster.platform.kubeconfig
  cluster_name        = module.dev_cluster.name
  roks_cluster        = var.roks_cluster
}

