from flask import Flask, jsonify, json, Response, request
from datetime import datetime as dt
from boto3.dynamodb.conditions import Key, Attr
import boto3

dynamodb = boto3.resource('dynamodb', region_name='eu-central-1')

table = dynamodb.Table('People')

app = Flask(__name__)

help_message = """
API Usage:

- GET    /hello/<name>
- PUT    /hello/<name> data={"dateOfBirth": "%d-%m-%Y"}

"""

@app.route('/hello/')
@app.route('/hello')

@app.route('/')
def help():
    resp = Response(response=help_message,status=200,mimetype="text/plain")
    return resp

@app.route('/hello/<name>', methods=['GET', 'PUT'])
def hello(name):
    if request.method == 'GET':
        return find_in_store(name)
    elif request.method == 'PUT':
        return update_entry(name)

def find_in_store(name):
    resp = jsonify({"message": "This user does not exist."})
    response = table.query(
        KeyConditionExpression=Key('Username').eq(name)
    )
    for i in response['Items']:
        data = {"message": 'Hello, ' + name + '!' + message(i['dateOfBirth'])}
        resp = jsonify(data)
        resp.status_code = 200
    return resp

def message(birthdate):
    birthday = dt.strptime(birthdate, "%d-%m-%Y").replace(year=dt.today().year)
    delta = (birthday.date() - dt.today().date()).days
    if delta == 0:
        return ' Happy birthday!'
    else:
        return ' Your birthday is in ' + str((delta + 365) % 365) + ' days.'

def update_entry(user):
    update_req = request.json
    table.update_item(
        Key={
            'Username': user,
        },
        ReturnValues='UPDATED_NEW',
        UpdateExpression="set dateOfBirth = :var",
        ConditionExpression=Attr('Username').eq(user),
        ExpressionAttributeValues={
            ':var': update_req['dateOfBirth']
        }
    )

    resp = Response(status=204, mimetype="application/json")
    return resp

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
