// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_core_virtual_network" "MirantisVCN" {
  cidr_block     = "${var.vcn_cidr}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "MirantisVCN"
  dns_label      = "Mirantisvcn"
}

resource "oci_core_internet_gateway" "MirantisIG" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "MirantisIG"
  vcn_id         = "${oci_core_virtual_network.MirantisVCN.id}"
}

resource "oci_core_route_table" "MirantisRT" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.MirantisVCN.id}"
  display_name   = "MirantisRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.MirantisIG.id}"
  }
}

resource "oci_core_security_list" "MirantisSecList" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "MirantisSecList"
  vcn_id         = "${oci_core_virtual_network.MirantisVCN.id}"

  egress_security_rules = [
    {
      protocol    = "all"
      destination = "0.0.0.0/0"
    },
  ]

  ingress_security_rules = [
    {
      protocol = "all"
      source   = "${var.vcn_cidr}"
    },
    {
      protocol = "6"                     # tcp
      source   = "${var.authorized_ips}"

      tcp_options {
        "min" = 22        # to allow SSH acccess to Linux instance
        "max" = 22
      },
    },
    {
      protocol = "1"         # icmp
      source   = "0.0.0.0/0"

      icmp_options {
        "type" = 3
        "code" = 4
      }
    },
  ]
}

resource "oci_core_subnet" "MirantisSubnet" {
  availability_domain = ""
  cidr_block          = "10.3.20.0/24"
  display_name        = "MirantisSubnet"
  dns_label           = "Mirantissubnet"
#  security_list_ids   = ["${oci_core_virtual_network.MirantisVCN.default_security_list_id}"]
  security_list_ids   = ["${oci_core_security_list.MirantisSecList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.MirantisVCN.id}"
  route_table_id      = "${oci_core_route_table.MirantisRT.id}"
  dhcp_options_id     = "${oci_core_virtual_network.MirantisVCN.default_dhcp_options_id}"
}
