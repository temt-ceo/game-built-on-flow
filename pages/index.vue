<template>
  <div class="flex">
    <div>
      <h2>Hello! {{ address }}</h2>
      <h2>GraphQL App</h2>
      <p><label>Name :</label><input v-model="name" /></p>
      <p><label>Description :</label><input v-model="description" /></p>
      <p><button @click="createTodo">Create</button></p>
      <p><button @click="flowWalletSignIn">Wallet Sign In</button><button @click="flowWalletSignOut">Wallet Sign Out</button></p>
    </div>
    <div>
      <p v-if="address && hasNFT">
        <h3>Hi {{ nickname }}</h3>
        <img :src="imagepath" />
        <h3>Your NFT</h3>
        <div><button v-if="!showClearingHouse" @click="showClearingHouse = true">Show Clearing House</button></div>
        <div><button v-if="showClearingHouse" @click="showClearingHouse = false">Close Clearing House</button></div>
        <div><button @click="sellNFT = false">Sell at the NFT exchange</button></div>
        
        <div v-if="showClearingHouse">
          <h3>Who's NFT do you buy?</h3>
          {{ nftSeller }} <button v-if="nftSeller !== ''" @click="showListings">Show</button>
          <div v-for="owner, addr in nftOwners" :key="addr" class="flex">
            <input v-if="addr !== address" type="radio" id="seller" name="seller" :value="addr" v-model="nftSeller" />
            <div v-if="addr !== address">
              <div>
                Owner: <b>{{ owner[0].nickname }}</b>
                Address: <b>{{ addr }}</b><br>
                Type: {{ owner[0].imagepath === '/img/knight.jpeg' ? 'Human' : 'Animal' }}
              </div>
            </div>
          </div>
          <ul>
            <li v-for="nft in onSaleList" :key="nft.id">
              {{ nft.name }} To: {{ nft.to }}<br>
              Amount: <span>{{ nft.flowEvent.data.data.amount }}</span>
              $FLOW at {{ nft.flowEvent.data.datetime }}
            </li>
          </ul>
        </div>
      </p>
      <p v-if="address && !hasNFT">
        <img v-if="nftType === 'human'" src="/img/knight.jpeg" />
        <img v-if="nftType === 'animal'" src="/img/dog.jpeg" />
        <h3>Enter your nickname:</h3>
        <div><input type="text" v-model="nickname" /></div>
        <h3>Choose NFT Type:</h3>
        <div style="margin-bottom:20px">
          <input type="radio" id="type" name="human" value="human" v-model="nftType" />
          <label for="human">Human</label>
          <input type="radio" id="type" name="animal" value="animal" v-model="nftType" />
          <label for="animal">Animal</label>
        </div>
        <div><button @click="requestFirstNFT" :disabled="nickname === ''">Request First NFT</button></div>
      </p>
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
img {
  width: 260px;
}
</style>

<script>
import { Auth, API } from 'aws-amplify'
import { createTodo } from '~/src/graphql/mutations'
import { listTodos } from '~/src/graphql/queries'
import { onCreateTodo } from '~/src/graphql/subscriptions'
import FlowTransactions from '~/cadence/transactions'
import FlowScripts from '~/cadence/scripts'
export default {
  data() {
    return {
      name: '',
      description: '',
      todos: [],
      walletUser: {},
      address: '',
      hasNFT: false,
      nftType: 'human',
      nickname: '',
      imagepath: '',
      showClearingHouse: false,
      onSaleList: [],
      nftOwners: [],
      nftSeller: ''
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
    async showListings () {
      const result = await this.$fcl.query({
        cadence: FlowScripts.getOnsaleNFTs,
        args: (arg, t) => [
          arg(this.nftSeller, t.Address)
        ]
      })
      console.log(result)
    },
    async sellNFT () {
      const ret = window.prompt('Please enter the price as it will be sold at the NFT exchange.')
    },
    async requestFirstNFT () {
      if (!this.walletUser?.addr) {
        alert('Please sign in a Flow Wallet.')
        return
      } else {
        const imagepath = this.nftType === 'human' ? '/img/knight.jpeg' : '/img/dog.jpeg'
        const transactionId = await this.$fcl.mutate({
          cadence: FlowTransactions.setupNFTResourceForNFTClearingHouse,
          args: (arg, t) => [
            arg(this.nickname, t.String),
            arg(imagepath, t.String),
          ],
          proposer: this.$fcl.authz,
          payer: this.$fcl.authz,
          authorizations: [this.$fcl.authz],
          limit: 999
        })
        console.log(`TransactionId: ${transactionId}`)
        this.checkTransactionComplete()
      }
    },
    setupWalletInfo (user) {
      this.walletUser = user
      if (this.walletUser?.addr) {
        this.address = this.walletUser?.addr
        this.get1stNFTs()
      }
    },
    async get1stNFTs() {
        const result = await this.$fcl.query({
          cadence: FlowScripts.get1stMints,
          args: (arg, t) => [
          ]
        })
        if (result[this.address]) {
          this.hasNFT = true
          this.imagepath = result[this.address][0].imagepath
        } else {
          this.hasNFT = false
        }
        this.nftOwners = result
        return this.hasNFT
    },
    checkTransactionComplete () {
      const timerID = setInterval(async () => {
        const result = await this.get1stNFTs()
        if (result) {
          clearInterval(timerID)
        }
      }, 3000)
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
 