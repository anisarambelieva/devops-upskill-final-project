from flask import Flask, render_template, request
import boto3

app = Flask(__name__, static_url_path='/static')

dynamodb = boto3.resource('dynamodb', region_name="eu-west-1")

table = dynamodb.Table("newsletter-subscriptions")

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form.get('name')
        email = request.form.get('email')
        
        table.put_item(Item={'name': name, 'email': email})
        
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
