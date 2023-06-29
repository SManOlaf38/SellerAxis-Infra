from typing import Any, Dict
import os
from datetime import datetime
import urllib3




def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    http = urllib3.PoolManager()
    response = http.request("POST", f"{host}",  headers={"Content-Type": "application/json"})
    print("Response status:", response.status)
    print("Response:", response.data)