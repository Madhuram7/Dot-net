variable "rg_name" {
    type = string

}


variable "rg_location" {
    type = string

}

########## ACR Variable ###########

variable "acr_name" {
    type = string
    
}

variable "acr_sku" {
    type = string
    
}


variable "vnet_name" {
    type = string
    
}

variable "environment" {
    type = string
    
}



variable "subnet_name" {
    type = string
    
}


########## AKS Variable ###########

variable "aks_vm_size" {
    type = string
    
}


variable "aks_name" {
    type = string
    
}

variable "aks_node_count" {
    type = number
    
}
