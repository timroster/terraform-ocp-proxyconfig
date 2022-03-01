#output "myoutput" {
#  description = "Description of my output"
#  value       = "value"
#  depends_on  = [<some resource>]
#}

output "proxy-config-yaml" {
  description = "apply to cluster to enable system use of proxy"
  value       = local.proxy-config
}

output "setcrioproxy-yaml" {
  description = "apply to cluster to enable system use of proxy"
  value       = local.crio-config
}
