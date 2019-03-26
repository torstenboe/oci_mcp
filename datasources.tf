// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

data "oci_identity_availability_domain" "ad" {
  compartment_id = "${var.tenancy_ocid}"
  ad_number      = 1
}

# Gets the boot volume attachments for each instance
data "oci_core_boot_volume_attachments" "DCOSBootVolumeAttachments" {
  depends_on          = ["oci_core_instance.DCOSInstance"]
  count               = "${var.NumInstances}"
  availability_domain = "${oci_core_instance.DCOSInstance.*.availability_domain[count.index]}"
  compartment_id      = "${var.compartment_ocid}"

  instance_id = "${oci_core_instance.DCOSInstance.*.id[count.index]}"
}

data "oci_core_instance_devices" "DCOSInstanceDevices" {
  instance_id = "${oci_core_instance.DCOSInstance.*.id[count.index]}"
}
