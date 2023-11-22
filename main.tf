terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.33.0"
    }
  }
}

provider "google" {}

resource "google_sql_database_instance" "postgres" {
  name             = var.cloudsql_instance_name
  database_version = "POSTGRES_14"
  region           = "europe-west2"

  settings {
    tier = var.instance_size
  }
}

resource "random_id" "db_user" {
  byte_length = 8
}

resource "random_id" "db_pass" {
  byte_length = 16
}

resource "random_pet" "name" {}


resource "google_sql_user" "users" {
  name     = random_id.db_user.hex
  instance = google_sql_database_instance.postgres.name
  password = random_id.db_pass.hex
}

variable "cloudsql_instance_name" {
   default = "db-dev-${random_pet.name.id}"
}

variable "instance_size" {
   default = "db-f1-micro"
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
