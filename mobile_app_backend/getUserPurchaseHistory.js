const AWS = require("aws-sdk");
const REGION = "us-east-1";
const TABLE_NAME = "purchaseHistory";
AWS.config.update({ region: REGION });

exports.handler = async (event) => {
  const getParams = {
    TableName: TABLE_NAME
  };

  try {
    const database = new AWS.DynamoDB.DocumentClient({ region: REGION });
    const scanResult = await database.scan(getParams).promise();
    const emails = scanResult.Items[0]["emails"];

    for (let i = 0; i < emails.length; ++i) {
      if (emails[i]["email"] === event["email"]) {
        return {
          statusCode: 200,
          body: {
            email: event["email"],
            positionFound: +i,
            orderInformation: emails[i]["orderInformation"]
          }
        };
      }
    }

    return event["showOrderHistory"] === 1 ?
      {
        statusCode: 404,
        showOrderHistory: scanResult.Items,
        body: "No order information found for the user"
      } :
      {
        statusCode: 404,
        body: "No order information found for the user"
      }
  } catch (error) {
    return {
      statusCode: 500,
      body: "Could not fetch the data from DynamoDB table: " + TABLE_NAME + ", error: " + error
    };
  };
};
