module "ocp_proxy_module" {
  # source = "./module"
  source = "../../"

  ibmcloud_api_key    = var.ibmcloud_api_key
  proxy-host          = var.proxy-host
  proxy-port          = var.proxy-port
  cluster_config_file = module.dev_cluster.config_file_path
}

resource "local_file" "proxy-config" {
  filename = "proxy-config.yaml"
  content  = module.ocp_proxy_module.proxy-config-yaml
}

resource "local_file" "setcrioproxy" {
  filename = "setcrioproxy.yaml"
  content  = module.ocp_proxy_module.setcrioproxy-yaml
}
