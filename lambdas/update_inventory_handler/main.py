from typing import Any, Dict
import os
from datetime import datetime
import urllib3




def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    # rent("Response:", response.data)
    for record in event['Records']:
        print(record)
        http = urllib3.PoolManager()
        response = http.request("GET", host + "?product_warehouse_static_ids=" + record["body"], headers={"Content-Type": "application/json"})
        print("Response data:", response.data)
        print("Response status:", response.status)