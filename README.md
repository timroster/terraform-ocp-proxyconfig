# Configure HTTP Proxy on OpenShift Container Platform

## Module overview

### Description

This module will configure an application proxy to allow an OpenShift cluster to use that proxy instead of a direct Internet gateway. This module takes as input a hostname or IP address of the proxy and port that it is running on. As the design point is for private network connectivity, all proxy connections are performed over http to avoid additional configuration of a private signing CA for the application proxy. This does not expose the client to server communication to the proxy in any way. HTTP is used to create the tunnel the the proxy server, once connected with HTTP CONNECT, direct TCP traffic is exchanged between client and server. For more information see <https://en.wikipedia.org/wiki/HTTP_tunnel>.

On Red Hat OpenShift on IBM Cloud, the addition of a separate control plane causes additional configuration to be required by the module. The module will deploy a daemonset which modifies the worker `cri-o` configuration and then performs a rolling restart of all of the workers. For this reason, the module does require a valid IBM Cloud API key to perform the restarts.

**Note:** This module follows the Terraform conventions regarding how provider configuration is defined within the Terraform template and passed into the module - <https://www.terraform.io/docs/language/modules/develop/providers.html>. The default provider configuration flows through to the module. If different configuration is required for a module, it can be explicitly passed in the `providers` block of the module - <https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly>.

### Software dependencies

The module depends on the following software components:

#### Command-line tools

- terraform >= v0.15
- kubectl

#### Terraform providers

- IBM Cloud provider >= 1.22

### Module dependencies

This module makes use of the output from other modules:

- Cluster - github.com/cloud-native-toolkit/terraform-ibm-container-platform.git
- Proxy - github.com/cloud-native-toolkit/terraform-vsi-proxy.git

### Example usage

```hcl-terraform
module "ocp_proxy_module" {

  ibmcloud_api_key    = var.ibmcloud_api_key
  roks_cluster        = true
  proxy-host          = module.proxy.proxy-host
  proxy-port          = module.proxy.proxy-port
  cluster_config_file = module.dev_cluster.platform.kubeconfig
}
```
