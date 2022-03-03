# Resource Group Variables
variable "resource_group_name" {
  type        = string
  description = "Existing resource group where the IKS cluster will be provisioned."
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api token"
  default     = ""
}

variable "region" {
  type        = string
  description = "Region for VLANs defined in private_vlan_number and public_vlan_number."
}

variable "proxy_endpoint" {
  type = object({
    proxy_host = string
    proxy_port = string
  })
  description = "Host and port exposed by HTTP tunnel proxy"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = ""
}

variable "cluster_exists" {
  type        = string
  description = "Flag indicating if the cluster already exists (true or false)"
  default     = "true"
}

variable "name_prefix" {
  type        = string
  description = "Prefix name that should be used for the cluster and services. If not provided then resource_group_name will be used"
  default     = ""
}

variable "vpc_cluster" {
  type        = bool
  description = "Flag indicating that this is a vpc cluster"
  default     = true
}

variable "roks_cluster" {
  type        = bool
  description = "Flag indicating that this is a ROKS cluster"
}

