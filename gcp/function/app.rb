require "json"
require "functions_framework"
require "google/cloud/firestore"

# ======================
# Config (via ENV)
# ======================
COLLECTION_NAME = ENV.fetch("COLLECTION_NAME", "counter")
COUNTER_PK      = ENV.fetch("COUNTER_PK", "global")

# CORS:
# - If CORS_ALLOWED_ORIGINS="*"  -> always "*"
# - If CORS_ALLOWED_ORIGINS="https://a.com,https://b.com" -> reflect the request's Origin when it matches
CORS_ALLOWED_ORIGINS = (ENV["CORS_ALLOWED_ORIGINS"] || "*").strip
CORS_ALLOW_HEADERS   = ENV.fetch("CORS_ALLOW_HEADERS", "Content-Type,Authorization")
CORS_ALLOW_METHODS   = ENV.fetch("CORS_ALLOW_METHODS", "GET,POST,OPTIONS")
CORS_MAX_AGE         = ENV.fetch("CORS_MAX_AGE", "3600")

# ======================
# Clients (reused)
# ======================
FIRESTORE = Google::Cloud::Firestore.new

# ======================
# Helpers
# ======================
def allowed_origin_for(request_origin)
  return "*" if CORS_ALLOWED_ORIGINS == "*"

  allowed = CORS_ALLOWED_ORIGINS.split(",").map(&:strip).reject(&:empty?)
  if request_origin && allowed.include?(request_origin)
    request_origin
  else
    nil
  end
end

def cors_headers(request)
  origin = request.get_header("HTTP_ORIGIN")
  ao = allowed_origin_for(origin)

  headers = {
    "Access-Control-Allow-Methods" => CORS_ALLOW_METHODS,
    "Access-Control-Allow-Headers" => CORS_ALLOW_HEADERS,
    "Access-Control-Max-Age"       => CORS_MAX_AGE
  }

  if ao
    headers["Access-Control-Allow-Origin"] = ao
    headers["Vary"] = "Origin" unless ao == "*"
  end

  headers
end

def json_response(request, status, body_hash)
  base = { "Content-Type" => "application/json" }
  [status, base.merge(cors_headers(request)), [JSON.dump(body_hash)]]
end

def no_content_response(request)
  [204, cors_headers(request), []]
end

def doc_ref
  FIRESTORE.col(COLLECTION_NAME).doc(COUNTER_PK)
end

def get_count(request)
  snapshot = doc_ref.get
  count = snapshot.exists? ? (snapshot[:count] || 0).to_i : 0
  json_response(request, 200, { count: count })
end

def increment(request)
  new_value = nil

  FIRESTORE.transaction do |tx|
    snap = tx.get doc_ref
    if snap.exists?
      # Atomic increment; compute return value from snapshot
      current = (snap[:count] || 0).to_i
      tx.update doc_ref, { count: Google::Cloud::Firestore::FieldValue.increment(1) }
      new_value = current + 1
    else
      tx.set doc_ref, { count: 1 }
      new_value = 1
    end
  end

  json_response(request, 200, { count: new_value })
end

# ======================
# HTTP Entry Point
# ======================
FunctionsFramework.http "hello_http" do |request|
  # Handle CORS preflight early
  if request.request_method == "OPTIONS"
    next no_content_response(request)
  end

  case request.request_method
  when "GET"  then get_count(request)
  when "POST" then increment(request)
  else
    json_response(request, 405, { error: "Method Not Allowed" })
  end
end
