variable "oidc_provider_arn" {
  description = "The arn of an EKS's oidc provider"
  type        = string
}

variable "region" {
  description = "The aws region of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID of the EKS's VPC"
  type        = string
}

variable "create_role" {
  description = "Should we create external DNS IAM roles"
  type        = bool
  default     = true
}

variable "create_service_account" {
  description = "Should we create external DNS service account"
  type        = bool
  default     = true
}

variable "create_deployment" {
  description = "Should we create the external DNS IAM roles"
  type        = bool
  default     = true
}

variable "service_account" {
  description = "The name of the service account to use for external DNS"
  type        = string
  default     = "external-dns"
}

variable "namespace" {
  description = "The name of the Kubernetes namespace to use for external DNS"
  type        = string
  default     = "kube-system"
}

variable "zone_id" {
  description = "The ID of the rotue 53 zone to use with external DNS"
  type        = string
}

variable "owner_id" {
  description = "A name that identifies this instance of ExternalDNS"
  type        = string
}

variable "zone_type" {
  description = "The type of rotue 53 zone to use with external DNS"
  type        = string
  default     = "public"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
