variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api token, required for ROKS cluster rolling worker updates"
  default     = ""
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name, required for ROKS cluster rolling worker updates"
  default     = ""
}

variable "region" {
  type        = string
  description = "The region, required for ROKS cluster rolling worker updates"
  default     = ""
}

variable "proxy_endpoint" {
  type = object({
    proxy_host = string
    proxy_port = string
  })
  description = "Host and port exposed by HTTP tunnel proxy"
}

variable "cluster_config_file" {
  type        = string
  description = "Cluster config file for Kubernetes cluster"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name, required for ROKS cluster rolling worker updates"
  default     = ""
}

variable "cluster_type" {
  type        = string
  description = "The type of cluster (openshift or kubernetes)"
  default     = "ocp4"
}

variable "allow_network" {
  type        = string
  description = "CIDR network range to skip for proxy traffic, only used for ROKS"
  default     = "10.0.0.0/8"
}

variable "no_proxy_hosts" {
  type        = string
  description = "List (comma separated) of hosts to skip from the proxy, used for all cluster types"
  default     = ""
}

variable "ocp-release-dev-image" {
  type        = string
  description = "url to access privately the openshift release dev image used in a daemonset, only used for ROKS"
  default     = "quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:3d0aa55199bceb4c94698432df382b1d7289bf361a35ca4954a5a255b82a0e03"
}

variable "ocp_version" {
  type        = string
  description = "The version of the OpenShift cluster that should be provisioned (format 4.x)"
}

variable "roks_cluster" {
  type        = bool
  description = "Variable to identify if the cluster is Red Hat OpenShift on IBM Cloud"
  default     = false
}

variable "cos_regions_map" {
  type        = map(any)
  description = "IBM Cloud Region COS endpoints"
  default = {
      "us-south" = { cosEndpoint = "s3.direct.us-south.cloud-object-storage.appdomain.cloud" },
      "us-east"  = { cosEndpoint = "s3.direct.us-east.cloud-object-storage.appdomain.cloud" },
      "eu-gb"    = { cosEndpoint = "s3.direct.eu-gb.cloud-object-storage.appdomain.cloud" },
      "eu-de"    = { cosEndpoint = "s3.direct.eu-de.cloud-object-storage.appdomain.cloud" },
      "jp-tok"   = { cosEndpoint = "s3.direct.jp-tok.cloud-object-storage.appdomain.cloud" },
      "jp-osa"   = { cosEndpoint = "s3.direct.jp-osa.cloud-object-storage.appdomain.cloud" },
      "au-syd"   = { cosEndpoint = "s3.direct.au-syd.cloud-object-storage.appdomain.cloud" },
      "ca-tor"   = { cosEndpoint = "s3.direct.ca-tor.cloud-object-storage.appdomain.cloud" },
      "br-sao"   = { cosEndpoint = "s3.direct.br-sao.cloud-object-storage.appdomain.cloud" },
  }
}

variable "crio_configfile_map" {
  type        = map(any)
  description = "cri-o config file location by OCP version"
  default = {
      "4.6" = { crio_configfile = "crio-network" },
      "4.7" = { crio_configfile = "crio-network" },
      "4.8" = { crio_configfile = "crio-network" },
      "4.9" = { crio_configfile = "crio" },
      "4.10" = { crio_configfile = "crio" },
  }
}

