const AWS = require("aws-sdk")
AWS.config.update({region : "us-east-1"});

exports.handler = async(event, context) => {
    let requestBody = null;
    try {
        requestBody = event.body;
    } catch (error) {
        return {
            statusCode: 400,
            body: 'Invalid request body '+ error
        };
    }
    
    const name = requestBody["name"];
    const username = requestBody["username"];
    const password = requestBody["password"];
    
    if (!name || !username || !password) {
        return {
            statusCode: 400,
            body: "Invalid request body. Missing required properties."
        };
    }
    
	const database = new AWS.DynamoDB.DocumentClient({region : "us-east-1"});
	const getParams = {
		TableName : "usersCredentials",
		KeyConditionExpression : "usersInformation = :usersInformation",
		ExpressionAttributeValues : {
				":usersInformation" : "info",
		}
	};
	
	let data = null;
	try 
	{
		var response = await database.query(getParams).promise();
		data = response.Items;
	}
	catch(e) 
	{
		console.log(e);
		return e;
	}
	
    let users = data[0]["users"][0]["user"];
    const id = parseInt(users[users.length - 1]["id"]) + 1;
    var favouriteDrinks = [];
    var photo = "";
    const newUser = {
        "favouriteDrinks": favouriteDrinks,
        "id": id.toString(),
        "name": name,
        "password": password,
        "photo": photo,
        "username": username
    };
    users.push(newUser);
    
    const postParams = {
        TableName: "usersCredentials",
        Item: {
            "usersInformation": "info",
            "users": [
                {
                    "partitionKey": "74382347",
                    "user": users
                }
            ]
        },
        ConditionExpression: "attribute_not_exists(id)"
    };
    
    try {
        await database.put(postParams).promise();
        return {
            statusCode: 201,
            body: "User added successfully"
        }
    } catch(e) {
        return {
            statusCode: 500,
            body: "Error adding user: " + e
        };
    }
};