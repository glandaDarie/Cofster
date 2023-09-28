const AWS = require("aws-sdk");
const REGION = "us-east-1";
const TABLE_NAME = "gifts";
AWS.config.update({ region: REGION });

exports.handler = async (event) => {
  let requestBody = null;
  try {
    requestBody = event;
  } catch (error) {
    return {
      statusCode: 400,
      body: "Invalid request body " + error,
    };
  }

  let database = null;
  try {
    database = new AWS.DynamoDB.DocumentClient({ region: REGION });
  } catch (error) {
    return {
      statusCode: 500,
      body: "Problem appeared when initializing the database, error " + error,
    };
  }

  const getContentParams = {
    TableName: TABLE_NAME
  };

  try {
    const fetchedData = await database.scan(getContentParams).promise();
    if (fetchedData.Items.length === 0) {
      return {
        statusCode: 400,
        body: "No data found in the table",
      };
    }

    const updatedData = removeGiftFromUser(fetchedData.Items[0], requestBody);
    if(typeof updatedData === "string") {
      return {
        statusCode: 400,
        body: updatedData
      }
    }
    
    console.log(JSON.stringify(updatedData));
    
    const putContentParams = {
      TableName: TABLE_NAME,
      Item: {
        giftId: 0,
        users: updatedData.users, 
      },
    };
    
    try {
      await database.put(putContentParams).promise();
    } catch(error) {
      return {
        statusCode: 500,
        body: "Problem appeard when trying to delete the content in the database, error: " + error
      }
    }
    
    return {
      statusCode: 200,
      body: "Gift deleted successfully",
    };
    
  } catch (error) {
    return {
      statusCode: 500,
      body: "Problem appeared when trying to fetch/update the content from the database, error: " + error,
    };
  }
};

const removeGiftFromUser = (data, targetUser) => {
  let deleted = false;
  if (data && data.users) {
    const users = data.users;
    for (let i = 0; i < users.length; i++) {
      const user = users[i];
      let userKey = Object.keys(user)[0];
      const currentUser = user[userKey];
      if (
        currentUser.name === targetUser.name &&
        currentUser.username === targetUser.username
      ) {
        let gifts = currentUser.gifts[0];
        let giftValues = Object.values(gifts);
        if (Object.keys(gifts).length === 1) {
          let giftValue = giftValues[0];
          if (giftValue === targetUser.gift) {
            deleted = true;
            users.splice(i, 1);
          }
        } else {
          for (let [giftKey, giftValue] of Object.entries(gifts)) {
            if (giftValue === targetUser.gift) {
              deleted = true;
              delete gifts[giftKey];
            }
          }
        }
      }
    }
    if (!deleted) {
      return "The respective user does not have the respective name/username/gift";
    }
  }
  return data;
};
