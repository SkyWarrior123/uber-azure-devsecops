variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "cluster_name"       { type = string }
variable "kubernetes_version" { type = string, default = "1.27.2" }
variable "dns_prefix"         { type = string }
variable "node_vm_size"       { type = string, default = "Standard_B2ms" }
variable "node_count"         { type = number, default = 2 }