const AWS = require("aws-sdk");
const s3 = new AWS.S3();

exports.handler = async (event, context) => {
  let requestBody = null;
  try {
    requestBody = event.body;
  } catch(e) {
      return {
        statusCode: 400,
        body: "When parsing the event body, exception is: "+ e
      }
  }
  
  const bucketName = "users-secondary-information-bucket";
  const filename = requestBody["filename"];
  const photoData = requestBody["photo"];
  
  const params = {
    Bucket: bucketName,
    Key: "users/"+filename
  };
  
   try {
    await s3.headObject(params).promise();
    return {
      statusCode: 200,
      body: "File already exists. Not creating new file."
    };
  } catch (err) {
    if (err.code === "NotFound") {      
      try {
        const params = {
         Bucket: bucketName,
         Key: "users_photos/"+filename,
         Body: photoData,
         ACL: "public-read",
         ContentType: "image/jpeg"
        };  
        await s3.putObject(params).promise();
      } catch(err) {
        return {
          statusCode: 500,
          body: "Error when adding the parameters to the S3 bucket: "+ err
        }
      }
      return {
        statusCode: 201,
          body: "File created and uploaded successfully."
      }
    }
  } 
};