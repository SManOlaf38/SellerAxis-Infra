from typing import Any, Dict
import os
from datetime import datetime
import urllib3
import boto3




def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    secret_key = os.environ['LAMBDA_SECRET']
    print("lambda called")
    print(f"{event=}")
    print(f"{host=}")
    
    # rent("Response:", response.data)
    for record in event['Records']:
        print(record)
        retailer_id = record["body"]
        http = urllib3.PoolManager()
        response = http.request("GET", host + retailer_id + "/inventory-xml", headers={"Content-Type": "application/json", "Authorization": str(secret_key)})
        print("Response data:", response.data)
        print("Response status:", response.status)