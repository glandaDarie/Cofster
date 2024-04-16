const AWS = require("aws-sdk");
AWS.config.update({ region: "us-east-1" });

exports.handler = async (event) => {
  try {
    const database = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });
    const params = {
      TableName: "drinksInfomation",
      KeyConditionExpression: "drinkId = :drinkId",
      ExpressionAttributeValues: {
        ":drinkId": event.drinkId,
      },
    };

    let response;
    try {
      response = await database.query(params).promise();
    } catch (error) {
      return {
        statusCode: 500,
        body: "Error fetching data from the database: " + error,
      };
    }

    const data = response.Items;
    if (data.length === 0) {
      return {
        statusCode: 400,
        body: "No data found for the provided drinkId",
      };
    }

    const drinks = data[0].drinks;
    const drink = drinks.find((item) => Object.keys(item)[0].toLowerCase() === event.drink.toLowerCase());
    if (drink) {
      const drinkName = Object.keys(drink)[0];
      return {
        statusCode: 200,
        body: drink[drinkName],
      };
    } else {
      return {
        statusCode: 400,
        body: "The specified drink does not exist",
      };
    }
  } catch (error) {
    return {
      statusCode: 400,
      body: "Invalid request: " + error,
    };
  }
};


