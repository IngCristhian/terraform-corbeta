import boto3
import re
import csv
import datetime
import json

s3 = boto3.client('s3')

def parse_log_line(log_line):
    timestamp_info_pattern = r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3})\s+(.+):\d+\s+-\s+(.*)'
    match = re.match(timestamp_info_pattern, log_line)
    if match:
        timestamp = match.group(1)
        info = match.group(2)
        message = match.group(3)
        parsed_log = {
            'timestamp': timestamp,
            'info': info,
            'message': message
        }
        return parsed_log
    else:
        return None

def lambda_handler(event, context):
    for record in event['Records']:
        message_body = json.loads(record['body'])
        s3_event = message_body['Records'][0]['s3']
        
        source_bucket = s3_event['bucket']['name']
        source_key = s3_event['object']['key']
        
        filename = re.sub(r'\.log$', '', source_key)
        partition_name = filename.split('.')[0]
        today_date = datetime.datetime.now().strftime('%Y/%m/%d')
        
        destination_bucket = 'logs-parseados-corbeta'
        folder_prefix = f"{partition_name}/{today_date}/"
        
        response = s3.get_object(Bucket=source_bucket, Key=source_key)
        log_contents = response['Body'].read().decode('utf-8')
        
        parsed_logs = []
        for log_line in log_contents.splitlines():
            parsed_log = parse_log_line(log_line)
            if parsed_log:
                parsed_logs.append(parsed_log)
        
        if parsed_logs:
            csv_contents = []
            for parsed_log in parsed_logs:
                csv_contents.append(f"{parsed_log['timestamp']}|{parsed_log['info']}|{parsed_log['message']}|{filename}")
            
            csv_key = f"{folder_prefix}{filename}.csv"
            s3.put_object(Bucket=destination_bucket, Key=csv_key, Body='\n'.join(csv_contents), ContentType='text/csv')
    
    return {
        'statusCode': 200,
        'body': 'Procesamiento completado'
    }
