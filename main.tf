terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.33.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
}

variable "gcp_project_id" {}

resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  database_version = "POSTGRES_14"
  region           = "europe-west2"

  settings {
    tier = "db-f1-micro"
  }
}


resource "random_id" "db_user" {
  byte_length = 8
}

resource "random_id" "db_pass" {
  byte_length = 16
}

resource "google_sql_user" "users" {
  name     = random_id.db_user.hex
  instance = google_sql_database_instance.postgres.name
  password = random_id.db_pass.hex
}

output "postgres_user" {
  value = random_id.db_user.hex
}

output "postgres_password" {
    value = random_id.db_pass.hex
    sensitive = true

}

output "postgres_connection_name" {
    value = google_sql_database_instance.postgres.connection_name
}
