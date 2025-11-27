terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  
  # 🔹 옵션 1: 로컬 State (간단, 개인 작업)
  # backend 설정 없음 - 로컬에 terraform.tfstate 저장
  
  # 🔹 옵션 2: 원격 State (팀 협업, 권장)
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "tfstateyoung2024"
  #   container_name       = "tfstate-container"
  #   key                  = "azure-dr/terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}