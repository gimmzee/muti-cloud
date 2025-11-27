# ------------------------------
# Variables
# ------------------------------
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  # 실행 시: export TF_VAR_subscription_id="7adc47d6-5071-4675-9c57-70443589cb62"
}

variable "location" {
  description = "Azure region for DR"
  type        = string
  default     = "koreacentral"  # 소문자, 공백 없이
}

variable "vm_size" {
  description = "VM Size (Free Tier: B1s)"
  type        = string
  default     = "Standard_B1s"  # Free Tier: 750시간/월 무료
  # 참고: B1ls는 더 저렴하지만 성능이 매우 낮음
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  # Windows: "C:/Users/soldesk/.ssh/id_rsa.pub"
  # Linux/Mac: "~/.ssh/id_rsa.pub"
}