provider "google" {
  project     = "cloud-resume-challenge-475514"
  region      = var.region
}

terraform { 
  cloud { 
    organization = "ExamPro" 
    workspaces { 
      name = "gcs-andrewbrownresumeorg" 
    } 
  } 
}

resource "google_storage_bucket" "static_site" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  /*
  cors {
    origin          = ["http://image-store.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  cors {
    origin            = ["http://image-store.com"]
    method            = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header   = ["*"]
    max_age_seconds   = 0
  }
  */
}

resource "google_storage_bucket_iam_binding" "public_access" {
  bucket = google_storage_bucket.static_site.name

  role = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

resource "google_cloudfunctions2_function" "fn" {
  name        = var.function_name
  location    = var.region
  description = "CRC View Counter"

  build_config {
    runtime     = "ruby34"           # Ruby runtime ID
    entry_point = "hello_http"       # function name in app.rb
    source {
      storage_source {
        bucket = var.function_bucket_name
        object = var.function_object_name
      }
    }
  }

  service_config {
    available_memory                 = "256M"
    timeout_seconds                  = 30
    ingress_settings                 = "ALLOW_ALL"
    max_instance_request_concurrency = 10
  }

  depends_on = [google_project_service.services]
}


resource "google_service_account" "gw_caller" {
  account_id   = "apigw-caller"
  display_name = "API Gateway backend caller"
}

resource "google_cloudfunctions2_function_iam_member" "invoker_for_gateway" {
  location       = var.region
  cloud_function = google_cloudfunctions2_function.fn.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${google_service_account.gw_caller.email}"
}

resource "google_api_gateway_api" "api" {
  api_id = var.api_id
}

locals {
  backend_url = google_cloudfunctions2_function.fn.url
}

resource "google_api_gateway_api_config" "api_cfg" {
  api                  = google_api_gateway_api.api.api_id
  api_config_id_prefix = "${var.api_id}-cfg"

  # Pass the rendered OpenAPI as base64
  openapi_documents {
    document {
      path     = "openapi.yaml"
      contents = base64encode(templatefile("${path.module}/openapi.yaml.tmpl", {
        TITLE        = var.api_title
        BACKEND_URL  = local.backend_url
        AUDIENCE     = local.backend_url
      }))
    }
  }
  # Tell the gateway which SA to use to sign ID tokens for the backend
  gateway_config {
    backend_config {
      google_service_account = google_service_account.gw_caller.email
    }
  }

  depends_on = [
    google_cloudfunctions2_function.fn,
    google_cloudfunctions2_function_iam_member.invoker_for_gateway
  ]
}

resource "google_api_gateway_gateway" "gw" {
  gateway_id = var.gateway_id
  api_config = google_api_gateway_api_config.api_cfg.id
  region     = var.region
}

output "curl_through_gateway" {
  value = "curl https://${google_api_gateway_gateway.gw.default_hostname}/v1/hello"
}

output "gateway_default_hostname" {
  value = google_api_gateway_gateway.gw.default_hostname
}