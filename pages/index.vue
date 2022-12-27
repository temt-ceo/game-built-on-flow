<template>
  <div class="flex">
    <div>
      <h2>GraphQL App</h2>
      <h3>Hello! {{ address }}</h3>
      <p><label>Name :</label><input v-model="name" /></p>
      <p><label>Description :</label><input v-model="description" /></p>
      <p><button @click="createTodo">Create</button></p>
      <p>
        <button @click="flowWalletLogin">Wallet Log In</button>
        <button @click="flowWalletLogout">Wallet Log Out</button>
      </p>
      <img src="/img/knight.jpeg" />
    </div>
    <div>
      <div><button @click="flowWalletLogin">Wallet Log In</button></div>
      <div><button @click="flowWalletLogout">Wallet Log Out</button></div>
      <div><button @click="flowWalletLogin">交換所に出品</button></div>
      <div><button @click="flowWalletLogin">出品の取り消し</button></div>
      <ul>
        <li v-for="todo in todos" :key="todo.id">
          {{ todo.name }} : {{ todo.description }}
        </li>
      </ul>
    </div>
  </div>
</template>
<style scoped>
.flex {
  display: flex;
}
.flex > div > div {
  margin-top: 20px;
}
p {
  margin: 8px auto;
}
button {
  border: solid;
  padding: 8px;
  margin-right: 8px;
}
</style>

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
      walletUser: {},
    }
  },
  async created() {
    this.$fcl.currentUser.subscribe(this.setupWalletInfo)

    const currentAuthUser = await Auth.currentAuthenticatedUser();

    const session = await Auth.userSession(currentAuthUser);

    if (!session?.isValid()) {
      console.error('セッションが無効です!')
    };
    this.getTodos()
    this.subscribe()
  },
  methods: {
    setupWalletInfo (user) {
      this.walletUser = user

      if (this.walletUser?.addr) {
        this.address = this.walletUser?.addr
      }
    },

    async flowWalletLogin () {
      await this.$fcl.authenticate()
    },
    async flowWalletLogout () {
      await this.$fcl.unauthenticate()
    },
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
        console.log(todos)
        this.todos = todos.data.listTodos.items
      }).catch((err) => {
        console.log('Error:', err)
      })
    },
    subscribe() {
      console.log('subscribe start.')
      API.graphql({ query: onCreateTodo }).subscribe({
        next: (eventData) => {
          console.log('Data Added..', eventData)
          const todo = eventData.value.data.onCreateTodo
          if (this.todos.some((item) => item.name === todo.name)) return // remove duplications
          this.todos = [...this.todos, todo]
        },
      })
    },
  },
}
</script>