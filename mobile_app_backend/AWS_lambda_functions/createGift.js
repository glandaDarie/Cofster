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
    
    const payload = {
      users: existingUsers,
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
    
    let {statusCode, _, userPosition, userID} = JSON.parse(responseGifts.Payload)
    let user = null;
    let newUserData = null;
    
    if(statusCode === 200) { 
      user = existingUsers[userPosition][[userID]];
      const giftIndex = getNewGiftPosition(user);
      user.gifts[0][["gift_" + giftIndex]] = requestBody.gift;
      newUserData = {
        [userID]: {...user}
      };
      
      await database.update({
        TableName: TABLE_NAME,
        Key: {
          giftId: 0,
        },
        UpdateExpression: "SET #users[" + userPosition + "]." + userID + " = :newUserData",
        ExpressionAttributeNames: {
          "#users": "users",
        },
        ExpressionAttributeValues: {
          ":newUserData": user,
        },
      }).promise();
    } else { 
      userID = getNewUserID(existingUsers);
      newUserData = {
        [userID]: {
          name: requestBody.name,
          username: requestBody.username,
          gifts: [
            {
              gift_1: requestBody["gift"]
            }
          ]
        }
      }
      
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
    }

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

const getNewGiftPosition = (user) => {
  let giftKeys = Object.keys(user.gifts[0]);
  let giftKey = giftKeys[giftKeys.length - 1];
  return String(Number(giftKey.split("_")[1]) + 1);
}

const getNewUserID = (users) => {
  let userIDs = users.length > 0 ? users.map(userObj => Object.keys(userObj)[0]) : [];
  if(userIDs.length === 0) {
    return "user_1";
  }
  const userID = Math.max(...userIDs.map(userID => Number(userID.split("_")[1])));
  return "user_" + String(Number(userID) + 1);
}