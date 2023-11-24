from typing import Any, Dict
import os
import urllib3


def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    secret_key = os.environ['LAMBDA_SECRET']
    method = "GET"
    http = urllib3.PoolManager()
    response = http.request(method, host, headers={"Content-Type": "application/json", "Authorization": str(secret_key)},)
    print("Response data:", response.data)
    print("Response status:", response.status)