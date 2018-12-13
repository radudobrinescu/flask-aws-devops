from flask import Flask, jsonify, json, Response, request
from datetime import datetime as dt
import os

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

@app.route('/hello/<name>', methods = ['GET','PUT'])
def hello(name):
    if name is None:
        return 'ECHO: No name supplied'
    elif request.method == 'GET':
        return find_in_store(name)
    elif request.method == 'PUT':
        return update_entry(name)

def find_in_store(name):
    filename = os.path.join(app.static_folder, 'people.json')
    with open(filename) as people_file:
        data = json.loads(people_file.read())
        for i in data:
            if i['name'] == name:
                data = {"message": 'Hello, '+name+'!'+message(i['dateOfBirth'])}
                resp = jsonify(data)
                resp.status_code = 200
                people_file.close()
    return resp

def message(birthdate):
    birthday = dt.strptime(birthdate, "%d-%m-%Y").replace(year=dt.today().year)
    delta = (birthday.date() - dt.today().date()).days
    if delta == 0:
        return ' Happy birthday!'
    else:
        return ' Your birthday is in ' +str((delta+365)%365)+' days.'

def update_entry(name):
    filename = os.path.join(app.static_folder, 'people.json')
    with open(filename, 'r+') as people_file:
        data = json.loads(people_file.read())
        update_req = request.json
        for i in data:
            if i['name'] == name:
                i['dateOfBirth'] = update_req['dateOfBirth']
                people_file.seek(0)
                json.dump(data, people_file)
                people_file.truncate()
                people_file.close()
                resp = Response(status=204, mimetype="application/json")
        return resp

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
