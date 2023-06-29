import os
import urllib3
import asyncio

host = os.environ['API_HOST']
http = urllib3.PoolManager()


http = urllib3.PoolManager()

async def make_request(inventory_id, organization_id):
    url = f"{host}?inventory_ids={inventory_id}"
    headers = {"Content-Type": "application/json", "organization-id": organization_id}
    response = await loop.run_in_executor(None, http.request, "POST", url, None, headers)
    return response.data

host = os.environ['API_HOST']

async def main():
    tasks = []
    for record in event['Records']:
        inventory_id, organization_id = record["body"].split(",")
        task = asyncio.create_task(make_request(inventory_id, organization_id))
        tasks.append(task)
    responses = await asyncio.gather(*tasks)
    for response in responses:
        print("Response status:", response.status)
        print("Response:", response.data)

loop = asyncio.get_event_loop()
if loop.is_closed():
    loop = asyncio.new_event_loop()
loop.run_until_complete(main())