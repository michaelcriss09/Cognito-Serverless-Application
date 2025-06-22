import json
import boto3
import base64
import re
from datetime import datetime
import random
import uuid


s3 = boto3.resource('s3')
client = boto3.client('textract')
dynamodb = boto3.resource('dynamodb')

bucket_name = 'dni-images-2415'
table = dynamodb.Table('Profile-db')


bucket = s3.Bucket(name=bucket_name)

def lambda_handler(event, context):
    try:
        print("EVENT:", json.dumps(event))

        body_raw = event.get('body')
        print("BODY_RAW:", str(body_raw)[:100]) 

        if not body_raw:
            return {
                'statusCode': 400,
                'headers': {'Access-Control-Allow-Origin': '*'},
                'body': json.dumps({'message': 'Missing body in request'})
            }
        
        try:
            body = json.loads(body_raw) if isinstance(body_raw, str) else body_raw
        except Exception as e:
            print("JSON parse error:", str(e))
            return {
                'statusCode': 400,
                'headers': {'Access-Control-Allow-Origin': '*'},
                'body': json.dumps({'message': 'Invalid JSON format', 'error': str(e)})
            }
        
        # GET IMAGE UPLOADED FROM JS BACKEND

        base64_data = body.get('image')
        print("BASE64_DATA (inicio):", base64_data[:50] if base64_data else "NULO")

        if not base64_data:
            return {
                'statusCode': 400,
                'headers': {'Access-Control-Allow-Origin': '*'},
                'body': json.dumps({'message': 'No image data provided'})
            }

        match = re.match(r'data:(image/\w+);base64,(.+)', base64_data)   
        if not match:
            print("Formato base64 inválido")
            return {
                'statusCode': 400,
                'headers': {'Access-Control-Allow-Origin': '*'},
                'body': json.dumps({'message': 'Invalid image data format'})
            }

        content_type = match.group(1)
        image_data = match.group(2)
        image_bytes = base64.b64decode(image_data)

        ext = content_type.split('/')[-1]
        folder = "uploads"  

        # Format file name. Allow unique name playing with random and datetime library               
        file_name = f"{folder}/dni_{datetime.utcnow().strftime('%Y%m%dT%H%M%SZ')}_{random.randint(1000,9999)}.{ext}" # image unique name

        # Print file name into Logs
        print("Saving file:", file_name)  


        bucket.put_object(                    
            Key=file_name,  # Upload our image object in S3 bucket choosing our file name implemented preoviusly
            Body=image_bytes,
            ContentType=content_type,
            ACL='private'
        )

        # Text extracted by AWS Textstract. 
        response = client.detect_document_text(
            Document={                            
                'S3Object':{
                    'Bucket':bucket_name,
                    'Name':file_name,      # <- Choose image into S3 bucket
                }

            }
        )

        # Each passports have a MRZ, which contains our required data by the user. Played with positions and filter data on MRZ Block

        mrz_lines = [block['Text'] for block in response['Blocks'] if block['BlockType'] == 'LINE']
        def get_mrz(mrz_lines):
            for i, block_line in enumerate(mrz_lines):
                if block_line.startswith('P<'):
                    if i+1 < len(mrz_lines):
                        return block_line, mrz_lines[i+1]
                    else:
                        return block_line,  None
            return None, None
        
        def clear_text(text):
            text = text.replace('<', ' ').strip()
            text = re.sub(' +', ' ', text)
            return text.title()
        
        mrz_line1, mrz_line2 = get_mrz(mrz_lines)

        if mrz_line1 and mrz_line2:
            country = mrz_line1[2:5]
            entire_name = mrz_line1[5:].strip()

            each_parts = entire_name.split('<<', 1)
            last_name_raw = each_parts[0] if len(each_parts) > 0 else ''
            surname_raw = each_parts[1] if len (each_parts) > 1 else ''

            last_name = clear_text(last_name_raw)
            surname = clear_text(surname_raw)

            if len(mrz_line2) >= 20:
                date_raw = mrz_line2[13:19]
                year = int(date_raw[0:2])
                siglo = 1900 if year >= 50 else 2000
                born_date = f"{siglo + year}-{date_raw[2:4]}-{date_raw[4:6]}"
            else:
                born_date = None
        else:
            print("MRZ NOT FOUND")

        # Variables
            # surname 
            # lastname
            # born_date
            # country

        unique_id = str(uuid.uuid4())    

        # Data introduced into Dynamodb table 
        response = table.put_item(
            Item={
                'userId' : unique_id,
                'surname': surname,
                'last_name': last_name,
                'Country': country,
                'born_date': born_date
            }
        )
        

        """
        
        Delete Image after processing data, needed to delete s3 resouces with
        terraform destroy. Terraform does not have control about resources 
        created outside the platform

        """

        response = s3.Object(bucket_name, file_name).delete()

        print(response)

        return {
            'statusCode': 200,
            'headers': {'Access-Control-Allow-Origin': '*'},
            'body': json.dumps({'message': 'Image uploaded successfully', 
                                'fileName': file_name,
                                'userId': unique_id,
                                'surname':surname,
                                'last_name':last_name,
                                'Country': country,
                                'born_date':born_date})
        }

    except Exception as e:
        print(f"Error uploading image: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {'Access-Control-Allow-Origin': '*'},
            'body': json.dumps({'message': 'Internal server error', 'error': str(e)})
        }
