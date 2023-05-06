/* Amplify Params - DO NOT EDIT
	API_FLOWEVENTS_GRAPHQLAPIENDPOINTOUTPUT
	API_FLOWEVENTS_GRAPHQLAPIIDOUTPUT
	API_FLOWEVENTS_GRAPHQLAPIKEYOUTPUT
	ENV
	REGION
Amplify Params - DO NOT EDIT */

import * as fcl from "@onflow/fcl"
import crypto from '@aws-crypto/sha256-js';
import { defaultProvider } from '@aws-sdk/credential-provider-node';
import { SignatureV4 } from '@aws-sdk/signature-v4';
import { HttpRequest } from '@aws-sdk/protocol-http';
import { default as fetch, Request } from 'node-fetch';
import { DynamoDBClient, GetItemCommand, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { marshall, unmarshall } from "@aws-sdk/util-dynamodb";
const dbclient = new DynamoDBClient({ region: process.env.REGION})

fcl.config({
  "accessNode.api": "https://rest-testnet.onflow.org"
})

const GRAPHQL_ENDPOINT = process.env.API_FLOWEVENTS_GRAPHQLAPIENDPOINTOUTPUT;
const AWS_REGION = process.env.AWS_REGION || 'us-east-1';
const { Sha256 } = crypto;

const query = /* GraphQL */ `
  query LIST_TODOS {
    listTodos {
      items {
        id
        name
        description
      }
    }
  }
`;

const mutate = /* GraphQL */ `
  mutation CreateTodo(
      $input: CreateTodoInput!
      $condition: ModelTodoConditionInput
    ) {
    createTodo(input: $input, condition: $condition) {
      id
      name
      description
      flowEvent {
        name
        data
      }
      createdAt
      updatedAt
    }
  }
`

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */

 export const handler = async (event) => {
  console.log(`EVENT: ${JSON.stringify(event)}`);

  const address = '9e447fb949c3f1b6'
  const contractName = 'CodeOfFlowAlpha4'
  const eventName = 'BattleSequence'
  const flowEventData = []

  const fetchEvents = async() => {
    const latestBlock = await fcl.send([
      fcl.getBlock(true)
    ]).then(fcl.decode)

    console.log(`latestBlockHeight: ${latestBlock.height}`)

    let toBlockHeight = latestBlock.height - 10

    let fromBlockHeight = null
    // Get Item into DynamoDB
    const params = {
      Key: marshall({
        id: "latestBlockHeight",
      }),
      TableName: process.env.TODOTABLE
    }
    const dataFromDynamo = await dbclient.send(new GetItemCommand(params))
    if (!dataFromDynamo.Item) {
      fromBlockHeight = toBlockHeight - 200
    } else {
      fromBlockHeight = unmarshall(dataFromDynamo.Item)?.height
      if (toBlockHeight - fromBlockHeight > 250) {
        fromBlockHeight = toBlockHeight - 200
      }  
    }

    // Put Item into DynamoDB
    try {
      const params = {
        Item: {
          id: {"S": "latestBlockHeight"},
          height: {"N": toBlockHeight.toString()},
        },
        TableName: process.env.TODOTABLE
      }
      await dbclient.send(new PutItemCommand(params))
    } catch (err) {
    }

    const events = await fcl.send([
      fcl.getEventsAtBlockHeightRange(`A.${address}.${contractName}.${eventName}`,
        fromBlockHeight, toBlockHeight)
    ]).then(fcl.decode)
    events.forEach((eventObj) => {
      if (eventObj) {
        flowEventData.push(eventObj)
      }
    })
  }
  await fetchEvents()

  const endpoint = new URL(GRAPHQL_ENDPOINT);

  const signer = new SignatureV4({
    credentials: defaultProvider(),
    region: AWS_REGION,
    service: 'appsync',
    sha256: Sha256
  });

  const variables = {
    input: {
      name: 'Hello, Todo!',
      description: 'This is from Lambda!',
      flowEvent: { name: eventName, data: JSON.stringify(flowEventData)}
    }
  }

  const requestToBeSigned = new HttpRequest({
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      host: endpoint.host
    },
    hostname: endpoint.host,
    body: JSON.stringify({ query: mutate, variables }),
    path: endpoint.pathname
  });

  const signed = await signer.sign(requestToBeSigned);
  const request = new Request(endpoint, signed);

  let statusCode = 200;
  let body = {};
  let response;

  try {
    if (flowEventData.length) {
      response = await fetch(request);
      body = await response.json();
      if (body.errors) statusCode = 400;
    }
  } catch (error) {
    statusCode = 500;
    body = {
      errors: [
        {
          message: error.message
        }
      ]
    };
  }

  return {
    statusCode,
    //  Uncomment below to enable CORS requests
    // headers: {
    //   "Access-Control-Allow-Origin": "*",
    //   "Access-Control-Allow-Headers": "*"
    // }, 
    body: JSON.stringify(body)
  };
};