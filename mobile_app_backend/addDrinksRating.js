const AWS = require("aws-sdk");
AWS.config.update({ region: "us-east-1" });

exports.handler = async (event) => {
  const requestBody = event.body;

  try {
    const database = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });
    const params = {
      TableName: "drinksRatings",
      KeyConditionExpression: "drinksId = :drinksId",
      ExpressionAttributeValues: {
        ":drinksId": requestBody["drinksId"],
      },
    };

    const response = await database.query(params).promise();
    const data = response.Items;
    const drinks = data[0]?.drinks || [];

    for (const [drinkName, drinkDetails] of Object.entries(drinks[0] || {})) {
      if (
        drinkName.trim().toLowerCase() === requestBody["drink"].trim().toLowerCase()
      ) {
        return {
          statusCode: 200,
          body: Object.values(drinkDetails),
        };
      }
    }

    return {
      statusCode: 400,
      body: "No drink with that respective name is present in the database.",
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: "Error fetching data from the database: " + error,
    };
  }
};

