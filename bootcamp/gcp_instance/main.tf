resource "google_compute_network" "bootcamp_vpc_network" {
  name = "bootcamp-terraform-network"
}

resource "google_compute_firewall" "bootcamp_firewall" {
    name    = "bootcamp-firewall"
    network = google_compute_network.bootcamp_vpc_network.name
    
    allow {
        protocol = "tcp"
        ports    = ["22","80","443"]
    }
    
    allow {
        protocol = "icmp"
    }
}

resource "google_compute_instance" "bootcamo_demo_vm_instance" {
  name         = "bootcamp-demo-vm-instance"
  machine_type = "f1-micro"
  tags         = ["bootcamp-demo-vm-instance"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  metadata = {
    ssh-keys = var.ssh_pub_user
  }
  network_interface {
    network = google_compute_network.bootcamp_vpc_network.name
    access_config {
    }
  }
}