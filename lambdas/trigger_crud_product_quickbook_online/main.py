import base64
from typing import Any, Dict
import os
from datetime import datetime
import urllib3
import json

# def decode_data(data_encode: str) -> str:
#     string_data = base64.b64decode(data_encode).decode("utf-8")
#     return string_data

def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    # rent("Response:", response.data)
    for record in event['Records']:
        print(record)
        method = None
        record_data = json.loads(record["body"])
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
