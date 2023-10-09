import os
import json
import gzip
import base64
import urllib3


slack_webhook_host = os.environ['SLACK_WEBHOOK_HOST']
env = os.environ['ENV']


def process_event(event: dict) -> dict:
    decoded_payload = base64.b64decode(event.get("awslogs").get("data"))
    uncompressed_payload = gzip.decompress(decoded_payload)
    payload = json.loads(uncompressed_payload)
    return payload
    
    
def send_slack_notification(message: str):
    http = urllib3.PoolManager()
    http.request(
        "POST",
        slack_webhook_host,
        body=json.dumps({
            "channel": "#seller-axis-exceptions",
            "username": f"exception-bot-{env}",
            "text": message,
            "icon_emoji": ":ghost:"
        }).encode("utf-8"),
    )


def lambda_handler(event, context):
    send_slack_notification(f"Bug {env} nè\n```" + "\n".join([event["message"] for event in process_event(event)["logEvents"]]) + "```")

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
