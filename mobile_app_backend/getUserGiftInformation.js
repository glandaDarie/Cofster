const AWS = require("aws-sdk");

exports.handler = async (event) => {
  let requestBody = null;
  
  try {
    requestBody = event;
  } catch (error) {
    return {
      statusCode: 400,
      body: "Invalid request body " + error
    };
  }
  
  const { users, targetUser } = requestBody;
  
  let gifts = null;
  let userID = null;
  let userIndex = null;
  for (let i = 0; i < users.length; i++) {
      const user = users[i];
      let userKey = Object.keys(user)[0];
      const currentUser = user[userKey];
      if (
        currentUser.name === targetUser.name &&
        currentUser.username === targetUser.username
      ) {
        gifts = currentUser.gifts;
        userID = userKey;
        userIndex = i;
      }
  }

  return gifts !== null ?
  {
    statusCode : 200,
    gifts: gifts,
    userPosition: userIndex,
    userID: userID
  } :
  {
    statusCode: 400,
    body: "Respective user does not have gifts or he does not exist"
  }
};