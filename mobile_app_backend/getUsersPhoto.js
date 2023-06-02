const AWS = require("aws-sdk");
const s3 = new AWS.S3();

exports.handler = async (event, context) => {
    
  let requestBody = null;
  try {
    requestBody = event.queryStringParameters;
  } catch(e) {
      return {
        statusCode: 400,
        body: "When parsing the event body, exception is: "+ e
      }
  }    
    
  const bucketName = "users-secondary-information-bucket";
  const folderName = "users_photos";
  const name = requestBody.name.trim().toLowerCase();

  const params = {
    Bucket: bucketName,
    Prefix: folderName,
  };
  
  var encodedData = null;
  try {
    const response = await s3.listObjectsV2(params).promise();
    for (let item of response.Contents) {
      if (item.Key.includes(name)) {
        const s3Params = {
          Bucket: bucketName,
          Key: item.Key,
        };
        const data = await s3.getObject(s3Params).promise();
        encodedData = data.Body.toString();
      }
    }
    if(encodedData === null) {
      return {
        statusCode: 200,
        body: "The user " + name + " does not have such a photo",
      };
    }
    return {
      statusCode: 200,
      body: encodedData
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify(err.message),
    };
  }
};