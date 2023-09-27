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
  
  let database = null;
  try {
    database = new AWS.DynamoDB.DocumentClient({region : REGION});  
  } catch(error) {
    return {
      statusCode: 500,
      body: "Problem appeard when initializing the database, error " + error
    }
  }
  
  const params = {
    TableName: TABLE_NAME,
  };
  
  try {
    const data = await database.scan(params).promise();
    const users = data.Items[0].users;
    
    let userGiftExists = (users, passedUser) => {
      for(let user of users) {
        let userKey = Object.keys(user)[0];
        const currentUser = user[userKey];
        if(currentUser.name === passedUser.name && currentUser.username === passedUser.username) {
          let gifts = user[userKey].gifts[0];
          for(let giftValue of Object.values(gifts)) {
           if(giftValue === passedUser.gift) {
             return true;
           } 
          }
        }
      }
      return false;
    }
    
    if(!userGiftExists(users, requestBody)) {
      return {
        statusCode: 400,
        body: "For the respective user, that gift does not exist"
      }
    }
    
    return {
      dummy : "dummy test"
    }
    
  } catch(error) {
    return {
      statusCode: 500,
      body: "Problem appeard when trying to fetch the content from the database, error: " + error
    }
  }
};


