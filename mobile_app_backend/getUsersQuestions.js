const AWS = require("aws-sdk")
AWS.config.update({region : "us-east-1"});

exports.handler = async(event, context) => {
	const database = new AWS.DynamoDB.DocumentClient({region : "us-east-1"});
	const params = {
		TableName : "drinkQuestionnaire",
		KeyConditionExpression : "questionId = :questionId",
		ExpressionAttributeValues : {
			":questionId" : event.questionId
		}
	};
	try 
	{
		var data = await database.query(params).promise();
		return data.Items;
	}
	catch(e) 
	{
		return {
		    statusCode: 500,
		    body: "Exception " + e + " when fetching the data"
		}
	}
}