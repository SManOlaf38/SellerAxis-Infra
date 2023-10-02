from typing import Any, Dict
import os
import json
import urllib3



def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    for record in event['Records']:
        print(record)
        org = record["body"]
        http = urllib3.PoolManager()
        res = http.request("GET", host + f"/qbo-unhandled-data/rehandle",
                           headers={
                             "organization": org
                           })

