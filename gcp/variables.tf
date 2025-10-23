variable "bucket_name" {
  description = "Name of the GCS bucket to host the static site"
  type        = string
}

variable "function_name" { 
  type = string
}
variable "function_bucket_name" { 
  type = string
}
variable "function_object_name" { 
  type = string
}
variable "api_id" { 
  type = string
}
variable "gateway_id" { 
  type = string
}
variable "api_title" { 
  type = string
}
variable "region" { 
  type = string
}