variable "location" {
  description = "Azure region"
  type        = string
  default     = "uksouth"
}

variable "project_name" {
  description = "Project name prefix (lowercase letters/numbers, short)"
  type        = string
  default     = "platformdemo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
