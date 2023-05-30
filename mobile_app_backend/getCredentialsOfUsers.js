const AWS = require("aws-sdk")
AWS.config.update({region : "us-east-1"});

exports.handler = async(event, context) => {
	const database = new AWS.DynamoDB.DocumentClient({region : "us-east-1"});
	const params = {
		TableName : "usersCredentials",
		KeyConditionExpression : "usersInformation = :usersInformation",
		ExpressionAttributeValues : {
				":usersInformation" : event.usersInformation
		}
	};
	try 
	{
		var data = await database.query(params).promise();
		console.log(data);
		return data.Items;
	}
	catch(e) 
	{
		console.log(e);
		return e;
	}
}



