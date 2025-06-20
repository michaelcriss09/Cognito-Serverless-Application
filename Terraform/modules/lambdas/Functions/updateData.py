import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Profile-db')

def lambda_handler(event, context):
    print("Event received:", json.dumps(event))

    try:
        method = event.get('httpMethod', '')
        if method not in ['POST', 'PUT']:
            return build_response(405, {'message': f'Method {method} not allowed'})

        body_raw = event.get('body')
        body = json.loads(body_raw) if isinstance(body_raw, str) else body_raw

        user_id = body.get('userId')
        if not user_id:
            print("Missing userId")
            return build_response(400, {'message': 'Missing userId'})
        
        # Define entry values (surname, last name, country and born date)
        update_expression = "SET surname = :s, last_name = :l, Country = :c, born_date = :b"
        expression_values = {
            ':s': body.get('surname'),
            ':l': body.get('last_name'),
            ':c': body.get('Country'),
            ':b': body.get('born_date')
        }

        table.update_item(
            Key={'userId': user_id},   # <- Hash 
            UpdateExpression=update_expression, 
            ExpressionAttributeValues=expression_values
        )

        print(f"Profile updated successfully for user: {user_id} via {method}")
        return build_response(200, {'message': 'Profile updated successfully'})

    except Exception as e:
        print("Error:", str(e))
        return build_response(500, {'message': 'Error', 'error': str(e)})

def build_response(status_code, body):
    return {
        'statusCode': status_code,
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
            'Access-Control-Allow-Methods': 'OPTIONS,POST,PUT,GET,DELETE'
        },
        'body': json.dumps(body)
    }
