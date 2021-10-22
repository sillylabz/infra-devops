
resource "esxi_guest" "vmtest02" {
  guest_name = "vmtest02"
  guestos    = "centos8_64Guest"
  disk_store = "vmData1"

  boot_disk_type = "thin"
  boot_disk_size = "20"

  memsize            = "2048"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  //   clone_from_vm = "base-centos8"
  ovf_source = "/Users/admin/Downloads/base-cento8/CentOS_8.3.2011_VMM_LinuxVMImages.ovf"

  network_interfaces {
    virtual_network = var.esxi_vm_network
  }

//   provisioner "file" {
//     source      = "${path.module}/vm-ifcfg-eth0.cfg"
//     destination = "/etc/sysconfig/network-scripts/ifcfg-ens33"
//     connection {
//       type     = "ssh"
//       user     = "root"
//       password = "root"
//       host     = esxi_guest.vmtest02.ip_address
//     }
//   }

//   provisioner "remote-exec" {
//     inline = [
//       "sleep 5",
//       "shutdown -r 5"
//     ]
//   }
//   connection {
//     type     = "ssh"
//     user     = "root"
//     password = "root"
//     host     = esxi_guest.vmtest02.ip_address
//   }
}


// resource "esxi_guest" "vmtest03" {
//   guest_name = "vmtest03"
//   disk_store = "vmData1"

//   boot_disk_type = "thin"
//   boot_disk_size = "20"

//   memsize            = "2048"
//   numvcpus           = "1"
//   resource_pool_name = "/"
//   power              = "on"

// //   clone_from_vm = "base-centos8"
//   ovf_source        = "/Users/admin/Downloads/base-cento8/CentOS_8.3.2011_VMM_LinuxVMImages.ovf"

//   network_interfaces {
//     virtual_network = var.esxi_vm_network
//   }
// }

// resource "esxi_guest" "vmtest04" {
//   guest_name = "vmtest04"
//   disk_store = "vmData1"

//   boot_disk_type = "thin"
//   boot_disk_size = "20"

//   memsize            = "2048"
//   numvcpus           = "1"
//   resource_pool_name = "/"
//   power              = "on"

// //   clone_from_vm = "base-centos8"
//   ovf_source        = "/Users/admin/Downloads/base-cento8/CentOS_8.3.2011_VMM_LinuxVMImages.ovf"

//   network_interfaces {
//     virtual_network = var.esxi_vm_network
//   }
// }
