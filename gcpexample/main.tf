provider "google" {
  project = "agile-tangent-277907"
  credentials = "~/terraform_gcp.json"
  region  = "europe-west2"
  zone = "europe-west2-c"
}

terraform {
  backend "gcs" {
    bucket  = "harness-terraform"
    credentials = "~/terraform_gcp.json"
    prefix  = "terraform/state"
  }
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}