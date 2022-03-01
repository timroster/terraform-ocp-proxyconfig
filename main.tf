locals {
  tmp_dir           = "${path.cwd}/.tmp"
  proxy-config = templatefile("${path.module}/templates/_template_proxy-config.yaml", {
    "proxy_ip"       = var.proxy-host,
    "proxy_port"     = var.proxy-port,
    "no_proxy_hosts" = var.no-proxy-hosts
  })
  crio-config = templatefile("${path.module}/templates/_template_setcrioproxy.yaml", {
    "proxy_ip"              = var.proxy-host,
    "proxy_port"            = var.proxy-port,
    "cluster_local"         = var.allow_network,
    "ocp_release_dev_image" = var.ocp-release-dev-image
  })
}

resource "local_file" "proxy-config" {
  filename = "${local.tmp_dir}/proxy-config.yaml"
  content  = local.proxy-config
}


resource null_resource apply-proxy-config {
  depends_on = [local_file.proxy-config]

  triggers = {
    kubeconfig = var.cluster_config_file
  }

  provisioner "local-exec" {
    command = "oc apply -f ${local.tmp_dir}/proxy-config.yaml"

    environment = {
      KUBECONFIG = var.cluster_config_file
    }
  }

  provisioner "local-exec" {
    when = destroy

    command = "oc apply -f ${path.module}/templates/no_proxy-config.yaml"

    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
  }
}
