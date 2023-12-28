from flask import Flask, render_template, request
import boto3
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__, static_url_path='/static')

aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
region_name = os.getenv('AWS_REGION')
table_name = os.getenv('DYNAMODB_TABLE_NAME')

dynamodb = boto3.resource('dynamodb', aws_access_key_id=aws_access_key_id,
                          aws_secret_access_key=aws_secret_access_key,
                          region_name=region_name)

table = dynamodb.Table(table_name)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        
        table.put_item(Item={'name': name, 'email': email})
        
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
