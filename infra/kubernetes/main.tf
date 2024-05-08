provider "oci" {
  config_file_profile = "DEFAULT"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# vcn
resource "oci_core_vcn" "test_vcn" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  dynamic "byoipv6cidr_details" {
    for_each = var.configure_byoipv6 ? [1] : []
    content {
      byoipv6range_id = var.vcn_byoipv6cidr_details_id
      ipv6cidr_block  = var.vcn_byoipv6cidr_details_cidr_block
    }
  }
  cidr_block = null
  cidr_blocks = [
    "10.0.0.0/16",
  ]
  defined_tags                     = {}
  display_name                     = var.vcn_display_name
  dns_label                        = var.vcn_dns_label
  freeform_tags                    = {}
  ipv6private_cidr_blocks          = []
  is_ipv6enabled                   = null
  is_oracle_gua_allocation_enabled = null
}

resource "oci_core_subnet" "subnet-one" {
  availability_domain = null
  cidr_block          = var.subnet_one_cidr_block
  compartment_id      = var.compartment_id
  defined_tags = {
  }
  dhcp_options_id = oci_core_vcn.test_vcn.default_dhcp_options_id
  display_name    = var.subnet_one_display_name
  dns_label       = var.subnet_one_dns_label
  freeform_tags = {
  }
  ipv6cidr_block = null
  ipv6cidr_blocks = [
  ]
  prohibit_internet_ingress  = var.subnet_prohibit_internet_ingress
  prohibit_public_ip_on_vnic = var.subnet_prohibit_public_ip_on_vnic
  route_table_id             = oci_core_vcn.test_vcn.default_route_table_id
  security_list_ids = [
    oci_core_vcn.test_vcn.default_security_list_id,
  ]
  vcn_id = oci_core_vcn.test_vcn.id
}

resource "oci_core_subnet" "subnet-two" {
  availability_domain = null
  cidr_block          = var.subnet_two_cidr_block
  compartment_id      = var.compartment_id
  defined_tags = {
  }
  dhcp_options_id = oci_core_vcn.test_vcn.default_dhcp_options_id
  display_name    = var.subnet_two_display_name
  dns_label       = var.subnet_two_dns_label
  freeform_tags = {
  }
  ipv6cidr_block = null
  ipv6cidr_blocks = [
  ]
  prohibit_internet_ingress  = var.subnet_prohibit_internet_ingress_private
  prohibit_public_ip_on_vnic = var.subnet_prohibit_public_ip_on_vnic_private
  route_table_id             = oci_core_route_table.private-route-table.id
  security_list_ids = [
    oci_core_security_list.oke-nodeseclist-kj-test-cluster.id,
  ]
  vcn_id = oci_core_vcn.test_vcn.id
}

resource "oci_core_subnet" "subnet-three" {
  availability_domain = null
  cidr_block          = var.subnet_three_cidr_block
  compartment_id      = var.compartment_id
  defined_tags = {
  }
  dhcp_options_id = oci_core_vcn.test_vcn.default_dhcp_options_id
  display_name    = var.subnet_three_display_name
  dns_label       = var.subnet_three_dns_label
  freeform_tags = {
  }
  ipv6cidr_block = null
  ipv6cidr_blocks = [
  ]
  prohibit_internet_ingress  = var.subnet_prohibit_internet_ingress
  prohibit_public_ip_on_vnic = var.subnet_prohibit_public_ip_on_vnic
  route_table_id             = oci_core_vcn.test_vcn.default_route_table_id
  security_list_ids = [
    oci_core_security_list.oke-k8sApiEndpoint-kj-test-cluster.id,
  ]
  vcn_id = oci_core_vcn.test_vcn.id
}

resource "oci_core_default_dhcp_options" "default-dhcp" {
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name     = var.dhcp_options_display_name
  domain_name_type = var.dhcp_options_domain_name_type
  freeform_tags = {
  }
  manage_default_resource_id = oci_core_vcn.test_vcn.default_dhcp_options_id
  options {
    custom_dns_servers = [
    ]
    search_domain_names = null
    server_type         = var.dhcp_server_type
    type                = var.dhcp_dns_type_custom
  }
  options {
    custom_dns_servers  = null
    search_domain_names = var.dhcp_search_domain_names
    server_type         = var.dhcp_dns_server_type
    type                = var.dhcp_dns_type
  }
}

resource "oci_core_route_table" "private-route-table" {
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name = var.route_table_display_name
  freeform_tags = {
  }
  route_rules {
    description       = var.route_table_route_rules_description_private_igw
    destination       = var.route_table_route_rules_destination_private_igw
    destination_type  = var.route_table_route_rules_destination_type_private_igw
    network_entity_id = oci_core_nat_gateway.test-nat.id
    route_type        = null
  }
  route_rules {
    description       = var.route_table_route_rules_description_private_sg
    destination       = var.route_table_route_rules_destination_private_sg
    destination_type  = var.route_table_route_rules_destination_type_private_sg
    network_entity_id = oci_core_service_gateway.test-service.id
    route_type        = null
  }
  vcn_id = oci_core_vcn.test_vcn.id
}

resource "oci_core_default_route_table" "public-route-table" {
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name = var.default_route_table_display_name_
  freeform_tags = {
  }
  manage_default_resource_id = oci_core_vcn.test_vcn.default_route_table_id
  route_rules {
    description       = var.route_table_route_rules_description_public
    destination       = var.route_table_route_rules_destination_public
    destination_type  = var.route_table_route_rules_destination_type_public
    network_entity_id = oci_core_internet_gateway.test-igw.id
    route_type        = null
  }
}

# service gateway
resource "oci_core_service_gateway" "test-service" {
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name = var.service_gateway_display_name
  freeform_tags = {
  }
  route_table_id = null
  services {
    service_id = var.service_gateway_service_id
  }
  vcn_id = oci_core_vcn.test_vcn.id
}

# nat gateway
resource "oci_core_nat_gateway" "test-nat" {
  block_traffic  = var.nat_gateway_block_traffic
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name = var.nat_gateway_display_name
  freeform_tags = {
  }
  public_ip_id   = null
  route_table_id = null
  vcn_id         = oci_core_vcn.test_vcn.id
}

resource "oci_core_internet_gateway" "test-igw" {
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name = var.internet_gateway_display_name
  enabled      = var.internet_gateway_enabled
  freeform_tags = {
  }
  route_table_id = null
  vcn_id         = oci_core_vcn.test_vcn.id
}


resource "oci_core_security_list" "oke-nodeseclist-kj-test-cluster" {
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name = "kj-oke-nodeseclist"
  egress_security_rules {
    description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
    destination      = "10.0.10.0/24"
    destination_type = "CIDR_BLOCK"
    #icmp_options = null
    protocol  = "all"
    stateless = "false"
    #tcp_options = null
    #udp_options = null
  }
  egress_security_rules {
    description      = "Access to Kubernetes API Endpoint"
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    #icmp_options = null
    protocol  = "6"
    stateless = "false"
    tcp_options {
      max = "6443"
      min = "6443"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  egress_security_rules {
    description      = "Kubernetes worker to control plane communication"
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    #icmp_options = null
    protocol  = "6"
    stateless = "false"
    tcp_options {
      max = "12250"
      min = "12250"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    stateless = "false"
    #tcp_options = null
    #udp_options = null
  }
  egress_security_rules {
    description      = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
    destination      = "all-iad-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    #icmp_options = null
    protocol  = "6"
    stateless = "false"
    tcp_options {
      max = "443"
      min = "443"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  egress_security_rules {
    description      = "ICMP Access from Kubernetes Control Plane"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    stateless = "false"
    #tcp_options = null
    #udp_options = null
  }
  egress_security_rules {
    description      = "Worker Nodes access to Internet"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    #icmp_options = null
    protocol  = "all"
    stateless = "false"
    #tcp_options = null
    #udp_options = null
  }
  freeform_tags = {
  }
  ingress_security_rules {
    description = "Allow pods on one worker node to communicate with pods on other worker nodes"
    #icmp_options = null
    protocol    = "all"
    source      = "10.0.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = null
    #udp_options = null
  }
  ingress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "10.0.0.0/28"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = null
    #udp_options = null
  }
  ingress_security_rules {
    description = "TCP access from Kubernetes Control Plane"
    #icmp_options = null
    protocol    = "6"
    source      = "10.0.0.0/28"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = null
    #udp_options = null
  }
  ingress_security_rules {
    description = "Inbound SSH traffic to worker nodes"
    #icmp_options = null
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  ingress_security_rules {
    #description = null
    #icmp_options = null
    protocol    = "6"
    source      = "10.0.20.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "31292"
      min = "31292"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  ingress_security_rules {
    #description = null
    #icmp_options = null
    protocol    = "6"
    source      = "10.0.20.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "10256"
      min = "10256"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  vcn_id = oci_core_vcn.test_vcn.id
}

resource "oci_core_security_list" "oke-k8sApiEndpoint-kj-test-cluster" {
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name = "kj-oke-k8sApiEndpoint"
  egress_security_rules {
    description      = "Allow Kubernetes Control Plane to communicate with OKE"
    destination      = "all-iad-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    #icmp_options = null
    protocol  = "6"
    stateless = "false"
    tcp_options {
      max = "443"
      min = "443"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  egress_security_rules {
    description      = "All traffic to worker nodes"
    destination      = "10.0.10.0/24"
    destination_type = "CIDR_BLOCK"
    #icmp_options = null
    protocol  = "6"
    stateless = "false"
    #tcp_options = null
    #udp_options = null
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = "10.0.10.0/24"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol  = "1"
    stateless = "false"
    #tcp_options = null
    #udp_options = null
  }
  freeform_tags = {
  }
  ingress_security_rules {
    description = "External access to Kubernetes API endpoint"
    #icmp_options = null
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "6443"
      min = "6443"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  ingress_security_rules {
    description = "Kubernetes worker to Kubernetes API endpoint communication"
    #icmp_options = null
    protocol    = "6"
    source      = "10.0.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "6443"
      min = "6443"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  ingress_security_rules {
    description = "Kubernetes worker to control plane communication"
    #icmp_options = null
    protocol    = "6"
    source      = "10.0.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "12250"
      min = "12250"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  ingress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "10.0.10.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    #tcp_options = null
    #udp_options = null
  }
  vcn_id = oci_core_vcn.test_vcn.id
}

resource "oci_core_default_security_list" "oke-svclbseclist-kj-test-cluster" {
  compartment_id = var.compartment_id
  defined_tags = {
  }
  display_name = "kj-oke-svclbseclist"
  egress_security_rules {
    #description = null
    destination      = "10.0.10.0/24"
    destination_type = "CIDR_BLOCK"
    #icmp_options = null
    protocol  = "6"
    stateless = "false"
    tcp_options {
      max = "31292"
      min = "31292"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  egress_security_rules {
    #description = null
    destination      = "10.0.10.0/24"
    destination_type = "CIDR_BLOCK"
    #icmp_options = null
    protocol  = "6"
    stateless = "false"
    tcp_options {
      max = "10256"
      min = "10256"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  freeform_tags = {
  }
  ingress_security_rules {
    #description = null
    #icmp_options = null
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "3000"
      min = "3000"
      source_port_range {
        max = "65535"
        min = "1"
      }
    }
    #udp_options = null
  }
  manage_default_resource_id = oci_core_vcn.test_vcn.default_security_list_id
}


# resource "oci_identity_policy" "policy_for_autoscaler" {
#   compartment_id = var.compartment_id
#   description    = var.policy_description
#   name           = var.policy_name
#   statements     = ["Allow dynamic-group ${var.dynamic_group} to manage cluster-node-pools in compartment ${var.compartment_name}",
#     "Allow dynamic-group ${var.dynamic_group} to manage instance-family in compartment ${var.compartment_name}",
#     "Allow dynamic-group ${var.dynamic_group} to use subnets in compartment ${var.compartment_name}",
#     "Allow dynamic-group ${var.dynamic_group} to read virtual-network-family in compartment ${var.compartment_name}",
#     "Allow dynamic-group ${var.dynamic_group} to use vnics in compartment ${var.compartment_name}",
#     "Allow dynamic-group ${var.dynamic_group} to inspect compartments in compartment ${var.compartment_name}"
#   ]
#   freeform_tags  = {}
#   version_date   = null
#   defined_tags   = {}
# }

resource "oci_containerengine_cluster" "kj-test-cluster" {
  cluster_pod_network_options {
    cni_type = var.cluster_cluster_pod_network_options_cni_type
  }
  compartment_id = var.compartment_id
  defined_tags   = {}
  endpoint_config {
    is_public_ip_enabled = var.cluster_endpoint_config_is_public_ip_enabled
    nsg_ids              = []
    subnet_id            = oci_core_subnet.subnet-three.id
  }
  freeform_tags = {}
  image_policy_config {
    is_policy_enabled = var.cluster_image_policy_config_is_policy_enabled

    dynamic "key_details" {
      for_each = var.configure_key_details ? [1] : []
      content {
        kms_key_id = var.image_policy_config_kms_key_id
      }
    }
  }
  kms_key_id         = null
  kubernetes_version = var.cluster_kubernetes_version
  name               = var.cluster_name
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.cluster_options_add_ons_is_tiller_enabled
    }
    admission_controller_options {
      is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
    }
    kubernetes_network_config {
      pods_cidr     = var.cluster_options_kubernetes_network_config_pods_cidr
      services_cidr = var.cluster_options_kubernetes_network_config_services_cidr
    }
    persistent_volume_config {
      defined_tags = {
      }
      freeform_tags = {
      }
    }
    service_lb_config {
      defined_tags = {
      }
      freeform_tags = {
      }
    }
    service_lb_subnet_ids = [
      oci_core_subnet.subnet-one.id,
    ]
  }
  type   = "BASIC_CLUSTER"
  vcn_id = oci_core_vcn.test_vcn.id
}

resource "oci_containerengine_node_pool" "export_pool1" {
  cluster_id     = oci_containerengine_cluster.kj-test-cluster.id
  compartment_id = var.compartment_id
  defined_tags = {
  }
  freeform_tags = {
  }
  initial_node_labels {
    key   = var.node_pool_initial_node_labels_key
    value = var.node_pool_initial_node_labels_value
  }
  kubernetes_version = var.node_pool_kubernetes_version
  name               = var.node_pool_name
  node_config_details {

    is_pv_encryption_in_transit_enabled = var.node_pool_node_config_details_is_pv_encryption_in_transit_enabled
    kms_key_id                          = null
    defined_tags                        = {}
    freeform_tags                       = {}

    node_pool_pod_network_option_details {
      cni_type          = var.node_pool_node_config_details_node_pool_pod_network_option_details_cni_type
      max_pods_per_node = var.node_pool_node_config_details_node_pool_pod_network_option_details_max_pods_per_node
      pod_nsg_ids = [
      ]
      pod_subnet_ids = [
        oci_core_subnet.subnet-two.id,
      ]
    }
    nsg_ids = []
    placement_configs {
      availability_domain     = data.oci_identity_availability_domains.ads.availability_domains[0].name
      capacity_reservation_id = null
      fault_domains = [
      ]

      # preemptible_node_config {
      #   #Required
      #   preemption_action {
      #     #Required
      #     type = "TERMINATE"

      #     #Optional
      #     is_preserve_boot_volume = var.node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_is_preserve_boot_volume
      #   }
      # }
      subnet_id = oci_core_subnet.subnet-two.id
    }
    placement_configs {
      availability_domain     = data.oci_identity_availability_domains.ads.availability_domains[1].name
      capacity_reservation_id = null
      fault_domains = [
      ]

      # preemptible_node_config {
      #   #Required
      #   preemption_action {
      #     #Required
      #     type = "TERMINATE"

      #     #Optional
      #     is_preserve_boot_volume = var.node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_is_preserve_boot_volume
      #   }
      # }
      subnet_id = oci_core_subnet.subnet-two.id
    }
    size = "2"
  }
  node_eviction_node_pool_settings {
    eviction_grace_duration              = var.node_pool_node_eviction_node_pool_settings_eviction_grace_duration
    is_force_delete_after_grace_duration = var.node_pool_node_eviction_node_pool_settings_is_force_delete_after_grace_duration
  }
  node_metadata = {}
  node_shape    = var.node_pool_node_shape
  node_shape_config {
    memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
    ocpus         = var.node_pool_node_shape_config_ocpus
  }
  node_source_details {
    boot_volume_size_in_gbs = null
    image_id                = var.node_pool_node_source_details_image_id
    source_type             = var.node_pool_node_source_details_source_type
  }
  node_pool_cycling_details {

    #Optional
    is_node_cycling_enabled = var.node_pool_node_pool_cycling_details_is_node_cycling_enabled
    maximum_surge           = var.node_pool_node_pool_cycling_details_maximum_surge
    maximum_unavailable     = var.node_pool_node_pool_cycling_details_maximum_unavailable
  }
  quantity_per_subnet = var.node_pool_quantity_per_subnet
  ssh_public_key      = var.node_pool_ssh_public_key
  subnet_ids          = var.node_pool_subnet_ids
  lifecycle {
    ignore_changes = [
      node_config_details[0].size
    ]
  }
}
