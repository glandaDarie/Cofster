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
    
    const { username, newPassword } = requestBody;
    
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
		console.log(response);
		data = response.Items;
	}
	catch(e) 
	{
		console.log(e);
		return e;
	}
	
    var users = data[0]["users"][0]["user"];
    const positionOldPassword = users.findIndex(user => user.username === username);
    users[positionOldPassword]["password"] = newPassword;
    
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
            body : "Successfully updated the password for username "+ username
         }
    } catch(e) {
        return {
            statusCode: 500,
            body: "Error updating password: "+ e
        };
    }
}