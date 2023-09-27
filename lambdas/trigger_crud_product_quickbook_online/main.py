import base64
from typing import Any, Dict
import os
from datetime import datetime
import urllib3
import json

def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    for record in event['Records']:
        print(record)
        method = None
        record_data = json.loads(record["body"])
        if record_data.get("action") is not None:
            if record_data.get("action").upper() == "CREATE":
                method = "POST"
            elif record_data.get("action").upper() == "UPDATE":
                method = "PATCH"
            elif record_data.get("action").upper() == "DELETE":
                method = "DELETE"

        encoded_data = json.dumps(record_data).encode("utf-8")

        if method is not None:
            http = urllib3.PoolManager()
            response = http.request(method, host, headers={"Content-Type": "application/json"}, body=encoded_data,)
            print("Response data:", response.data)
            print("Response status:", response.status)