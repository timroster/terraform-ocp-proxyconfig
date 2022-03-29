module "ocp_proxy_module" {
  source = "./module"
  #source = "../../"

  depends_on = [ module.proxy, module.cluster ]

  ibmcloud_api_key    = var.ibmcloud_api_key
  resource_group_name = module.resource_group.name
  region              = var.region
  proxy_endpoint      = module.proxy.proxy_endpoint
  cluster_config_file = module.cluster.platform.kubeconfig
  cluster_name        = module.cluster.name
  roks_cluster        = var.roks_cluster
}

