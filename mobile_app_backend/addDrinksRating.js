const AWS = require("aws-sdk");
AWS.config.update({ region: "us-east-1" });

exports.handler = async (event) => {
  const requestBody = event.body;

  try {
    const database = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });
    const getParams = {
      TableName: "drinksRatings",
      KeyConditionExpression: "drinksId = :drinksId",
      ExpressionAttributeValues: {
        ":drinksId": requestBody["drinksId"],
      },
    };

    const response = await database.query(getParams).promise();
    let data = response.Items;
    const drinks = data[0]?.drinks || [];

    for (const [drinkName, drinkDetails] of Object.entries(drinks[0] || {})) {
      if (
        drinkName.trim().toLowerCase() === requestBody.drink.trim().toLowerCase()
      ) {
        const details = drinkDetails[0];
        const R = +details.rating;
        let n = +details.number_rating_responses;
        const x = +requestBody.drink_rating;
        const R_hat = ((R * n + x) / (n + 1)).toString();
        n = (n + 1).toString();
        
        const newDrinkData = [
          {
            "rating": R_hat,
            "number_rating_responses": n
          },
        ];
        
        if (data[0]?.drinks[0] && drinkName in data[0]?.drinks[0]) {
          data[0].drinks[0][drinkName] = newDrinkData;
        }
        
        const putParams = {
          TableName: "drinksRatings",
          Item: {
            "drinksId": data[0].drinksId,
            "drinks": data[0].drinks
          }
        };
        
        try {
          await database.put(putParams).promise();
          return {
             statusCode : 201, 
             body : "Successfully added the new user rating to all the ratings"
          }
        } catch(error) {
          return {
            statusCode: 500,
            body: "Error when adding a new user rating to the ratings: "+ error
          };
        }
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

