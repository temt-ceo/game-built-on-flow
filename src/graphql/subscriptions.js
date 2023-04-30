/* eslint-disable */
// this is an auto generated file. This will be overwritten

export const onCreateByPlayerid = /* GraphQL */ `
  subscription OnCreateByPlayerid($playerId: String!) {
    onCreateByPlayerid(playerId: $playerId) {
      id
      type
      message
      playerId
      createdAt
      updatedAt
    }
  }
`;
export const onCreateTodo = /* GraphQL */ `
  subscription OnCreateTodo($filter: ModelSubscriptionTodoFilterInput) {
    onCreateTodo(filter: $filter) {
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
export const onUpdateTodo = /* GraphQL */ `
  subscription OnUpdateTodo($filter: ModelSubscriptionTodoFilterInput) {
    onUpdateTodo(filter: $filter) {
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
export const onDeleteTodo = /* GraphQL */ `
  subscription OnDeleteTodo($filter: ModelSubscriptionTodoFilterInput) {
    onDeleteTodo(filter: $filter) {
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
export const onCreateBCGGameServerProcess = /* GraphQL */ `
  subscription OnCreateBCGGameServerProcess(
    $filter: ModelSubscriptionBCGGameServerProcessFilterInput
  ) {
    onCreateBCGGameServerProcess(filter: $filter) {
      id
      type
      message
      playerId
      createdAt
      updatedAt
    }
  }
`;
export const onUpdateBCGGameServerProcess = /* GraphQL */ `
  subscription OnUpdateBCGGameServerProcess(
    $filter: ModelSubscriptionBCGGameServerProcessFilterInput
  ) {
    onUpdateBCGGameServerProcess(filter: $filter) {
      id
      type
      message
      playerId
      createdAt
      updatedAt
    }
  }
`;
export const onDeleteBCGGameServerProcess = /* GraphQL */ `
  subscription OnDeleteBCGGameServerProcess(
    $filter: ModelSubscriptionBCGGameServerProcessFilterInput
  ) {
    onDeleteBCGGameServerProcess(filter: $filter) {
      id
      type
      message
      playerId
      createdAt
      updatedAt
    }
  }
`;
