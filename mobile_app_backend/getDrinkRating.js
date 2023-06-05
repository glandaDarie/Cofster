const AWS = require("aws-sdk")
AWS.config.update({region : "us-east-1"});

exports.handler = async (event) => {
    let database = null;
    let params = null;
    try {
        database = new AWS.DynamoDB.DocumentClient({region: "us-east-1"});
        params = {
            TableName: "drinksRatings",
            KeyConditionExpression : "drinksId = :drinksId",
		    ExpressionAttributeValues : {
				":drinksId" : event.drinksId
		    }
        };
    } catch(error) {
        return {
            statusCode: 500,
            body: "Could not initialize the DynamoDB database, error: "+ error
        };
    };
    
    let data = null;
    try {
        const response = await database.query(params).promise();
        data = response.Items;
    } catch(error) {
        return {
          statusCode: 400,
          body: "The params are not written properly, error: " + error
        };
    }
    
    const drinks = data[0]?.drinks || [];
    for(const [drinkName, drinkDetails] of Object.entries(drinks[0] || {})) {
        if(
            drinkName.trim().toLowerCase() === event.drink.trim().toLowerCase()
        ) {
            return {
                statusCode: 200,
                body: drinkDetails[0]
            };
        }
    }
    return {
        statusCode: 400,
        body: "No drink with that respective name is present in the database."
    };
};
