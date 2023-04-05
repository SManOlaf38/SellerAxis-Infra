import os
import urllib3


def lambda_handler(event, context):
    host = os.environ['API_HOST']
    secret = os.environ['LAMBDA_SECRET']

    for record in event['Records']:
        http = urllib3.PoolManager()
        response = http.request("POST", f"{host}/api/v1/outgoing/po-acknowledgement", body=record["body"], headers={"Content-Type": "application/json", "secret": secret})

        if response.status != 201:
            print("Body:", record["body"])
            print("Response status:", response.status)
            raise Exception("Error")
