const AWS = require("aws-sdk");
const REGION = "us-east-1";
const TABLE_NAME = "purchaseHistory";
AWS.config.update({ region: REGION });

exports.handler = async (event) => {
  let requestBody = null;
  try {
    requestBody = event.body;
  } catch (error) {
    return {
      statusCode: 400,
      body: "Invalid request body " + error,
    };
  }

  const payload = {
    body: {
      email: requestBody["email"],
    },
  };

  const getPurchaseHistoryFunctionParams = {
    FunctionName: "getUserPurchaseHistory",
    InvocationType: "RequestResponse",
    Payload: JSON.stringify(payload),
  };
  
  const lambda = new AWS.Lambda({ region: REGION });
  const response = await lambda
    .invoke(getPurchaseHistoryFunctionParams)
    .promise();
  
  const statusCode = JSON.parse(response.Payload)["statusCode"];
  const positionFound = JSON.parse(response.Payload).body["positionFound"];
  let database = new AWS.DynamoDB.DocumentClient({ region: REGION });
  
  if (statusCode === 200) {
    let historyPurchase = JSON.parse(response.Payload).body["orderInformation"];
    let lastKey = Object.keys(historyPurchase[historyPurchase.length - 1]).toString();
    let lastKeySplitted = lastKey.split("_");
    let lastKeyName = lastKeySplitted[0];
    let lastKeyIndex = +lastKeySplitted.slice(-1)[0]
    lastKeyIndex += 1;
    let newPurchaseKey = [lastKeyName, lastKeyIndex].join("_");
    
    const newPurchase = {
      coffeeCupSize: requestBody["coffeeCupSize"],
      coffeeName: requestBody["coffeeCupSize"], 
      coffeeNumberOfIceCubes: requestBody["coffeeNumberOfIceCubes"],
      coffeeNumberOfSugarCubes: requestBody["coffeeNumberOfSugarCubes"],
      coffeePrice: requestBody["coffeePrice"],
      coffeeQuantity: requestBody["coffeeQuantity"],
      coffeeTemperature: requestBody["coffeeTemperature"],
      hasCoffeeCream: requestBody["hasCoffeeCream"]
    };
    
    const historyPurchaseConcatenated = historyPurchase.concat({[newPurchaseKey]: newPurchase});
    
    const updateParams = {
      TableName: TABLE_NAME,
      Key: {
        purchaseHistoryId: "1", 
      },
      UpdateExpression: "SET #emails[" + positionFound + "].#orderInformation = :history",
      ExpressionAttributeNames: {
        "#emails": "emails",
        "#orderInformation": "orderInformation",
      },
      ExpressionAttributeValues: {
        ":history": historyPurchaseConcatenated,
      },
    };
  
    try {
      await database.update(updateParams).promise();
    } catch (error) {
      return {
        statusCode: 500,
        body: "Could not add new purchase to purchase history, error: " + error,
      };
    }
    return {
      statusCode: 201,
      body: "Successfully added new purchase to purchase history",
    };
  } else {
    console.log("I am somewhere else");
  }
};
