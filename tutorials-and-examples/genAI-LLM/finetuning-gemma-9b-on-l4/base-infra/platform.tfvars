# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##common variables
project_id        = "akvelon-gke-aieco"
cluster_name      = "akamalov-test"
cluster_location  = "us-central1"
private_cluster   = false ## true = private cluster, false = public cluster
autopilot_cluster = false ## true = autopilot cluster, false = standard cluster

#######################################################
####    PLATFORM
#######################################################
## network values
create_network    = false
network_name      = "default"
subnetwork_name   = "default"
subnetwork_region = "us-central1"
subnetwork_cidr   = "10.100.0.0/16"

cpu_pools = [{
  name         = "cpu-pool"
  machine_type = "n1-standard-16"
  autoscaling  = true
  min_count    = 1
  max_count    = 3
  enable_gcfs  = true
  disk_size_gb = 100
  disk_type    = "pd-standard"
}]

## make sure required gpu quotas are available in that region
enable_gpu = true
gpu_pools = [
  {
    name               = "gpu-pool-l4"
    machine_type       = "a2-highgpu-1g"
    node_locations     = "us-central1-a" ## comment to autofill node_location based on cluster_location
    autoscaling        = true
    min_count          = 1
    max_count          = 3
    disk_size_gb       = 100
    disk_type          = "pd-balanced"
    enable_gcfs        = true
    logging_variant    = "DEFAULT"
    accelerator_count  = 1
    accelerator_type   = "nvidia-tesla-a100"
    gpu_driver_version = "DEFAULT"
}]



