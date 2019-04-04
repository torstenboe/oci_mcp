// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_core_volume" "MCPBlock" {
  count               = "${var.NumInstances}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[count.index % var.nb_ad[var.region]],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "MCPBlock${count.index}"
  size_in_gbs         = "${var.DiskSize}"
}

resource "oci_core_volume_attachment" "MCPBlockAttach" {
  count           = "${var.NumInstances}"
  attachment_type = "iscsi"
  compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.MCPInstance.*.id[count.index]}"
  volume_id       = "${oci_core_volume.MCPBlock.*.id[count.index]}"
  device          = "${count.index == 0 ? var.volume_attachment_device : ""}"

  # Set this to enable CHAP authentication for an ISCSI volume attachment. The oci_core_volume_attachment resource will
  # contain the CHAP authentication details via the "chap_secret" and "chap_username" attributes.
  #use_chap = true

  # Set this to attach the volume as read-only.
  #is_read_only = true
}
