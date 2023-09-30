const AWS = require("aws-sdk");
const REGION = "us-east-1";
const TABLE_NAME = "gifts";
AWS.config.update({ region: REGION });

exports.handler = async (event) => {
  let requestBody = null;
  
  try {
    requestBody = event;
  } catch(error) {
    return {
      statusCode: 400,
      body: "Invalid request body " + error,
    };
  }
  
  const database = new AWS.DynamoDB.DocumentClient({region : REGION});
  
  const params = {
    TableName: TABLE_NAME,
  };
  
  try {
    const data = await database.scan(params).promise();
    const users = data.Items[0].users;
    
    const payload = {
      users: users,
      targetUser: requestBody
    }
    
    const getUserGiftInformationParams = {
      FunctionName: "getUserGiftInformation",
      InvocationType: "RequestResponse",
      Payload: JSON.stringify(payload),
    };
    
    const lambda = new AWS.Lambda({ region: REGION });
    const responseGifts = await lambda
      .invoke(getUserGiftInformationParams)
      .promise();
    
    const userGiftInformation = JSON.parse(responseGifts.Payload);
    const {statusCode, gifts} = userGiftInformation;
    
    return {
      statusCode: statusCode,
      gifts: gifts
    };
    
  } catch (error) {
    return {
      statusCode: 500,
      body: "Error: " + error,
    };
  }
};
