Landing Zone and Harden it with Security Command Center 


mkdir -p ~/shared-vpc


git clone https://github.com/terraform-google-modules/terraform-google-vm.git


terraform init && terraform apply -auto-approve



git clone https://github.com/terraform-google-modules/terraform-google-vm.git
cd ~/terraform-google-vm/examples/compute_instance/simpl

____________________

MAIN.TF
---------------------


/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 13.0"

  region             = var.region
  project_id         = var.project_id
  subnetwork         = var.subnetwork
  subnetwork_project = var.subnetwork_project
  service_account    = var.service_account

  metadata = {
    serial-port-enable = "FALSE"
  }
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "~> 14.0"

  project_id          = var.project_id
  region              = var.region
  zone                = var.zone
  subnetwork          = var.subnetwork
  subnetwork_project  = var.subnetwork_project
  num_instances       = var.num_instances
  hostname            = "cymbal-instance"
  instance_template   = module.instance_template.self_link
  deletion_protection = false
}




VARIABLE.TF 


/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "subnetwork_project" {
  description = "The GCP project that contains the subnetwork"
  type        = string
  default     = "host project" --<Enter host project id>
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "us-east1"
}

variable "zone" {
  description = "The GCP zone to create resources in"
  type        = string
  default     = null
}

variable "subnetwork" {
  description = "The subnetwork selflink to host the compute instances in"
  type        = string
  default     = "projects/<host_project>/regions/us-east1/subnetworks/shared-network-subnet-01"
}

variable "num_instances" {
  description = "Number of instances to create"
  type        = number
}

variable "nat_ip" {
  description = "Public ip address"
  type        = string
  default     = null
}

variable "network_tier" {
  description = "Network network_tier"
  type        = string
  default     = "PREMIUM"
}

variable "service_account" {
  default = null

  type = object({
    email  = string
    scopes = set(string)
  })

  description = "Service account to attach to the instance."
}




________________

terraform init
