variable "compartment_id" {
  description = "Display name used for compartment"
  type        = string
  default     = "ocid1.compartment.oc1..aaaaaaaafujaxb5oanlmpe4nuyzxjircz6cfm75pqp5b2cjqbri6de4qy7gq"
}

#################################
# VCN
#################################

# variable "vcn_cidr_blocks" {
#   description = ""
#   type        = list(string)
#   default     = "10.0.0.0/16"
# }

variable "vcn_display_name" {
  description = "A user-defined name for the Virtual Cloud Network (VCN)."
  type        = string
  default     = "kj-oke-vcn"
}

variable "vcn_dns_label" {
  description = "A DNS label for the VCN, used in conjunction with the DNS label of the VCN's default subnet to create a fully qualified domain name (FQDN) for the VCN."
  type        = string
  default     = "kjtestcluster"
}

variable "vcn_byoipv6cidr_details_id" {
  description = "The OCID of the BYOIP CIDR block details."
  type        = string
  default     = null
}

variable "vcn_byoipv6cidr_details_cidr_block" {
  description = "The CIDR block for BYOIP CIDR block details. It must be valid and not overlap with your VCN's existing CIDR blocks."
  type        = string
  default     = null
}

#################################
# subnet
#################################

variable "subnet_one_cidr_block" {
  description = "The CIDR block for the first subnet in the Virtual Cloud Network (VCN)."
  type        = string
  default     = "10.0.20.0/24"
}

variable "subnet_two_cidr_block" {
  description = "The CIDR block for the second subnet in the Virtual Cloud Network (VCN)."
  type        = string
  default     = "10.0.10.0/24"
}

variable "subnet_three_cidr_block" {
  description = "The CIDR block for the third subnet in the Virtual Cloud Network (VCN)."
  type        = string
  default     = "10.0.0.0/28"
}

variable "subnet_one_display_name" {
  description = "A user-defined name for the first subnet."
  type        = string
  default     = "kj-oke-svclbsubnet"
}

variable "subnet_two_display_name" {
  description = "A user-defined name for the second subnet."
  type        = string
  default     = "kj-oke-nodesubnet"
}

variable "subnet_three_display_name" {
  description = "A user-defined name for the third subnet, representing the Kubernetes API endpoint subnet."
  type        = string
  default     = "kj-oke-k8sApiEndpoint-subnet"
}

variable "subnet_one_dns_label" {
  description = "The DNS label for the first subnet, used in conjunction with the VCN's DNS label to create a fully qualified domain name (FQDN) for resources within the subnet."
  type        = string
  default     = "lbsube3c343ca8"
}

variable "subnet_two_dns_label" {
  description = "The DNS label for the second subnet, used for creating a fully qualified domain name (FQDN) for resources within the subnet."
  type        = string
  default     = "sub90bb31acf"
}

variable "subnet_three_dns_label" {
  description = "The DNS label for the third subnet, used for creating a fully qualified domain name (FQDN) for resources within the subnet."
  type        = string
  default     = "subba6d11348"
}

variable "subnet_prohibit_internet_ingress" {
  description = "A boolean flag indicating whether to prohibit internet ingress traffic for the subnet. If set to true, internet ingress traffic is prohibited; if false, it is allowed."
  type        = bool
  default     = false
}

variable "subnet_prohibit_public_ip_on_vnic" {
  description = "A boolean flag indicating whether to prohibit the assignment of public IP addresses to Virtual Network Interface Cards (VNICs) within the subnet. If set to true, public IP assignments are prohibited; if false, they are allowed."
  type        = bool
  default     = false
}

variable "subnet_prohibit_internet_ingress_private" {
  description = "A boolean flag indicating whether to prohibit internet ingress traffic for a private subnet. If set to true, internet ingress traffic is prohibited; if false, it is allowed."
  type        = bool
  default     = true
}

variable "subnet_prohibit_public_ip_on_vnic_private" {
  description = "A boolean flag indicating whether to prohibit the assignment of public IP addresses to Virtual Network Interface Cards (VNICs) within a private subnet. If set to true, public IP assignments are prohibited; if false, they are allowed."
  type        = bool
  default     = true
}

#################################
# DHCP
#################################
variable "dhcp_options_display_name" {
  description = "A user-defined name for the DHCP options, representing the default DHCP options for the specified Virtual Cloud Network (VCN)."
  type        = string
  default     = "Default DHCP Options for kj oke-vcn"
}

variable "dhcp_options_domain_name_type" {
  description = "The type of domain name for DHCP options. Set to 'CUSTOM_DOMAIN' for a custom domain name."
  type        = string
  default     = "CUSTOM_DOMAIN"
}

variable "dhcp_server_type" {
  description = "The type of DHCP server. Set to 'VcnLocalPlusInternet' for a combination of VCN-local and internet-resolvable hostnames."
  type        = string
  default     = "VcnLocalPlusInternet"
}

variable "dhcp_dns_type_custom" {
  description = "The type of DNS entry for custom DHCP options. Set to 'DomainNameServer' for specifying custom DNS servers."
  type        = string
  default     = "DomainNameServer"
}

variable "dhcp_search_domain_names" {
  description = "A list of search domain names for DHCP options. Used in conjunction with DNS resolution for the specified VCN."
  type        = list(string)
  default = [
    "kjtestcluster.oraclevcn.com",
  ]
}

variable "dhcp_dns_server_type" {
  description = "The type of DNS server for DHCP options. If null, it indicates the default behavior. Set to 'VcnLocal' or 'Internet' based on specific DNS server requirements."
  type        = string
  default     = null
}

variable "dhcp_dns_type" {
  description = "The type of DNS entry for DHCP options. Set to 'SearchDomain' for specifying search domain entries."
  type        = string
  default     = "SearchDomain"
}

#################################
# Route Table
#################################
variable "route_table_display_name" {
  description = "A user-defined name for the route table, representing the route table associated with the specified Virtual Cloud Network (VCN)."
  type        = string
  default     = "oke-private-routetable"
}

variable "route_table_route_rules_description_private_igw" {
  description = "Description for the route rule directing traffic to the internet via the Internet Gateway (IGW)."
  type        = string
  default     = "traffic to the internet"
}

variable "route_table_route_rules_destination_private_igw" {
  description = "Destination CIDR block for the route rule directing traffic to the internet via the Internet Gateway (IGW)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_table_route_rules_destination_type_private_igw" {
  description = "Type of destination for the route rule directing traffic to the internet via the Internet Gateway (IGW). Set to 'CIDR_BLOCK'."
  type        = string
  default     = "CIDR_BLOCK"
}

variable "route_table_route_rules_description_private_sg" {
  description = "Description for the route rule directing traffic to Oracle Cloud Infrastructure (OCI) services."
  type        = string
  default     = "traffic to OCI services"
}

variable "route_table_route_rules_destination_private_sg" {
  description = "Destination CIDR block for the route rule directing traffic to Oracle Cloud Infrastructure (OCI) services in the Oracle Services Network."
  type        = string
  default     = "all-iad-services-in-oracle-services-network"
}

variable "route_table_route_rules_destination_type_private_sg" {
  description = "Type of destination for the route rule directing traffic to Oracle Cloud Infrastructure (OCI) services. Set to 'SERVICE_CIDR_BLOCK'."
  type        = string
  default     = "SERVICE_CIDR_BLOCK"
}

#####################################
# default route table 
###################################
variable "route_table_route_rules_description_public" {
  description = "Description for the route rule allowing traffic to/from the internet."
  type        = string
  default     = "traffic to/from internet"
}

variable "route_table_route_rules_destination_public" {
  description = "Destination CIDR block for the route rule allowing traffic to/from the internet."
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_table_route_rules_destination_type_public" {
  description = "Type of destination for the route rule allowing traffic to/from the internet. Set to 'CIDR_BLOCK'."
  type        = string
  default     = "CIDR_BLOCK"
}

variable "default_route_table_display_name_" {
  description = "A user-defined name for the default route table, representing the route table associated with the public subnet in the specified Virtual Cloud Network (VCN)."
  type        = string
  default     = "oke-public-routetable"
}

##################################################
# service gateway
##################################################
variable "service_gateway_display_name" {
  description = "A user-defined name for the service gateway, representing the service gateway associated with the specified Virtual Cloud Network (VCN)."
  type        = string
  default     = "oke-sg-kj-test"
}

variable "service_gateway_service_id" {
  description = "The OCID (Oracle Cloud Identifier) of the service associated with the service gateway. This ID identifies the specific Oracle Cloud Infrastructure (OCI) service to be connected to the VCN."
  type        = string
  default     = "ocid1.service.oc1.iad.aaaaaaaam4zfmy2rjue6fmglumm3czgisxzrnvrwqeodtztg7hwa272mlfna"
}

##################################################
# nat gateway
##################################################

variable "nat_gateway_block_traffic" {
  description = "A boolean flag indicating whether the NAT gateway should block traffic. If set to true, the NAT gateway blocks traffic; if false, it allows traffic."
  type        = bool
  default     = false
}

variable "nat_gateway_display_name" {
  description = "A user-defined name for the NAT gateway, representing the NAT gateway associated with the specified Virtual Cloud Network (VCN)."
  type        = string
  default     = "oke-ngw"
}

##################################################
# igw 
##################################################

variable "internet_gateway_display_name" {
  description = "A user-defined name for the internet gateway, representing the internet gateway associated with the specified Virtual Cloud Network (VCN)."
  type        = string
  default     = "oke-igw-kj-test"
}

variable "internet_gateway_enabled" {
  description = "A boolean flag indicating whether the internet gateway is enabled. If set to true, the internet gateway is enabled; if false, it is disabled."
  type        = bool
  default     = true
}

##################################################
# dynamic blocks
##################################################

variable "configure_byoipv6" {
  description = "Set this variable to true if you want to configure BYOIPv6 (Bring Your Own IPv6) for the resource."
  type        = bool
  default     = false
}

variable "configure_key_details" {
  description = "Set this variable to true if you want to configure key details. When true, the necessary key details, such as the Key Management Service (KMS) key OCID, should be provided."
  type        = bool
  default     = false
}

##################################################
# kubernetes cluster 
##################################################

variable "cluster_cluster_pod_network_options_cni_type" {
  description = "The Container Networking Interface (CNI) type for the Kubernetes pod network options in the cluster configuration."
  type        = string
  default     = "OCI_VCN_IP_NATIVE"
}

variable "cluster_endpoint_config_is_public_ip_enabled" {
  description = "A boolean flag indicating whether the Kubernetes API server endpoint is exposed with a public IP address. If set to true, the API server endpoint is exposed publicly; if false, it is private."
  type        = bool
  default     = true
}

variable "cluster_image_policy_config_is_policy_enabled" {
  description = "A boolean flag indicating whether the image policy configuration is enabled for the cluster. If set to true, the image policy configuration is enabled; if false, it is disabled."
  type        = bool
  default     = false
}

variable "cluster_kubernetes_version" {
  description = "The version of Kubernetes to be used for the cluster."
  type        = string
  default     = "v1.27.2"
}

variable "cluster_name" {
  description = "A user-defined name for the Kubernetes cluster."
  type        = string
  default     = "kj-test-cluster"
}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  description = "A boolean flag indicating whether the Kubernetes Dashboard add-on is enabled for the cluster. If set to true, the Kubernetes Dashboard is enabled; if false, it is disabled."
  type        = bool
  default     = false
}

variable "cluster_options_add_ons_is_tiller_enabled" {
  description = "A boolean flag indicating whether the Helm Tiller add-on is enabled for the cluster. If set to true, Helm Tiller is enabled; if false, it is disabled."
  type        = bool
  default     = false
}

variable "cluster_options_admission_controller_options_is_pod_security_policy_enabled" {
  description = "A boolean flag indicating whether the PodSecurityPolicy admission controller is enabled for the cluster. If set to true, PodSecurityPolicy is enabled; if false, it is disabled."
  type        = bool
  default     = false
}

variable "cluster_options_kubernetes_network_config_pods_cidr" {
  description = "The CIDR block for Kubernetes pod networking configuration in the cluster."
  type        = string
  default     = "10.244.0.0/16"
}

variable "cluster_options_kubernetes_network_config_services_cidr" {
  description = "The CIDR block for Kubernetes service networking configuration in the cluster."
  type        = string
  default     = "10.96.0.0/16"
}

#############################################
# node pool
#############################################
variable "node_pool_initial_node_labels_key" {
  description = "The key for the initial node labels in the Kubernetes node pool configuration."
  type        = string
  default     = "name"
}

variable "node_pool_initial_node_labels_value" {
  description = "The value for the initial node labels in the Kubernetes node pool configuration."
  type        = string
  default     = "kj-cluster"
}

variable "node_pool_kubernetes_version" {
  description = "The version of Kubernetes to be used for the node pool."
  type        = string
  default     = "v1.27.2"
}

variable "node_pool_name" {
  description = "A user-defined name for the Kubernetes node pool."
  type        = string
  default     = "pool1"
}

variable "node_pool_node_config_details_is_pv_encryption_in_transit_enabled" {
  description = "A boolean flag indicating whether persistent volume (PV) encryption in transit is enabled for the node pool."
  type        = bool
  default     = null
}

variable "node_pool_node_config_details_node_pool_pod_network_option_details_cni_type" {
  description = "The Container Networking Interface (CNI) type for the pod network options in the Kubernetes node pool configuration."
  type        = string
  default     = "OCI_VCN_IP_NATIVE"
}

variable "node_pool_node_config_details_node_pool_pod_network_option_details_max_pods_per_node" {
  description = "The maximum number of pods per node for the pod network options in the Kubernetes node pool configuration."
  type        = string
  default     = "31"
}

variable "image_policy_config_kms_key_id" {
  description = "The OCID of the Key Management Service (KMS) key to be used for signing the image policy."
  type        = string
  default     = null
}

variable "node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_type" {
  description = "The preemption action type for preemptible node configuration in the Kubernetes node pool."
  type        = string
  default     = null
}

variable "node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_is_preserve_boot_volume" {
  description = "A boolean flag indicating whether to preserve the boot volume during preemption for preemptible nodes in the Kubernetes node pool."
  type        = bool
  default     = false
}

variable "node_pool_node_config_details_size" {
  description = "The number of nodes in the Kubernetes node pool."
  type        = string
  default     = "2"
}

variable "node_pool_node_eviction_node_pool_settings_eviction_grace_duration" {
  description = "The duration for eviction grace period in the Kubernetes node pool."
  type        = string
  default     = "PT1H"
}

variable "node_pool_node_eviction_node_pool_settings_is_force_delete_after_grace_duration" {
  description = "A boolean flag indicating whether to force delete nodes after the eviction grace period in the Kubernetes node pool."
  type        = string
  default     = null
}

variable "node_pool_node_shape" {
  description = "The shape of the nodes in the Kubernetes node pool."
  type        = string
  default     = "VM.Standard.E3.Flex"
}

variable "node_pool_node_shape_config_memory_in_gbs" {
  description = "The amount of memory (in gigabytes) for each node in the Kubernetes node pool."
  type        = string
  default     = "8"
}

variable "node_pool_node_shape_config_ocpus" {
  description = "The number of virtual CPUs (OCPUs) for each node in the Kubernetes node pool."
  type        = string
  default     = "4"
}

variable "node_pool_node_source_details_image_id" {
  description = "The OCID (Oracle Cloud Identifier) of the image used as the source for creating nodes in the Kubernetes node pool."
  type        = string
  default     = "ocid1.image.oc1.iad.aaaaaaaairuqkf7p2b37jpyklvnqhxxlhyr3fpk55jmi5yklnkdrbsao7msa"
}

variable "node_pool_node_source_details_source_type" {
  description = "The source type for creating nodes in the Kubernetes node pool. Set to 'IMAGE' for using a custom image as the source."
  type        = string
  default     = "IMAGE"
}

variable "node_pool_node_pool_cycling_details_is_node_cycling_enabled" {
  description = "A boolean flag indicating whether node cycling is enabled for the Kubernetes node pool."
  type        = bool
  default     = false
}

variable "node_pool_node_pool_cycling_details_maximum_surge" {
  description = "The maximum number of additional nodes that can be added to the Kubernetes node pool during node cycling."
  type        = string
  default     = "1"
}

variable "node_pool_node_pool_cycling_details_maximum_unavailable" {
  description = "The maximum number of nodes that can be concurrently unavailable during node cycling in the Kubernetes node pool."
  type        = string
  default     = "0"
}

variable "node_pool_quantity_per_subnet" {
  description = "The number of nodes to create per subnet in the Kubernetes node pool. If null, the default behavior is used."
  type        = string
  default     = null
}

variable "node_pool_ssh_public_key" {
  description = "The SSH public key to be included on the nodes in the Kubernetes node pool. If null, the default behavior is used."
  type        = string
  default     = null
}

variable "node_pool_subnet_ids" {
  description = "A list of subnet OCIDs (Oracle Cloud Identifiers) where the nodes in the Kubernetes node pool will be created."
  type        = list(string)
  default     = null
}

##################################################
# policy variables
##################################################

variable "policy_description" {
  description = "Description for the policy. Provide a meaningful description to explain the purpose or intent of this policy."
  type        = string
  default     = "Policy for Kubernetes Cluster Autoscaler as a Cluster Standalone Program"
}

variable "policy_name" {
  description = "Name for the policy. Specify a unique and identifiable name for the policy."
  type        = string
  default     = "kj-oke-test-policy"
}

variable "dynamic_group" {
    description=""
    default="autoscaler-dynamic-group"
    type=string
}

variable "compartment_name"{
    description=""
    default="Transility-oci"
    type=string
}
