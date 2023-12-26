import base64
from typing import Any, Dict
import os
from datetime import datetime
import urllib3
import json
import boto3
import uuid
import json

s3 = boto3.client('s3')
athena_client = boto3.client('athena')


def lambda_handler(event: Dict[str, Any], context):
    bucket_name = os.environ['HISTORY_BUCKET']

    database_name = os.environ['DB_NAME']
    table_name = os.environ['TABLE_NAME']
    work_group = os.environ['WORK_GROUP']

    for record in event['Records']:
        record_data = json.loads(record["body"])
        if record_data.get("history_item_type"):

            current_time = datetime.utcfromtimestamp(record_data.get("created_at"))
            current_day = current_time.day
            current_month = current_time.month
            current_year = current_time.year

            author_id = str(record_data.get("author_id")) if record_data.get("author_id") else "system"
            request_uuid = "system"
            request_data = None
            if record_data.get("request_data") is not None:
                request_data = json.dumps(record_data.get("request_data"))
                request_uuid = record_data.get("request_data").get("request_uuid")
            process_data = None
            if record_data.get("process_data") is not None and len(record_data.get("process_data")) > 0:
                process_data = json.dumps(record_data.get("process_data"))
            response_data = None
            if record_data.get("response_data") is not None:
                response_data = json.dumps(record_data.get("response_data"))

            list_field = ["year", "month", "day", "author", "request_uuid"]
            list_value = [str(current_year), str(current_month), str(current_day), f"""'{str(author_id)}'""",
                          f"""'{str(request_uuid)}'"""]

            if request_data:
                list_field.append("request_data")
                list_value.append(f"""'{str(request_data)}'""")
            if process_data:
                list_field.append("process_data")
                list_value.append(f"""'{str(process_data)}'""")
            if response_data:
                list_field.append("response_data")
                list_value.append(f"""'{str(response_data)}'""")

            list_field.append("run_time")
            list_value.append(f"""TIMESTAMP '{current_time}'""")

            fields_string = ",".join(list_field)
            values_string = ",".join(list_value)
            query = f"""INSERT INTO  "{database_name}"."{table_name}" ({fields_string}) VALUES ({values_string});"""
            print(query)

            response = athena_client.start_query_execution(
                QueryString=str(query),
                QueryExecutionContext={
                    'Database': database_name
                },
                ResultConfiguration={
                    'OutputLocation': f's3://{bucket_name}/query-id/'
                },
                WorkGroup=work_group
            )
            print(response)


