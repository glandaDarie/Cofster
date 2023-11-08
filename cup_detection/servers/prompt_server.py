from typing import Dict
from flask import Flask, jsonify, request
from utils.constants import PROMPT_TEMPLATE

app = Flask(__name__)

@app.route("/coffee_recipe_prompt", methods=["GET", "PUT"])
def coffee_recipe_prompt():
    if request.method == "GET":
        coffee_name : str = request.args.get("coffee_name")
        data : Dict[str, str] = {"prompt": PROMPT_TEMPLATE.format(coffee_name)}
        return jsonify(data), 200
    else:
        pass 
        # TODO

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8001)
    