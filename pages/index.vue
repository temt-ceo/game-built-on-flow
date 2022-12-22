<template>
  <div>
    <h1>GraphQL App</h1>
    <p><label for="name">Name :</label><input v-model="name" id="Name" /></p>
    <p><label for="Description">Description :</label><input v-model="description" id="Description" /></p>
    <p><button style="border: solid; padding: 10px;" @click="createTodo">Create</button></p>
    <ul>
      <li v-for="todo in todos" :key="todo.id">
        {{ todo.name }} : {{ todo.description }}
      </li>
    </ul>
  </div>
</template>

<script>
import { Auth, API } from 'aws-amplify'
import { createTodo } from '~/src/graphql/mutations'
import { listTodos } from '~/src/graphql/queries'
import { onCreateTodo } from '~/src/graphql/subscriptions'

export default {
  data() {
    return {
      name: '',
      description: '',
      todos: [],
    }
  },
  async created() {

    const currentAuthUser = await Auth.currentAuthenticatedUser();

    const session = await Auth.userSession(currentAuthUser);

    if (!session?.isValid()) {
      console.error('セッションが無効です!')
    };
    this.getTodos()
    this.subscribe()
  },
  methods: {
    async createTodo() {
      const { name, description } = this
      if (!name || !description) return false
      const todo = { name, description }
      console.log(todo)
      await API.graphql({
        query: createTodo,
        variables: { input: todo },
      }).then((res) => {
        console.log(res)
      }).catch((err) => {
        console.log('Error:', err)
      })
      this.name = ''
      this.description = ''
    },
    async getTodos() {
      await API.graphql({
        query: listTodos,
      }).then((todos) => {
        console.log(todos.data.listTodos.items)
        this.todos = todos.data.listTodos.items
      }).catch((err) => {
        console.log('Error:', err)
      })
    },
    subscribe() {
      API.graphql({ query: onCreateTodo }).subscribe({
        next: (eventData) => {
          const todo = eventData.value.data.onCreateTodo
          if (this.todos.some((item) => item.name === todo.name)) return // remove duplications
          this.todos = [...this.todos, todo]
        },
      })
    },
  },
}
</script>