from prediction import predict
from flask import Flask, jsonify
from typing import Dict
from Labels import labels

app = Flask(__name__)

test_prediction : Dict[str, str] = {
    "Question 0" : "medium",
    "Question 1" : "no",
    "Question 2" : "i do not use sugar in my coffee",
    "Question 3" : "below 30%",
    "Question 4" : "short and strong",
    "Question 5" : "none of the above",
    "Question 6" : "no"
}

@app.route("/prediction_drink")
def prediction_classifier() -> jsonify:
    predicted_favourite_drink : int = predict(test_prediction)
    return jsonify({"favouriteDrink" : labels[predicted_favourite_drink]})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)