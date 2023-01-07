<template>
  <div class="flex">
    <div>
      <h2>Hello! {{ address }}</h2>
      <h2>GraphQL App</h2>
      <p><label>Name :</label><input v-model="name" /></p>
      <p><label>Description :</label><input v-model="description" /></p>
      <p><button @click="createTodo">Create</button></p>
      <p><button @click="flowWalletSignIn">Wallet Sign In</button><button @click="flowWalletSignOut">Wallet Sign Out</button></p>
      <p><button @click="requestFirstNFT">Request First NFT</button></p>
    </div>
    <div>
      <ul>
        <li v-for="todo in todos" :key="todo.id">
          {{ todo.flowEvent.name }} To: {{ todo.flowEvent.data.data.to }}<br>
          Amount: <span>{{ todo.flowEvent.data.data.amount }}</span>
          $FLOW at {{ todo.flowEvent.data.datetime }}
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
li {
  margin: 20px;
}
li > span {
  color: red;
}
</style>

<script>
import { Auth, API } from 'aws-amplify'
import { createTodo } from '~/src/graphql/mutations'
import { listTodos } from '~/src/graphql/queries'
import { onCreateTodo } from '~/src/graphql/subscriptions'
import FlowTransactions from '~/cadence/transactions'
export default {
  data() {
    return {
      name: '',
      description: '',
      todos: [],
      walletUser: {},
      address: '',
    }
  },
  async created() {
    this.$fcl.currentUser.subscribe(this.setupWalletInfo)

    const currentAuthUser = await Auth.currentAuthenticatedUser();

    const session = await Auth.userSession(currentAuthUser);

    if (!session?.isValid()) {
      console.error('セッションが無効です。')
    };
    this.getTodos()
    this.subscribe()
  },
  methods: {
    async requestFirstNFT () {
      if (!this.walletUser?.addr) {
        alert('Please sign in a Flow Wallet.')
        return
      } else {
        const transactionId = await this.$fcl.mutate({
          cadence: FlowTransactions.setupNFTResourceForNFTClearingHouse,
          args: (arg, t) => [
          ],
          proposer: this.$fcl.authz,
          payer: this.$fcl.authz,
          authorizations: [this.$fcl.authz],
          limit: 999
        })
        console.log(`TransactionId: ${transactionId}`)
      }
    },
    setupWalletInfo (user) {
      this.walletUser = user
      if (this.walletUser?.addr) {
        this.address = this.walletUser?.addr
      }
    },
    async flowWalletSignIn () {
      await this.$fcl.authenticate()
    },
    async flowWalletSignOut () {
      await this.$fcl.unauthenticate()
      this.address = ''
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
        this.todos = todos.data.listTodos.items
        this.todos.forEach((todo) => {
          todo.flowEvent.data = JSON.parse(todo.flowEvent.data)
          const dateObj = new Date(todo.flowEvent.data.blockTimestamp)
          todo.flowEvent.data.datetime =
            dateObj.getFullYear() + '/' + (dateObj.getMonth() + 1) + '/' +
            dateObj.getDate() + ' ' + dateObj.getHours() + ':' +
            dateObj.getMinutes() + ':' + dateObj.getSeconds()
          console.log(todo.flowEvent.data)
        })
      }).catch((err) => {
        console.log('Error:', err)
      })
    },
    subscribe() {
      API.graphql({ query: onCreateTodo }).subscribe({
        next: (eventData) => {
          const todo = eventData.value.data.onCreateTodo
          todo.flowEvent.data = JSON.parse(todo.flowEvent.data)
          const dateObj = new Date(todo.flowEvent.data.blockTimestamp)
          todo.flowEvent.data.datetime =
            dateObj.getFullYear() + '/' + (dateObj.getMonth() + 1) + '/' +
            dateObj.getDate() + ' ' + dateObj.getHours() + ':' +
            dateObj.getMinutes() + ':' + dateObj.getSeconds()
          this.todos = [...this.todos, todo]
        },
      })
    },
  },
}
</script>