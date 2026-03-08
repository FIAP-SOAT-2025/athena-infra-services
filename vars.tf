variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "us-east-1"
}

variable "projectName" {
  description = "The name of the project"
  default     = "tc5-g192-athena-v1-felipe"
}

variable "videos_bucket_name" {
  description = "S3 bucket used to store Athena videos."
  type        = string
  default     = "athena-videos-tc5-g192-v1-felipe"
}

variable "remote_state_bucket_name" {
  description = "S3 bucket name containing shared Terraform remote states (db/infra)."
  type        = string
  default     = "terraform-state-tc5-g192-athena-v1-felipe"
}

variable "use_db_remote_state" {
  description = "When true, reads database host/port from db remote state."
  type        = bool
  default     = false
}

variable "use_infra_remote_state" {
  description = "When true, reads infra remote state data sources."
  type        = bool
  default     = false
}

variable "db_port" {
  description = "Database port used when use_db_remote_state is false."
  type        = number
  default     = 5432
}

variable "db_service_name" {
  description = "Nome do service do banco de dados"
  type        = string
  default     = "postgres-db-service"
}

variable "db_namespace" {
  description = "Namespace do banco de dados"
  type        = string
  default     = "athena-db"
}

variable "db_user" {
  description = "O nome de usuário para o banco de dados RDS."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "A senha para o usuário do banco de dados RDS."
  type        = string
  sensitive   = true
}

variable "access_token" {
  description = "O Access Token para integração com APIs externas."
  type        = string
  sensitive   = true
}


variable "db_name" {
  description = "O nome do banco de dados inicial a ser criado na instância RDS."
  type        = string
}

variable "jwt_secret" {
  description = "Secret key for JWT authentication."
  type        = string
  sensitive   = true
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID for S3 access."
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key for S3 access."
  type        = string
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS Session Token for S3 access."
  type        = string
  sensitive   = true
  default     = ""
}
