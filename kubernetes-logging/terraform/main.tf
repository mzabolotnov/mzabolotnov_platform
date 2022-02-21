provider "yandex" {
  token                    = var.token
  # service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  
}

resource "yandex_kubernetes_cluster" "cluster" {
  name                    = "logging"
  description             = "kubernetes-logging"
  folder_id               = var.folder_id
  network_id              = var.network_id
  service_account_id      = var.service_account_id
  node_service_account_id = var.node_service_account_id
  release_channel         = "RAPID"
  


  master {
    version   = "1.19"
    public_ip = true
    zonal {
      zone                     = var.zone
      subnet_id                = var.subnet_id
  
        }

    }
}
resource "yandex_kubernetes_node_group" "infra-pool" {
  
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  name        = "infra-pool"
  description = "logging infra-pool"
  version     = "1.19"
  
  instance_template {
    
    platform_id = "standard-v2"
    nat         = true
    metadata    = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    
  }
  

    resources {
      cores         = 2
      core_fraction = 50
      memory        = 4
    }
    boot_disk {
      
      size = 30
      
    }
    
}
  scale_policy  {
    fixed_scale {
      size = 3
    }
      }
   
   
}

resource "yandex_kubernetes_node_group" "default-pool" {
  
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  name        = "default-pool"
  description = "default-pool"
  version     = "1.19"
  
  instance_template {
    
    platform_id = "standard-v2"
    nat         = true
    metadata    = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    
  }
  

    resources {
      cores         = 2
      core_fraction = 50
      memory        = 2
    }
    boot_disk {
      
      size = 30
      
    }
    
}
  scale_policy  {
    fixed_scale {
      size = 1
    }
      }
   
   
}




