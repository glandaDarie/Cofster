const AWS = require("aws-sdk")
AWS.config.update({region : "us-east-1"});

exports.handler = async(event, context) => {
    let requestBody = null;
    try {
        requestBody = event.body;
    } catch (error) {
        return {
            statusCode: 400,
            body: "Invalid request body "+ error
        };
    }
    
    const photo = requestBody["photo"];
    
    if (!photo) {
        return {
            statusCode: 400,
            body: 'Invalid request body. Missing required properties.'
        };
    }
    
	const database = new AWS.DynamoDB.DocumentClient({region : "us-east-1"});
	const params = {
		TableName : "usersCredentials",
		KeyConditionExpression : "usersInformation = :usersInformation",
		ExpressionAttributeValues : {
				":usersInformation" : "info",
		}
	};
	let data = null;
	try 
	{
		var response = await database.query(params).promise();
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
    users[last_index]["photo"] = photo;
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
            statusCode : 201, 
            body : "Successfully updated the photo of user: "+ name
         }
    } catch(e) {
        return {
            statusCode: 500,
            body: "Error updating photo: "+ e
        };
    }
}