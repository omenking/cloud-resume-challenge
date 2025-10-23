import os, json, time, logging
import azure.functions as func
from azure.cosmos import CosmosClient, exceptions

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

# ---- Config (aligns to your Bicep names) ----
COSMOS_ENDPOINT = os.getenv("COSMOS_ENDPOINT")                 # e.g. https://<account>.documents.azure.com:443/
COSMOS_KEY = os.getenv("COSMOS_KEY")                           # Primary key
COSMOS_DB = os.getenv("COSMOS_DB_NAME", "viewCounterDb")       # matches databaseName
COSMOS_CONTAINER = os.getenv("COSMOS_CONTAINER", "counter")    # matches containerName
COUNTER_ID = os.getenv("COUNTER_PK", "global")                 # single doc id == partition key (since /id)
MAX_RETRIES = int(os.getenv("INCR_RETRIES", "5"))

def _container():
    if not COSMOS_ENDPOINT or not COSMOS_KEY:
        raise RuntimeError("Set COSMOS_ENDPOINT and COSMOS_KEY.")
    client = CosmosClient(COSMOS_ENDPOINT, COSMOS_KEY)
    db = client.get_database_client(COSMOS_DB)
    return db.get_container_client(COSMOS_CONTAINER)

def _ensure_item(c):
    try:
        return c.read_item(item=COUNTER_ID, partition_key=COUNTER_ID)
    except exceptions.CosmosResourceNotFoundError:
        try:
            c.create_item({"id": COUNTER_ID, "count": 0})
        except exceptions.CosmosHttpResponseError:
            pass
        return c.read_item(item=COUNTER_ID, partition_key=COUNTER_ID)

def _json(status: int, body: dict):
    return func.HttpResponse(json.dumps(body), status_code=status, mimetype="application/json")

def get_count_logic():
    cont = _container()
    item = _ensure_item(cont)
    return _json(200, {"count": int(item.get("count", 0) or 0)})

def increment_logic():
    cont = _container()
    for attempt in range(MAX_RETRIES):
        item = _ensure_item(cont)
        etag = item.get("_etag")
        new_val = int(item.get("count", 0) or 0) + 1
        item["count"] = new_val
        try:
            # ETag-based optimistic concurrency (Cosmos SDK: use if_match header)
            cont.replace_item(item=item, body=item, if_match=etag)
            return _json(200, {"count": new_val})
        except exceptions.CosmosHttpResponseError as e:
            # 412 = Precondition Failed (ETag mismatch)
            if getattr(e, "status_code", None) == 412 and attempt < MAX_RETRIES - 1:
                time.sleep(0.05 * (2 ** attempt))
                continue
            logging.warning("Increment conflict or error: %s", e)
            latest = _ensure_item(cont)
            return _json(200, {"count": int(latest.get("count", 0) or 0)})
    latest = _ensure_item(cont)
    return _json(200, {"count": int(latest.get("count", 0) or 0)})

@app.route(route="view_counter", auth_level=func.AuthLevel.ANONYMOUS)
def view_counter(req: func.HttpRequest) -> func.HttpResponse:
    try:
        if req.method == "GET":
            return get_count_logic()
        if req.method == "POST":
            return increment_logic()
        return _json(405, {"error": "Method Not Allowed"})
    except Exception as e:
        logging.exception("Unhandled error")
        return _json(500, {"error": "Internal Server Error", "detail": str(e)})
