from typing import Any, Dict
import os
import json
import urllib3



def lambda_handler(event: Dict[str, Any], context):
    host = os.environ['API_HOST']
    for record in event['Records']:
        print(record)
        data = json.loads(record["body"])
        for d in data:
            retailer_id = d['retailer_id']
            http = urllib3.PoolManager()
            res = http.request("GET", host + f"/retailers/{retailer_id}/sqs-inventory-xml",
                               fields={"product_alias_ids": d["product_alias_ids"]})
            print(res.status)
            print(res.data)
