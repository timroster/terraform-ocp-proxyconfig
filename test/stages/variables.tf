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

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = ""
}

variable "roks_cluster" {
  type        = bool
  description = "Flag indicating that this is a ROKS cluster"
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

variable "vpc_public_gateway" {
  type        = string
  description = "Flag indicating the public gateway should be created"
  default     = "true"
}

variable "vpc_subnet_count" {
  type        = number
  description = "The number of subnets to create for the VPC instance"
  default     = 0
}

variable "vpc_subnets" {
  type        = string
  description = "JSON representation of list of object, e.g. [{\"label\"=\"default\"}]"
  default     = "[]"
}

variable "worker_count" {
  type        = number
  default     = 2
}

variable "ocp_version" {
  type        = string
  default     = "4.8"
}

variable "vpc_subnet_label" {
  type        = string
  default     = "cluster"
}

