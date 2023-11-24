const AWS = require(`aws-sdk`);
const REGION = `us-east-1`;
const TABLE_NAME = `usersCredentials`;
AWS.config.update({ region: REGION });

exports.handler = async (event) => {
  let requestBody = null;
  try {
    requestBody = {...event};
  } catch(error) {
    return {
      statusCode: 400,
      body: `Invalid request body: ${error}` 
    };
  }
  
  const {name, username} = requestBody;
  
  if (name === undefined) {
    return {
      statusCode: 400, 
      body: `Name does not exist`
    }
  }
  
  if (username === undefined) {
    return {
      statusCode: 400, 
      body: `Username does not exist`
    }
  }
  
  let database = null;
  try {
    database = new AWS.DynamoDB.DocumentClient({ region: REGION });
  } catch (error) {
    return {
      statusCode: 500,
      body: `Problem appeared when initializing the database, error: ${error}`
    };
  }
  
  const getContentParams = {
    TableName: TABLE_NAME
  };

  try {
    const content = await database.scan(getContentParams).promise();
    const fetchedData = content.Items;
    if (fetchedData.length === 0) {
      return {
        statusCode: 400,
        body: `No data found in the table`
      };
    }
    
    const errorMsg = await deleteUser(fetchedData[0], name, username, database);
    if(errorMsg !== null) {
      return {
        statusCode: 500,
        body: `Could not delete the user, error: ${errorMsg}`
      }
    }
    return {
      statusCode: 200,
      body: `Successfully deleted the user from the ${TABLE_NAME} table`
    }
  } catch(error) {
    return {
      statusCode: 500,
      body: `Problem appeared when trying to fetch the content from the database, error: ${error}`
    }
  }
};

const deleteUser = async (data, targetName, targetUsername, database) => {
  const deletionData = data.users[0];
  if (!deletionData) {
    return `Problems with the database, there is no user present`;
  }
  const foundIndex = deletionData.user.findIndex(user => {
    return user.name === targetName && user.username === targetUsername;
  });
  if (foundIndex === -1) {
    return `The given user is not present in the database`;
  }
  deletionData.user.splice(foundIndex, 1);
  const params = {
    TableName: TABLE_NAME,
    Item: {
      usersInformation: `info`,
      users: data.users,
    },
  };
  try {
    await database.put(params).promise();
  } catch (error) {
    return error;
  }
  return null;
};