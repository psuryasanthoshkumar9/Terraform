import json
import os
import boto3

ddb = boto3.client("dynamodb")
s3 = boto3.client("s3")

TABLE = os.environ.get("DDB_TABLE")
BUCKET = os.environ.get("S3_BUCKET")

def lambda_handler(event, context):
    # simple demo: put an item with unique id coming from timestamp, and echo event
    import time
    item = {
        "pk": {"S": str(int(time.time()*1000))}
    }
    try:
        ddb.put_item(TableName=TABLE, Item=item)
        s3.put_object(Bucket=BUCKET, Key=f"event-{item['pk']['S']}.json", Body=json.dumps(event).encode('utf-8'))
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "ok", "id": item["pk"]["S"]})
    }
