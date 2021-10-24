output "vm_uuid" {
    value = vsphere_virtual_machine.virtual_machine.*.id
}

output "vm_name" {
    value = vsphere_virtual_machine.virtual_machine.*.name
}


output "vm_ipAddresses" {
    value = vsphere_virtual_machine.virtual_machine.*.default_ip_address
}
