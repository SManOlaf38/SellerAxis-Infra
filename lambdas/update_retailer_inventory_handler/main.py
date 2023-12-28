from typing import Any, Dict
import os
from datetime import datetime
import urllib3
import boto3




def lambda_handler(event: Dict[str, Any], context):
    sqs_name = os.environ['UPDATE_INDIVIDUAL_RETAILER_INVENTORY_SQS_NAME']
    host = os.environ['API_HOST']
    secret_key = os.environ['LAMBDA_SECRET']
    print(f"{sqs_name=}")
    sqs = boto3.client('sqs')
    queue_url = sqs.get_queue_url(QueueName=sqs_name)['QueueUrl']
    for record in event['Records']:
        print(record)
        retailer_ids = record["body"].split(',')
        if len(retailer_ids)==1:
            retailer_id = retailer_ids[0]
            http = urllib3.PoolManager()
            response = http.request("GET", host + retailer_id + "/inventory-xml", headers={"Content-Type": "application/json", "Authorization": str(secret_key)})
            print("Response data:", response.data)
            print("Response status:", response.status) 
        else:
            for retailer_id in retailer_ids:
                print(f"{retailer_id=}")
                sqs.send_message(QueueUrl=queue_url, MessageBody=retailer_id)