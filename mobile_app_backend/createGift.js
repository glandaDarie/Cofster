const AWS = require("aws-sdk");
const REGION = "us-east-1";
const TABLE_NAME = "gifts";
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

  const getGiftsContentParams = {
    TableName: TABLE_NAME
  };

  try {
    const database = new AWS.DynamoDB.DocumentClient({ region: REGION });
    let data = await database.scan(getGiftsContentParams).promise();
    data = data.Items;
    let existingUsers = data[0].users || [];
    let userID = null;
    let userIDs = existingUsers.length > 0 ? existingUsers.map(userObj => Object.keys(userObj)[0]) : [];
    if (userIDs.length === 0) {
      userID = "user_1"
    } else {
      const userIDIndex = Math.max(...userIDs.map(userID => Number(userID.split("_")[1])));
      userID = "user_" + String(Number(userIDIndex) + 1);  
    }
    
    const newUserData = {
      [userID]:
      {
        name: requestBody.name,
        username: requestBody.username,
        gifts: [
          {
            gift_1: requestBody["gift"]
          }
        ]
      },
    };
    
    existingUsers.push(newUserData);
    
    await database.update({
      TableName: TABLE_NAME,
      Key: {
        giftId: 0,
      },
      UpdateExpression: "SET #users = :newUserData",
      ExpressionAttributeNames: {
        "#users": "users"
      },
      ExpressionAttributeValues: {
        ":newUserData": existingUsers
      }
    }).promise();

    return {
      statusCode: 201,
      body: "Successfully added a new user with gifts",
    };
    
  } catch (error) {
    return {
      statusCode: 500,
      body: "Problem caused by the database, error: " + error.message,
    };
  }
};
