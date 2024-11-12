import json
import base64
import boto3
import json
import random
import os

# import requests
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

model_id = "amazon.titan-image-generator-v1"

bucket_name = "pgr301-couch-explorers"



def lambda_handler(event, context):
   
    body = json.loads(event.get("body", "{}"))
    prompt = body.get("prompt")
    
    
    seed = random.randint(0, 2147483647)
    s3_image_path = f"13/generated_images/titan_{seed}.png"
    
    
    native_request = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        }
    }
    
    response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
    model_response = json.loads(response["body"].read())
    
    # Extract and decode the Base64 image data
    base64_image_data = model_response["images"][0]
    image_data = base64.b64decode(base64_image_data)
    
    # Upload the decoded image data to S3
    s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)
    
        # try:
        #     ip = requests.get("http://checkip.amazonaws.com/")
        # except requests.RequestException as e:
        #     # Send some context about this error to Lambda Logs
        #     print(e)
    
        #     raise e
    image_url = f"s3://{bucket_name}/{s3_image_path}"

    return {
        "statusCode": 200,
        "body": json.dumps({
            "image_url": image_url
            #"location": ip.text.replace("\n", "")
        }),
    }
