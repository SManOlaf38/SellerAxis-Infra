import os
import json
import urllib3


slack_webhook_host = os.environ['SLACK_WEBHOOK_HOST']
env = os.environ['ENV']
    
    
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
    send_slack_notification(f":money_with_wings::money_with_wings::money_with_wings: Ới ới ới, hết tiền, hết tiền :money_with_wings::money_with_wings::money_with_wings: ")

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
