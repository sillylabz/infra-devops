output "vm_uuid" {
    value = vsphere_virtual_machine.virt_machine.*.id
}

output "vm_name" {
    value = vsphere_virtual_machine.virt_machine.*.name
}


output "vm_ipAddresses" {
    value = vsphere_virtual_machine.virt_machine.*.default_ip_address
}
