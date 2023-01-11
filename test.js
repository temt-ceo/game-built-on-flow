/* Amplify Params - DO NOT EDIT
	API_FLOWEVENTS_GRAPHQLAPIENDPOINTOUTPUT
	API_FLOWEVENTS_GRAPHQLAPIIDOUTPUT
	API_FLOWEVENTS_GRAPHQLAPIKEYOUTPUT
	ENV
	REGION
Amplify Params - DO NOT EDIT */

const GRAPHQL_ENDPOINT = process.env.API_FLOWEVENTS_GRAPHQLAPIENDPOINTOUTPUT
const GRAPHQL_API_KEY = process.env.API_FLOWEVENTS_GRAPHQLAPIIDOUTPUT

const query = /* GraphQL */ `
  mutation CreateTodo(
      $input: CreateTodoInput!
      $condition: ModelTodoConditionInput
    ) {
    createTodo(input: $input, condition: $condition) {
      id
      name
      description
      createdAt
      updatedAt
      owner
    }
  }
`

/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async () => {
    let statusCode = 200
    let body
    let response

    const variables = {
      input: {
        name: 'Hello, Todo!',
        description: 'This is from Lambda!'
      }
    }

    const options = {
      method: 'POST',
      headers: {
        'x-api-key': GRAPHQL_API_KEY
      },
      body: JSON.stringify({ query, variables })
    }


    try {
      response = await fetch(GRAPHQL_ENDPOINT, options)
      body = await response.json()
      if (body.errors) statusCode = 401
    } catch (error) {
      statusCode = 400
      body = {
        errors: [
          {
            status: response.status,
            message: error.message,
            stack: error.stack
          }
        ]
      }
    }

    console.log(`Status: ${JSON.stringify(statusCode)}, Body: ${JSON.stringify(body)}, Variables: ${JSON.stringify(variables)}`)

    return {
      statusCode,
      body: JSON.stringify(body)
    }
}  
