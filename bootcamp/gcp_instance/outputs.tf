output "publicip" {
    value = google_compute_instance.bootcamo_demo_vm_instance.network_interface.0.access_config.0.nat_ip
    sensitive = true
}