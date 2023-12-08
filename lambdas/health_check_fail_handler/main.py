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
    send_slack_notification(f":bomb::bomb::bomb: Bớ bà con, sập server {env}. Ới ới ới… :dizzy_face:")

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
