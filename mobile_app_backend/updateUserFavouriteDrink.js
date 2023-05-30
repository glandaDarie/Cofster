const AWS = require("aws-sdk")
AWS.config.update({region : "us-east-1"});

exports.handler = async (event) => {
    let requestBody = null;
    try {
        requestBody = event.body;
    } catch (error) {
        return {
            statusCode: 400,
            body: 'Invalid request body '+ error
        };
    } 
    
    let favouriteDrinks = { ...requestBody };
    
    if (Object.keys(favouriteDrinks).length != 5) {
        return {
            statusCode: 400,
            body: 'Invalid request body. Missing required properties.'
        };
    }
    
    favouriteDrinks = Object.entries(favouriteDrinks).map(([key, value]) => ({ [key]: value }));
    
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
		 return {
            statusCode: 500,
            body: "Could not fetch data "+ e
        };
	}
	
    const users = data[0]["users"][0]["user"];
    const last_index = users.length - 1;
    users[last_index]["favouriteDrinks"] = favouriteDrinks;
    const name = users[last_index]["name"]
    
    const putParams = {
        TableName : "usersCredentials",
        Item : {
            "usersInformation": "info",
            "users": [
                {
                    "partitionKey": "74382347",
                    "user": users
                }
            ]
        },
        ReturnValues: "ALL_OLD"
    };
    
    try {
         await database.put(putParams).promise();
         return {
             statusCode : 200, 
             body : "Successfully updated the favouriteDrinks of user: "+ name
         }
    } catch(e) {
        return {
            statusCode: 500,
            body: "Error updating photo: "+ e
        };
    }
};
