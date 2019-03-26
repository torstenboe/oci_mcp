// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "null_resource" "remote-exec" {
  depends_on = ["oci_core_instance.MCPInstance", "oci_core_volume_attachment.MCPBlockAttach"]
  count      = "${var.NumInstances * var.NumIscsiVolumesPerInstance}"

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${oci_core_instance.MCPInstance.*.public_ip[count.index % var.NumInstances]}"
      user        = "opc"
      private_key = "${var.ssh_private_key}"
    }

    inline = [
      "touch ~/IMadeAFile.Right.Here",
      "sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.MCPBlockAttach.*.iqn[count.index]} -p ${oci_core_volume_attachment.MCPBlockAttach.*.ipv4[count.index]}:${oci_core_volume_attachment.MCPBlockAttach.*.port[count.index]}",
      "sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.MCPBlockAttach.*.iqn[count.index]} -n node.startup -v automatic",
      "echo sudo iscsiadm -m node -T ${oci_core_volume_attachment.MCPBlockAttach.*.iqn[count.index]} -p ${oci_core_volume_attachment.MCPBlockAttach.*.ipv4[count.index]}:${oci_core_volume_attachment.MCPBlockAttach.*.port[count.index]} -l >> ~/.bashrc",
    ]
  }
}
