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
    let gifts = null;
    
    for(let user of users) {
      let userKey = Object.keys(user)[0];
      const currentUser = user[userKey];
      if(currentUser.name === requestBody.name && currentUser.username === requestBody.username) {
        gifts = user[userKey].gifts;
        break;
      }
    }

    return gifts !== null ?
    {
      statusCode : 200,
      gifts: gifts
    } :
    {
      statusCode: 400,
      body: "Respective user does not have gifts or he does not exist"
    }
  } catch (error) {
    return {
      statusCode: 500,
      body: "Error: " + error,
    };
  }
};
