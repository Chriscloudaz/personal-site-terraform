variable "prefix" {
  type        = string
  description = "Prefix for file names."
  default     = "parbsol"
}

variable "region" {
  type        = string
  description = "The AWS region."
  default     = "eu-north-1"
}

variable "cluster_issuer_email" {
  description = "Email for the cluster issuer"
  type        = string
  default     = "chris@parbtechsolutions.com"
}

variable "cluster_issuer_name" {
  description = "Name for the cluster issuer"
  type        = string
  default     = "cert-manager-global"
}

variable "cluster_issuer_private_key_secret_name" {
  description = "Name of the secret holding the private key for the issuer"
  type        = string
  default     = "cert-manager-private-key"
}
