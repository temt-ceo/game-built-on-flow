<template>
  <div class="game-screen">
    <div class="content top-screen">
      <v-chip
        v-if="newEventAlertChip"
        class="ma-2"
        color="red"
        text-color="white"
      >
        {{ newEventAlert }}
      </v-chip>
      <div class="top-screen">
        <div v-if="onMatching === 1" class="matching-screen">
          <h1>A.C.T.I.S:</h1>
          <div style="padding: 0 20px;">
            You will infiltrate Arcana.<br>
            Your mission is to search for the enemy and keep Arcana safe.<br>
            <br>
          </div>
          <div v-if="!address" style="padding: 0 20px;">
            To fight the enemy and earn rewards, you register your battle record information in the blockchain.<br>
            Connect to the blockchain and register your information on the blockchain.
          </div>
          <div v-if="address && registered" style="padding: 0 20px;">
            Press the matching button below.
          </div>
          <div v-if="address && !registered" style="padding: 0 20px;">
            Player information has not yet been created on the blockchain.<br>Please press the Create Player button below.
          </div>
          <div v-if="matchingTimeup">
            タイムアップしました。もう一度マッチングボタンを押してください。
          </div>
          <!-- <v-dialog
            v-model="loadingDialog"
            transition="dialog-top-transition"
            width="auto"
            loading
            loading-text="Loading... Please wait"
          >
              <v-card>
                <v-toolbar
                  color="primary"
                  title="Creating Player Info.."
                ></v-toolbar>
                <v-card-text>
                  <div class="text-h6 pa-12">Loading... Please wait</div>
                </v-card-text>
              </v-card>
          </v-dialog> -->
          <p>
            <span style="margin: 20px auto; display: block; width: 130px;">
              <v-btn v-if="!address" prepend-icon="mdi-vuetify" @click="flowWalletSignIn">
                CONNECT
              </v-btn>
            </span>
            <span style="margin: 20px auto; display: block; width: 170px;">
              <v-btn v-if="address && !registered" prepend-icon="mdi-vuetify" @click="createPlayer">
                Create Player
              </v-btn>
            </span>
            <div v-if="address && registered" class="text-center">
              <v-btn
                :disabled="matchingDialog"
                :loading="matchingDialog"
                color="purple-darken-2"
                prepend-icon="mdi-vuetify"
                @click="playerMatching"
              >
              Matching
              </v-btn>
              <div v-if="matchingDialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;">
                <div class="v-overlay__content" style="width: auto;">
                  <div class="v-card v-theme--light bg-primary v-card--density-default v-card--variant-elevated">
                    <div class="v-card__loader"><div class="v-progress-linear v-theme--light" role="progressbar" aria-hidden="true" aria-valuemin="0" aria-valuemax="100" style="top: 0px; height: 0px; --v-progress-linear-height:2px; left: 50%; transform: translateX(-50%);">
                      <div class="v-progress-linear__background" style="width: 100%;"></div><div class="v-progress-linear__indeterminate"><div class="v-progress-linear__indeterminate long"></div><div class="v-progress-linear__indeterminate short"></div>
                    </div>
                    </div>
                  </div>
                  <div class="v-card-text"> Please stand by <div class="v-progress-linear v-progress-linear--active v-theme--light mb-0" role="progressbar" aria-hidden="false" aria-valuemin="0" aria-valuemax="100" style="top: 0px; height: 4px; --v-progress-linear-height:4px; left: 50%; transform: translateX(-50%);">
                    <div class="v-progress-linear__background bg-white" style="width: 100%;"></div>
                    <div class="v-progress-linear__indeterminate">
                      <div class="v-progress-linear__indeterminate long bg-white"></div>
                      <div class="v-progress-linear__indeterminate short bg-white"></div>
                    </div></div></div><span class="v-card__underlay"></span>
                  </div>
                </div>
              </div>
            </div>
          </p>
          <v-timeline align="start">
            <v-timeline-item
              v-for="(item, i) in timeline"
              :key="i"
              :dot-color="item.color"
              :icon="item.icon"
              fill-dot
            >
              <v-card>
                <v-card-title v-if="i + 1 < timeline.length" :class="['text-h8', `bg-${item.color}`]" style="font-style: italic;">
                  Completed!
                </v-card-title>
                <v-card-title v-if="i + 1 == timeline.length" :class="['text-h8', `bg-${item.color}`]" style="font-style: italic;">
                  Now on task
                </v-card-title>
                <v-card-text class="bg-white text--primary">
                  <p style="font-style:italic">{{ item.message }}</p>
                </v-card-text>
              </v-card>
            </v-timeline-item>
          </v-timeline>
        </div>
        <v-card>
        </v-card>

        <audio id="audio1" src="/audio/coj_music_matching.mp3"></audio>
        <audio id="audio2" src="/audio/coj_music_on_battle.mp3"></audio>
        <video v-if="onMatching <= 2" v-show="onMatching === 2" id="video1" style="width: 100vw; min-height: 100%;" controls="controls">
          <source src="/video/coj_matching_movie.mov">
        </video>
        <div v-if="onMatching === 3" class="main-screen">
          <div style="display: flex;">
            <div>
              <span>Opponent: LIFE {{ enemy_life }} <i v-for="i in enemy_life">🔹</i></span><br>
              <span style="padding-left:40px;">
                CP 0{{ enemy_cp }}
              </span><br>
              <span style="padding-left:40px;">
                Dead: {{ enemy_dead_cards.length }}
              </span>
            </div>
            <div style="margin-left: 30px;">
              <span>Deck: {{ enemy_deck }}</span><br>
              <span>
                Hand {{ enemy_hand }} <i v-for="i in enemy_hand">🔸</i>
              </span><br>
              Triger Zone
              <span v-for="i in triggers_boxes">
                <i v-if="i>enemy_triggers">🔲</i>
                <i v-else>🔳</i>
              </span>
            </div>
          </div>
          <div id="field">
            <div class="rival_cards">
              <v-row>
                <v-col
                  v-for="n in enemy_field_cards"
                  cols="2.5"
                >
                  <v-img
                    :src="`/img/cards/card_${enemy_field_cards[n]}.jpeg`"
                    aspect-ratio="0.65"
                    cover
                    @click="showCardInfo(enemy_field_cards[n], 4, n)"
                  ></v-img>
                </v-col>
              </v-row>
            </div>
            <div class="your_cards">
              <v-row>
                <v-col
                  v-for="n in your_field_cards"
                  cols="2.5"
                >
                  <v-img
                    :src="`/img/cards/card_${your_field_cards[n]}.jpeg`"
                    aspect-ratio="0.65"
                    cover
                    @click="showCardInfo(your_field_cards[n], 3, n)"
                  ></v-img>
                </v-col>
              </v-row>
            </div>
          </div>
          <div class="your_hands">
            <div style="width: 205px;">
              <span>You: LIFE {{ your_life }}  <i v-for="i in your_life">🔹</i></span><br>
              <span style="padding-left:40px;">
                CP 0{{ your_cp }}
              </span><br>
              <span style="padding-left:40px;">
                Dead: {{ your_dead_cards.length }}
              </span><br>
              <span style="padding-left:40px;">Deck: {{ your_deck }}</span>
            </div>
            <div style="margin-left: 20px; min-width: 150px;">
              Triger Zone
              <v-row>
                <v-col
                  v-for="n in your_triggers"
                  cols="3.5"
                >
                  <v-img
                    :src="`/img/cards/card_${your_triggers[n]}.jpeg`"
                    aspect-ratio="0.65"
                    cover
                    @click="showCardInfo(your_triggers[n], 2, n)"
                  ></v-img>
                </v-col>
              </v-row>
            </div>
          </div>
          <div class="your_hands">
            <v-row>
              <v-col
                v-for="n in 7"
                cols="1.6"
              >
                <v-img
                  :src="`/img/cards/card_${your_hand[n]}.jpeg`"
                  aspect-ratio="0.65"
                  cover
                  @click="showCardInfo(your_hand[n], 1, n)"
                ></v-img>
              </v-col>
            </v-row>
          </div>
          <div>
            Card Information<br>
            <span>{{ display_cardinfo }}</span>
          </div>
        </div>

        <div>
          <h2>Hello! {{ attrs.player.username }}</h2>
          <p v-if="address && hasNFT">
            <h3>Hi {{ nickname }}</h3>
            <div><button v-if="!showClearingHouse" @click="showClearingHouse = true">Show Clearing House</button></div>
            <div><button v-if="showClearingHouse" @click="showClearingHouse = false">Close Clearing House</button></div>
            <div><button @click="sellNFT = false">Sell at the NFT exchange</button></div>
            
            <div v-if="false">
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
          <p v-if="false">
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
      </div>
    </div>
    <div class="header-bar">
      <div v-if="onMatching === 3" class="remaining_time">
        TIME: {{ turn_timer }}
      </div>
      <div v-if="onMatching === 2" class="remaining_time">
        {{ matching_time_second }}
      </div>
    </div>
  </div>
  <v-btn
    v-if="display_cardinfo != '' && (this.display_card_type === 1 || this.display_card_type === 3)"
    class="ma-1"
    color="purple"
    icon="mdi-call-split"
    @click="showBattleDialogWindow"
    style="position: absolute; bottom: 40px; left: -5px;"
  ></v-btn>
  <v-row justify="center">
    <div v-if="marigan_dialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;"><div class="v-overlay__scrim"></div><div class="v-overlay__content" style="width: auto;"><div class="v-card v-theme--light v-card--density-default v-card--variant-elevated"><!----><div class="v-card__loader"><div class="v-progress-linear v-theme--light" role="progressbar" aria-hidden="true" aria-valuemin="0" aria-valuemax="100" style="top: 0px; height: 0px; --v-progress-linear-height:2px; left: 50%; transform: translateX(-50%);"><!----><div class="v-progress-linear__background" style="width: 100%;"></div><div class="v-progress-linear__indeterminate"><div class="v-progress-linear__indeterminate long"></div><div class="v-progress-linear__indeterminate short"></div></div><!----></div></div><!----><!----><header class="v-toolbar v-toolbar--density-default bg-primary v-theme--light"><!----><div class="v-toolbar__content" style="height: 64px;"><!----><div class="v-toolbar-title">
      <div class="v-toolbar-title__placeholder">Do you want to redraw the card?<!----></div></div><!----><!----></div><!----></header><div class="v-card-text">
        <div class="text-h2 pa-12" style="padding: 25px !important;">
          0{{ marigan_time_second }}"<span style="margin-right:35px">{{ marigan_time_millisecond_1 }}{{ marigan_time_millisecond_2 }}</span>
        <span class="marigan_buttons">
        <v-btn
          icon="mdi-thumb-up"
          color="error"
          @click="marigan_dialog = false"
          style="margin: 0 25px;"
        >No</v-btn>
        <v-btn
          icon="mdi-thumb-up"
          color="success"
          @click="marigan"
          style="margin: 0 25px;"
        >YES</v-btn>
        </span></div>
        <div>
          <v-row>
            <v-col
              v-for="n in marigan_cards[marigan_count].length"
              cols="2.5"
            >
              <span style="opacity: 0">{{ marigan_cards[marigan_count] }}</span>
              <v-img
                :src="`/img/cards/card_${marigan_cards[marigan_count][n-1]}.jpeg`"
                aspect-ratio="0.65"
                cover
              ></v-img>
            </v-col>
          </v-row>
        </div>
      </div><!----><!----><span class="v-card__underlay"></span>
    </div></div></div>
    <v-dialog
      v-model="show_battle_dialog"
      persistent
      width="auto"
    >
      <v-card>
        <v-card-title class="text-h5">
          <div class="dialog_title" v-if="!enemyAttack && display_card_type === 1">
            Do you put this card on the FIELD?
          </div>
          <div class="dialog_title" v-if="!enemyAttack && display_card_type === 3">
            Do you attack using this card?
          </div>
          <div class="dialog_title" v-if="enemyAttack">
            Enemy draws near! What to do?
          </div>
        </v-card-title>
        <v-img
          v-if="enemyAttack"
          :src="`/img/cards/card_${selected_card_id}.jpeg`"
          aspect-ratio="0.65"
          cover
          class="attack-anime"
          style="width: 250px; margin: 0 auto;"
        ></v-img>
        <v-img
          v-if="!enemyAttack"
          :src="`/img/cards/card_${selected_card_id}.jpeg`"
          aspect-ratio="0.65"
          cover
          style="width: 250px; margin: 0 auto;"
        ></v-img>
        <v-card-text>Let Google help apps determine location. This means sending anonymous location data to Google, even when no apps are running.</v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="green-darken-1"
            variant="text"
            @click="show_battle_dialog = false"
          >
            No
          </v-btn>
          <v-btn
            color="green-darken-1"
            variant="text"
            @click="cardMoveDecided"
          >
            Yes
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>
<script>
import { Auth, API } from 'aws-amplify'
import { createTodo } from '~/src/graphql/mutations'
import { onCreateTodo } from '~/src/graphql/subscriptions'
import FlowTransactions from '~/cadence/transactions'
import FlowScripts from '~/cadence/scripts'
import { useAttrs } from 'vue'
import { collapseTextChangeRangesAcrossMultipleVersions } from 'typescript'
import { ConsoleLogger } from '@aws-amplify/core'
export default {
  data() {
    return {
      walletUser: {},
      loadingDialog: false,
      registered: null,
      newEventAlertChip: false,
      newEventAlert: '',
      onMatching: 1,
      timeline: [
        {
          color: 'red-lighten-2',
          icon: 'mdi-star',
          message: 'Initial registration completed.'
        },
        {
          color: 'purple-lighten-2',
          icon: 'mdi-book-variant',
          message: 'Blockchain connection NOT completed.'
        },
        // {
        //   color: 'indigo-lighten-2',
        //   icon: 'mdi-buffer',
        // },
      ],
      matchingDialog: false,
      matchingTimeup: false,
      matching_time_second: '',
      marigan_time_second: 5,
      marigan_time_millisecond_1: 0,
      marigan_time_millisecond_2: 0,
      marigan_dialog: false,
      marigan_cards: [],
      marigan_count: 0,
      turn_timer: 60,
      your_life: 7,
      enemy_life: 7,
      your_cp: 2,
      enemy_cp: 2,
      your_deck: 36,
      enemy_deck: 36,
      your_hand: {},
      enemy_hand: 7,
      triggers_boxes: 4,
      your_triggers: {1: 1, 2: 2, 3: null, 4: null},
      enemy_triggers: 2,
      your_field_cards: {1: 1, 2: 2, 3: null, 4: null, 5: null},
      enemy_field_cards: {1: 1, 2: 2, 3: null, 4: null, 5: null},
      your_dead_cards: [1,2],
      enemy_dead_cards: [1,2],
      selected_card_id: null,
      display_cardinfo: '',
      display_card_type: null,
      display_card_position: null,
      show_battle_dialog: false,
      card_information: {
        1: {
          card_id: 1,
          name: 'Hound',
          bp: 1000,
          cost: 0,
          type: 0,
          category: 0,
          skill: {
            detail: `No Skill`,
            trigger_1: 0,
            ask_1: 0,
            type_1: 0,
            anount_1: 0,
          },
        },
        2: {
          card_id: 2,
          name: 'Fighter',
          bp: 3000,
          cost: 1,
          type: 0,
          category: 0,
          skill: {
            detail: `Pump
            When attakcs, increase BP 2000 until turn ends`,
            trigger_1: 2,
            ask_1: 0,
            type_1: 2,
            anount_1: 2000,
          },
        }
      },
      enemyAttack: true,
      address: '',
      hasNFT: false,
      nftType: 'human',
      nickname: '',
      imagepath: '',
      showClearingHouse: false,
      onSaleList: [],
      nftOwners: [],
      nftSeller: '',
      attrs: useAttrs()
    }
  },
  watch: {
    matchingDialog (val) {
      if (!val) return

      setTimeout(() => (this.matchingDialog = false), 60000)
    },
  },
  async created() {
    this.$fcl.currentUser.subscribe(this.setupWalletInfo)
    // Amplify Auth
    const currentAuthUser = await Auth.currentAuthenticatedUser();
    const session = await Auth.userSession(currentAuthUser);
    if (!session?.isValid()) {
      console.error('セッションが無効です。')
    };
    this.subscribe()
  },
  methods: {
    async flowWalletSignIn () {
      await this.$fcl.authenticate()
    },
    async flowWalletSignOut () {
      await this.$fcl.unauthenticate()
      this.address = ''
      this.timeline = [
        {
          color: 'red-lighten-2',
          icon: 'mdi-star',
          message: 'Initial registration completed.'
        },
        {
          color: 'purple-lighten-2',
          icon: 'mdi-book-variant',
          message: 'Blockchain connection NOT completed.'
        },
      ]
    },
    marigan (n) {
      if (this.marigan_cards.length > this.marigan_count) {
        this.marigan_count++
        this.your_hand[1] = this.marigan_cards[this.marigan_count][0]
        this.your_hand[2] = this.marigan_cards[this.marigan_count][1]
        this.your_hand[3] = this.marigan_cards[this.marigan_count][2]
        this.your_hand[4] = this.marigan_cards[this.marigan_count][3]
      }
    },
    countdown() {
      this.turn_timer = 60
      const stopTimer2 = setInterval(() => {
        this.turn_timer -= 1
        if (this.turn_timer === 0) {
          clearInterval(stopTimer2)
        }
      }, 1000)
    },
    showCardInfo(card_id, display_card_type, display_card_position) {
      const d = this.card_information[card_id]
      let info = ''
      if (d) {
        info = `Card ID: ${d.card_id} COST: ${d.cost}
        BP: ${d.bp},
        ■${d.skill.detail},
        `
      }
      this.display_cardinfo = info
      this.selected_card_id = card_id
      this.display_card_type = display_card_type
      this.display_card_position = display_card_position
    },
    showBattleDialogWindow() {
      if (this.display_card_type === 1 || this.display_card_type === 3) {
        const title = this.display_card_type
        const pos = this.display_card_position

        this.show_battle_dialog = true
      }
    },
    async cardMoveDecided() {
      const card = this.card_information[this.selected_card_id]
      console.log('display_card_type', this.display_card_type, 'display_card_position', this.display_card_position, 'selected_card_id', this.selected_card_id, card)
      if (card) {
        switch (this.display_card_type) {
          case 1:
            console.log('your_hand:', this.your_hand, 'enemy_field_cards:', this.enemy_field_cards)
            // if (this.your_hand[this.display_card_position] === this.selected_card_id) {
            //   this.your_hand
            // }
            break
          case 3:
            break
        }
      }
    },
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
    async setupWalletInfo (user) {
      this.walletUser = user
      if (this.walletUser?.addr) {
        this.address = this.walletUser?.addr
        this.timeline = [
          {
            color: 'red-lighten-2',
            icon: 'mdi-star',
            message: 'Initial registration completed.'
          },
          {
            color: 'purple-lighten-2',
            icon: 'mdi-book-variant',
            message: 'Blockchain connection completed.'
          },
          {
            color: 'green-lighten-1',
            icon: 'mdi-airballoon',
            message: 'Matching Standby'
          }
        ]
        const ret = await this.isRegistered()
        this.registered = ret !== null
        await this.checkTransactionComplete('watchCurrentStatus')
      }
    },
    async isRegistered() {
        const result = await this.$fcl.query({
          cadence: FlowScripts.isRegistered,
          args: (arg, t) => [
            arg(this.address, t.Address)
          ]
        })
        return result
    },
    async createPlayer () {
      if (!this.walletUser?.addr) {
        alert('Please sign in a Flow Wallet.')
        return
      } else {
        const transactionId = await this.$fcl.mutate({
          cadence: FlowTransactions.createPlayer,
          args: (arg, t) => [
            arg(this.attrs.player.username, t.String),
          ],
          proposer: this.$fcl.authz,
          payer: this.$fcl.authz,
          authorizations: [this.$fcl.authz],
          limit: 999
        })
        this.loadingDialog = true
        console.log(`TransactionId: ${transactionId}`)
        this.checkTransactionComplete('createPlayer')
      }
    },
    async playerMatching () {
      if (!this.walletUser?.addr) {
        alert('Please sign in a Flow Wallet.')
        return
      } else {
        this.matchingTimeup = false
        const transactionId = await this.$fcl.mutate({
          cadence: FlowTransactions.matchingStart,
          args: (arg, t) => [
          ],
          proposer: this.$fcl.authz,
          payer: this.$fcl.authz,
          authorizations: [this.$fcl.authz],
          limit: 999
        })
        this.matchingDialog = true
        console.log(`TransactionId: ${transactionId}`)
        this.matchingDialog = true
        let counter = 60
        const stopTimer1 = setInterval(() => {
          counter -= 1
          this.matching_time_second = counter < 10 ? '0' + counter.toString(): counter.toString()
          if (counter === 0) {
            clearInterval(stopTimer1)
          }
        }, 1000)
        setTimeout(() => {
          this.checkTransactionComplete('matchingStart')
        }, 7000) // トランザクション完了までは古い情報が返るので。
      }
    },
    async matchingSuccess () {
      this.onMatching = 2
      // const audio = document.getElementById("audio1");
      // audio.play();
      // const video1 = document.getElementById("video1");
      // video1.play();
      // setTimeout(() => {
        this.onMatching = 3
        setTimeout(() => {
          this.marigan_dialog = true
          // ハンドの初期値
          this.your_hand[1] = this.marigan_cards[0][0]
          this.your_hand[2] = this.marigan_cards[0][1]
          this.your_hand[3] = this.marigan_cards[0][2]
          this.your_hand[4] = this.marigan_cards[0][3]
          let counter = 0
          const stopTimer1 = setInterval(() => {
            counter += 50
            this.marigan_time_second = Math.floor((5000 - counter) / 1000)
            if (counter % 100 === 0) {
              this.marigan_time_millisecond_1 = counter % 1000 / 100
              this.marigan_time_millisecond_2 = 0
            } else {
              this.marigan_time_millisecond_2 = 5
            }
            if (this.marigan_time_second === 0) {
              this.marigan_time_millisecond_2 = 0
              clearInterval(stopTimer1)
              setTimeout(() => {
                this.marigan_dialog = false
                this.countdown()
              }, 300)
            }
          }, 50)
        }, 4000)
        // }, 1000)
      // }, 17000)
      this.marigan_cards = await this.get_marigan_cards()
    },
    async getCurrentStatus() {
        const result = await this.$fcl.query({
          cadence: FlowScripts.getCurrentStatus,
          args: (arg, t) => [
            arg(this.address, t.Address)
          ]
        })
        return result
    },
    async get_marigan_cards() {
        const result = await this.$fcl.query({
          cadence: FlowScripts.getMariganCards,
          args: (arg, t) => [
            arg(this.address, t.Address)
          ]
        })
        return result
    },
    checkTransactionComplete (transactionName) {
      const timerID = setInterval(async () => {
        if (transactionName === 'createPlayer') {
          const result = await this.isRegistered()
          console.log(transactionName, result)
          if (result) {
            this.loadingDialog = false
            this.registered = true
            clearInterval(timerID)
          }
        } else if (transactionName === 'matchingStart' || transactionName === 'watchCurrentStatus') {
          const result = await this.getCurrentStatus()
          console.log(transactionName, result)
          if (result) {
            if (!isNaN(parseFloat(result))) {
              let matchingTime = parseFloat(result)
              let d = new Date()
              if (d.getTime() / 1000 - matchingTime > 60) {
                if (d.getTime() / 1000 - matchingTime > 100) return // 古い情報。
                this.matchingTimeup = true
                this.matchingDialog = false
              }
            } else if (result.game_started === false) {
              // リロード対策
              if (transactionName === 'matchingStart') {
                this.matchingSuccess()
              } else {
                this.onMatching = 3
                this.marigan_cards = await this.get_marigan_cards()
                this.your_hand[1] = this.marigan_cards[0][0]
                this.your_hand[2] = this.marigan_cards[0][1]
                this.your_hand[3] = this.marigan_cards[0][2]
                this.your_hand[4] = this.marigan_cards[0][3]
              }
            }
            clearInterval(timerID)
          }

        } else {
          clearInterval(timerID)
        }
      }, 3000)
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
    subscribe() {
      API.graphql({ query: onCreateTodo }).subscribe({
        next: (eventData) => {
          const flowEv = eventData.value.data.onCreateTodo
          flowEv.flowEvent.data = JSON.parse(flowEv.flowEvent.data)
          const dateObj = new Date(flowEv.flowEvent.data.blockTimestamp)
          flowEv.flowEvent.data.datetime =
            dateObj.getFullYear() + '/' + (dateObj.getMonth() + 1) + '/' +
            dateObj.getDate() + ' ' + dateObj.getHours() + ':' +
            dateObj.getMinutes() + ':' + dateObj.getSeconds()
          this.newEventAlert = `${flowEv.flowEvent.name} To: ${flowEv.flowEvent.data.data.to}
             Amount:${ flowEv.flowEvent.data.data.amount } $FLOW at ${ flowEv.flowEvent.data.datetime }`
          this.newEventAlertChip = true;
          setTimeout(() => {
            this.newEventAlertChip = false
          }, 4000)
        },
      })
    },
  },
}
</script>
<style>
.v-chip {
  position: absolute;
  right: 0;
  top: 0;
  background-image: url(https://cdn.vuetifyjs.com/images/backgrounds/bg-2.jpg);
  border-color: red;
  border-width: 1px;
  border-style: dotted;
  animation: fadeOut2 4s linear forwards;
}

.matching-screen {
  width: 100%;
  min-height: 400px;
  color: #FF4081;
  padding-top: 40px;
  background-image: url(https://cdn.vuetifyjs.com/images/backgrounds/bg-2.jpg);
  background-repeat: repeat;
}

.main-screen {
  padding: 7px;
  height: 85%;
  background-image: url(https://cdn.vuetifyjs.com/images/backgrounds/bg-2.jpg);
  background-repeat: repeat;
}

.v-timeline--vertical.v-timeline {
  padding: 15px;
  margin: 0 auto;
}

.v-timeline-item__body {
  width: 300px !important;
}

.v-card-title {
  font-size: 1rem;
}

.top-screen {
  color: #FF4081;
}

.your_hands {
  display: flex;
  width: 100%;
  max-width: 410px;
  margin-top: 40px;
}

.your_hands .v-row {
  margin: 0;
}

.your_hands .v-row .v-col {
  padding: 3px;
}

video {
  width: 96vw !important;
}

#field {
  background-image: url(https://cdn.vuetifyjs.com/images/backgrounds/bg-2.jpg);
  background-repeat: repeat;
  width:34%;
  position: fixed;
  right: 10%;
  min-height:200px;
  margin: 0em;
  padding: 1px 6px;
  border-width: 2px; 
  border-style: outset;
  border-color: buttonborder;
  padding: 5px;
}

.your_cards {
  clear: both;
  margin-top: 60px;
}

.attack-anime {
  animation: attack 1.5s linear forwards;
}

.remaining_time {
  width: 130px;
  margin: 0 auto;
}
.box {
  float: left;
  position: relative;
  width: 20%;
  height: 60px;
  padding-bottom: 20%;
}
.box_hand {
  float: left;
  position: relative;
  width: 10%;
  height: 30px;
  padding-bottom: 20%;      
}
.boxInner {
  position: absolute;
  left: 10px;
  right: 10px;
  top: 10px;
  bottom: 10px;
  overflow: hidden;
}
.boxInner img {
    width: 100%;
}
@media screen and (max-width: 700px) {
  .v-timeline--vertical.v-timeline {
    width: 150px;
    padding: 0;
    margin: 0;
  }
  .v-timeline-item__body {
    width: 150px !important;
    padding-inline-start: 5px !important;
    padding-inline-end: 5px !important;
  }
  video {
    width: 88vw !important;
  }
  #field {
    width:95%;
    position: relative;
    margin: 3.5%;
    left: 0;
  }
  .your_hands {
    margin-top: 35px;
  }
}
@media screen and (max-width: 700px) {
  .dialog_title {
    font-size: 16px;
  }

  .marigan_buttons {
    display: block;
    margin: 0 auto;
    width: 200px;
  }
}

@media screen and (max-height: 800px) and (max-width: 700px) {
  .main-screen {
    font-size: 11px;
  }
}
@media screen and (max-height: 750px) and (max-width: 700px) {
  .main-screen {
    font-size: 10px;
  }
}
@keyframes fadeOut2 {
  0% {
    opacity: 0;
  }
  8% {
    opacity: 1;
  }
  80% {
    opacity: 0.7;
  }
  100% {
    opacity: 0.0;
  }
}
@keyframes attack {
  0% {
    width: 50px;
  }
  8% {
    width: 150px;
  }
  80% {
    width: 350px;
  }
  100% {
    width: 250px;
  }
}
</style>
