/* eslint-disable */
// this is an auto generated file. This will be overwritten

export const getTodo = /* GraphQL */ `
  query GetTodo($id: ID!) {
    getTodo(id: $id) {
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
`;
export const listTodos = /* GraphQL */ `
  query ListTodos(
    $filter: ModelTodoFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listTodos(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
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
      nextToken
    }
  }
`;
export const getBCGGameServerProcess = /* GraphQL */ `
  query GetBCGGameServerProcess($id: ID!) {
    getBCGGameServerProcess(id: $id) {
      id
      type
      message
      playerId
      createdAt
      updatedAt
    }
  }
`;
export const listBCGGameServerProcesses = /* GraphQL */ `
  query ListBCGGameServerProcesses(
    $filter: ModelBCGGameServerProcessFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listBCGGameServerProcesses(
      filter: $filter
      limit: $limit
      nextToken: $nextToken
    ) {
      items {
        id
        type
        message
        playerId
        createdAt
        updatedAt
      }
      nextToken
    }
  }
`;
