from flask import Flask, request, jsonify, make_response 
import logging
import jwt 
from datetime import datetime, timedelta 
from functools import wraps

app = Flask(__name__)
app.config['SECRET_KEY'] = 'your secret key'

logging.basicConfig(level=logging.DEBUG)

api_auth = "2f5ae96c-b558-4c7b-a590-a501ae1c3f6c"

def token_required(f): 
    @wraps(f) 
    def decorated(*args, **kwargs): 
        token = None
        
        if 'X-JWT-KWY' in request.headers: 
            token = request.headers['X-JWT-KWY'] 
        
        if not token: 
            return jsonify({'message' : 'JWT is missing !!'}), 401
   
        try: 
            data = jwt.decode(token, app.config['SECRET_KEY']) 
            if data['password'] != "devops":
                return jsonify({'message' : 'JWT is invalid !!'}), 401
        except: 
            return jsonify({'message' : 'JWT is invalid !!'}), 401
        
        return  f( *args, **kwargs) 
   
    return decorated 

@app.route('/health', methods=['GET'])
def health():
    if(request.method == 'GET'):
        return jsonify({"message": "health UP"})

@app.route('/generator', methods =['POST']) 
def generator(): 
    token = jwt.encode({ 
            'password': "devops", 
            'exp' : datetime.utcnow() + timedelta(minutes = 30) 
        }, app.config['SECRET_KEY'])
    return make_response(jsonify({'token' : token.decode('UTF-8')}), 201) 

@app.route('/DevOps', methods=['POST','GET','PUT'])
@token_required
def devops():
    try:
        app.logger.info(str(request.method))
        request_data = request.get_json(force=True)
        msg_body = request_data['message']
        msg_to = request_data['to']
        msg_from = request_data['from']
        msg_time = request_data['timeToLifeSec']
        
        headers = request.headers
        auth = headers.get("X-Parse-REST-API-Key")

        if(request.method == 'POST'):
            if auth == api_auth:
                data = {"message": f"Hello {msg_to} your message will be send"}
                return jsonify(data),200
            else:
                return jsonify({"message": " Unauthorized"}), 401
        else:
            return jsonify({"message": "ERROR"}), 405


    except KeyError as e:
        return jsonify({"message": f"Missing item {e.args[0]}"}), 400

@app.errorhandler(404)
def not_found(e):
    return jsonify({"data": "ERROR"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)