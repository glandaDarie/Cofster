from typing import List, Dict 
from inference import predict
from flask import Flask, jsonify, request
from features import questions
from classes import labels
import json 

app = Flask(__name__)

@app.route("/prediction_drinks", methods=["POST"])
def prediction_drinks() -> json:
    if request.method == "POST":
        try:
            data : Dict[str, str] = request.get_json()
            data : Dict[str, str] = data["body"]
        except Exception as e:
            return jsonify({
                "statusCode" : 400,
                "body" : f"Error {e} when adding the user information" 
            })
        if len(questions) != len(data):
            return jsonify({
                "statusCode" : 500,
                "body" : "Invalid server error"
            })
        predictions : List[int] = predict(data)
        predictions : Dict[str, str] = \
            {f"drink {i+1}": labels[pred] for i, pred in enumerate(predictions)}
        return jsonify({
            "statusCode" : 201,
            "favouriteDrinks" : predictions
            })
    return jsonify({
        "statusCode": 405,
        "message": "Method not allowed"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8001)