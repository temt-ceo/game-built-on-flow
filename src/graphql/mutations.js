/* eslint-disable */
// this is an auto generated file. This will be overwritten

export const createTodo = /* GraphQL */ `
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
`;
export const updateTodo = /* GraphQL */ `
  mutation UpdateTodo(
    $input: UpdateTodoInput!
    $condition: ModelTodoConditionInput
  ) {
    updateTodo(input: $input, condition: $condition) {
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
export const deleteTodo = /* GraphQL */ `
  mutation DeleteTodo(
    $input: DeleteTodoInput!
    $condition: ModelTodoConditionInput
  ) {
    deleteTodo(input: $input, condition: $condition) {
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
export const createBCGGameServerProcess = /* GraphQL */ `
  mutation CreateBCGGameServerProcess(
    $input: CreateBCGGameServerProcessInput!
    $condition: ModelBCGGameServerProcessConditionInput
  ) {
    createBCGGameServerProcess(input: $input, condition: $condition) {
      id
      type
      message
      playerId
      createdAt
      updatedAt
    }
  }
`;
export const updateBCGGameServerProcess = /* GraphQL */ `
  mutation UpdateBCGGameServerProcess(
    $input: UpdateBCGGameServerProcessInput!
    $condition: ModelBCGGameServerProcessConditionInput
  ) {
    updateBCGGameServerProcess(input: $input, condition: $condition) {
      id
      type
      message
      playerId
      createdAt
      updatedAt
    }
  }
`;
export const deleteBCGGameServerProcess = /* GraphQL */ `
  mutation DeleteBCGGameServerProcess(
    $input: DeleteBCGGameServerProcessInput!
    $condition: ModelBCGGameServerProcessConditionInput
  ) {
    deleteBCGGameServerProcess(input: $input, condition: $condition) {
      id
      type
      message
      playerId
      createdAt
      updatedAt
    }
  }
`;
