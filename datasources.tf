// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

/*
# Gets the boot volume attachments for each instance
data "oci_core_boot_volume_attachments" "DCOSBootVolumeAttachments" {
  depends_on          = ["oci_core_instance.MCPInstance"]
  count               = "${var.NumInstances}"
  availability_domain = "${oci_core_instance.MCPInstance.*.availability_domain[count.index]}"
  compartment_id      = "${var.compartment_ocid}"

  instance_id = "${oci_core_instance.MCPInstance.*.id[count.index]}"
}

data "oci_core_instance_devices" "MCPInstanceDevices" {
  instance_id = "${oci_core_instance.MCPInstance.*.id[count.index]}"
}
*/
