from typing import Any, Dict
import os
import json
import urllib3



def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    secret_key = os.environ['LAMBDA_SECRET']

    for record in event['Records']:
        print(record)
        org = record["body"]
        http = urllib3.PoolManager()
        response = http.request(
            "POST", host + f"/qbo-unhandled-data/rehandle",
            headers={
              "organization": org,
              "Authorization": str(secret_key)
            }
        )
        
        print("Response data:", response.data)
        print("Response status:", response.status)
