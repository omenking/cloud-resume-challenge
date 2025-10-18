provider "google" {
  project     = "cloud-resume-challenge-475514"
  region      = "us-east1"
}

resource "google_storage_bucket" "static-site" {
  name          = var.bucket_name
  location      = "US-EAST1"
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