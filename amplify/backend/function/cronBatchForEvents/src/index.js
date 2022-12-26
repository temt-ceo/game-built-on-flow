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
            id: {S: Date.parse(new Date()).toString()},
            name: {S: 'test'},
            description: {S: 'abc'},
            FlowEvent: {"M": {"Name": {"S": "AAA"}, "Age": {"N": "999"}}},
            createdAt: {S: (new Date()).toISOString()},
            updatedAt: {S: (new Date()).toISOString()}
        },
        TableName: process.env.TODOTABLE
    }

    // Put Item into DynamoDB
    try {
        await ddb.putItem(params).promise()
        console.log('Success')
    } catch (err) {
        console.log('Error', err)
    }
};
