from typing import Any, Dict
import os
from datetime import datetime
import urllib3
import json


def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    # rent("Response:", response.data)
    secret_key = os.environ['LAMBDA_SECRET']
    for record in event['Records']:
        print(record)
        try:
            if type(json.loads(record["body"])) is dict:
                trigger_all = True
            else:
                trigger_all = False
        except json.decoder.JSONDecodeError:
            trigger_all = False
            
        if trigger_all:
            http = urllib3.PoolManager()
            response = http.request("GET", host, headers={"Content-Type": "application/json", "Authorization": str(secret_key)})
        else:
            http = urllib3.PoolManager()
            response = http.request("GET", host + "?product_warehouse_static_ids=" + record["body"], headers={"Content-Type": "application/json", "Authorization": str(secret_key)})
            
        print("Response data:", response.data)
        print("Response status:", response.status)
