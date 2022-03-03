locals {
  tmp_dir          = "${path.cwd}/.tmp"
  crio_config_file = "${local.tmp_dir}/crio-config.yaml"
  proxy-config = templatefile("${path.module}/templates/_template_proxy-config.yaml", {
    "proxy_ip"       = var.proxy_endpoint.proxy_host,
    "proxy_port"     = var.proxy_endpoint.proxy_port,
    "no_proxy_hosts" = var.no_proxy_hosts
  })
  crio-config = templatefile("${path.module}/templates/_template_setcrioproxy.yaml", {
    "proxy_ip"              = var.proxy_endpoint.proxy_host,
    "proxy_port"            = var.proxy_endpoint.proxy_port,
    "cluster_local"         = var.allow_network,
    "ocp_release_dev_image" = var.ocp-release-dev-image
  })
  crio-unconfig = templatefile("${path.module}/templates/_template_rmcrioproxy.yaml", {
    "ocp_release_dev_image" = var.ocp-release-dev-image
  })
}

## Standard proxy config file for OCP
resource "local_file" "proxy-config" {
  filename = "${local.tmp_dir}/proxy-config.yaml"
  content  = local.proxy-config
}

## Config file for ROKS - daemonset to patch crio networking to use proxy
resource "local_file" "crio-config" {
  filename = "${local.tmp_dir}/crio-config.yaml"
  content  = local.crio-config
}

## Config file for ROKS - daemonset to remove modifications to crio networking
resource "local_file" "crio-unconfig" {
  filename = "${local.tmp_dir}/crio-unconfig.yaml"
  content  = local.crio-unconfig
}

## Apply to all OpenShift Clusters
resource "null_resource" "apply-proxy-config" {
  depends_on = [local_file.proxy-config]

  triggers = {
    kubeconfig = var.cluster_config_file
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local.tmp_dir}/proxy-config.yaml"

    environment = {
      KUBECONFIG = var.cluster_config_file
    }
  }

  provisioner "local-exec" {
    when = destroy

    command = "kubectl apply -f ${path.module}/templates/no_proxy-config.yaml"

    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
  }
}

resource "null_resource" "apply-crio-config" {
  depends_on = [local_file.crio-config, local_file.crio-unconfig]

  count = var.roks_cluster ? 1 : 0

  triggers = {
    kubeconfig          = var.cluster_config_file
    crio-config-file    = "${local.tmp_dir}/crio-config.yaml"
    ibmcloud_api_key    = var.ibmcloud_api_key
    cluster_name        = var.cluster_name
    region              = var.region
    resource_group_name = var.resource_group_name
    crio-unconfig-file  = "${local.tmp_dir}/crio-unconfig.yaml"
  }

  ### first three provisioners ensure ROKS workers have crio-config and are rebooted to use proxy
  provisioner "local-exec" {
    command = "kubectl apply -f ${local.tmp_dir}/crio-config.yaml"

    environment = {
      KUBECONFIG = var.cluster_config_file
    }
  }

  provisioner "local-exec" {
    command = "kubectl rollout status daemonset -n kube-system https-proxy-mod --timeout 120s"

    environment = {
      KUBECONFIG = var.cluster_config_file
    }
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/reboot-roks-workers.sh '${var.region}' '${var.resource_group_name}'"

    environment = {
      IBMCLOUD_API_KEY = var.ibmcloud_api_key
      CLUSTER          = var.cluster_name
    }
  }
  ### end setup for crio-config

  ### provisioners to back out crio networking configuration for proxy and reboot ROKS workers
  provisioner "local-exec" {
    when = destroy

    command = "kubectl delete -f ${self.triggers.crio-config-file} && kubectl apply -f ${self.triggers.crio-unconfig-file}"

    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
  }

  provisioner "local-exec" {
    when = destroy

    command = "kubectl rollout status daemonset -n kube-system https-proxy-remove --timeout 120s"

    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
  }

  provisioner "local-exec" {
    when = destroy

    command = "kubectl delete -f ${self.triggers.crio-unconfig-file}"

    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
  }

  provisioner "local-exec" {
    when = destroy

    command = "${path.module}/scripts/reboot-roks-workers.sh '${self.triggers.region}' '${self.triggers.resource_group_name}'"

    environment = {
      IBMCLOUD_API_KEY = self.triggers.ibmcloud_api_key
      CLUSTER          = self.triggers.cluster_name
    }
  }
  ### end cleanup for crio-config
}