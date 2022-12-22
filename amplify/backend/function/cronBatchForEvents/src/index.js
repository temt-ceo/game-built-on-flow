const aws = require('aws-sdk')
const ddb = new aws.DynamoDB()
/* Amplify Params - DO NOT EDIT
	ENV
	REGION
Amplify Params - DO NOT EDIT */

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event) => {
    console.log(`EVENT: ${JSON.stringify(event)}`);
    let params = {
        Item: {
            id: {S: 'test'},
            test: {S: 'abc'}
        },
//        TableName: process.env.USERTABLE
        TableName: 'TestTable'
    }
    try {
        await ddb.putItem(params).promise()
        console.log('Success')
    } catch (err) {
        console.log('Error', err)
    }
};
