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
          <div v-if="!address" style="padding: 0 20px; font-weight: bold; color: #311B92;">
            To fight the enemy and earn rewards, you register your battle record information in the blockchain.<br>
            Connect to the blockchain and register your information on the blockchain.
          </div>
          <div v-if="address && registered" style="padding: 0 20px; font-weight: bold; color: #311B92;">
            Press the matching button below.
          </div>
          <div v-if="address && !registered" style="padding: 0 20px; font-weight: bold; color: #311B92;">
            Player information has not yet been created on the blockchain.<br>Please press the Create Player button below.
          </div>
          <div v-if="matchingTimeup" style="padding: 0 20px; font-weight: bold; color: #311B92;">
            タイムアップしました。もう一度マッチングボタンを押してください。
          </div>
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
        <video v-show="onMatching === 2" id="video1" style="width: 100vw; min-height: 100%;" controls="controls">
          <source src="/video/coj_matching_movie.mov">
        </video>
        <div v-if="onMatching === 3" class="main-screen">
          <div style="display: flex;">
            <div>
              <span>Opponent: LIFE {{ opponent_life }} <i v-for="i in opponent_life">🔹</i></span><br>
              <span style="padding-left:40px;">
                CP 0{{ opponent_cp }}
              </span><br>
              <span style="padding-left:40px;">
                Dead: {{ opponent_dead_cards.length }}
              </span>
            </div>
            <div style="margin-left: 30px;">
              <span>Deck: {{ opponent_remain_deck }}</span><br>
              <span>
                Hand {{ opponent_hand }} <i v-for="i in opponent_hand">🔸</i>
              </span><br>
              Triger Zone
              <span v-for="i in triggers_boxes">
                <i v-if="i>opponent_trigger_cards">🔲</i>
                <i v-else>🔳</i>
              </span>
            </div>
          </div>
          <div id="field">
            <div class="rival_cards">
              <v-row>
                <v-col
                  v-for="n in opponent_field_unit"
                  cols="2.5"
                >
                  <v-img
                    :src="`/img/cards/card_${opponent_field_unit[n]}.jpeg`"
                    aspect-ratio="0.65"
                    cover
                    @click="showCardInfo(opponent_field_unit[n], 4, n)"
                  ></v-img>
                </v-col>
              </v-row>
            </div>
            <div class="your_cards">
              <v-row>
                <v-col
                  v-for="n in your_field_unit"
                  cols="2.5"
                >
                  <v-img
                    :src="`/img/cards/card_${your_field_unit[n]}.jpeg`"
                    aspect-ratio="0.65"
                    cover
                    @click="showCardInfo(your_field_unit[n], 3, n)"
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
              <span style="padding-left:40px;">Deck: {{ your_remain_deck }}</span>
            </div>
            <div style="margin-left: 20px; min-width: 150px;">
              Triger Zone
              <v-row>
                <v-col
                  v-for="n in your_trigger_cards"
                  cols="3.5"
                >
                  <v-img
                    :src="`/img/cards/card_${your_trigger_cards[n]}.jpeg`"
                    aspect-ratio="0.65"
                    cover
                    @click="showCardInfo(your_trigger_cards[n], 2, n)"
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
          <div v-if="!registered" style="margin: 10px;">
            Welcome. My name is Actis. I am here to support you and your agents. Your mission as agents is to keep cyberspace safe. Your role is to infiltrate the cyberspace, Arcana, and fight off hackers and others who try to destroy the cyberspace Arcana. Register your agent name and register on the Flow Blockchain to infiltrate Arcana. If you are matched with other opponents, the game will switch to battle mode. I will support you and you will have to use your abilities to fight them off to keep Arkana safe. <br><br>
            (CODE-Of-Flow is an homage to SEGA's "Code Of Joker")
            <div><br><br><br><br>
              If you don't know Code Of Joker👇<br>
              <a href="https://m.youtube.com/watch?v=tYioSA10Ckc">https://m.youtube.com/watch?v=tYioSA10Ckc</a><br>
            </div>
          </div>
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
      <div v-if="onMatching === 3 && game_started === true" class="remaining_time">
        {{ current_turn }} | TIME: {{ turn_timer }}
      </div>
      <div v-if="onMatching === 1" class="macthing_time">
        {{ matching_time_second }}
      </div>
    </div>
  </div>
  <v-btn
    v-if="game_started === false && onMatching === 3"
    class="ma-1"
    color="success"
    icon="mdi-gavel"
    @click="show_game_dialog = true"
    style="position: absolute; bottom: 40px; left: -5px;"
  ></v-btn>
  <v-btn
    v-if="onMatching === 3"
    class="ma-1"
    color="red"
    icon="mdi-cancel"
    @click="show_surrendar_dialog = true"
    style="position: absolute; top: 20px; left: -5px;"
  ></v-btn>
  <v-btn
    v-if="is_first !== is_first_turn && turn_timer === '00' && onMatching === 3"
    class="ma-1"
    color="success"
    icon="mdi-gavel"
    @click="show_game_dialog = true"
    style="position: absolute; bottom: 40px; left: -5px;"
  ></v-btn>
  <v-btn
    v-if="
      game_started === true &&
      onMatching === 3 &&
      display_cardinfo !== '' &&
      (this.display_card_type === 1 || this.display_card_type === 3) &&
      is_first === is_first_turn
    "
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
    <div v-if="loadingDialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;"><div class="v-overlay__content" style="width: auto; height: 160px;">
      <v-card color="purple">
        <v-card-text color="purple">
          <div class="text-h6 pa-12">Loading... Please wait</div>
        </v-card-text>
        <div class="v-progress-linear v-progress-linear--active v-theme--light mb-0" role="progressbar" aria-hidden="false" aria-valuemin="0" aria-valuemax="100" style="top: 0px; height: 4px; --v-progress-linear-height:4px; left: 50%; transform: translateX(-50%);">
          <div class="v-progress-linear__background bg-white" style="width: 100%;"></div>
          <div class="v-progress-linear__indeterminate">
            <div class="v-progress-linear__indeterminate long bg-white"></div>
            <div class="v-progress-linear__indeterminate short bg-white"></div>
          </div>
        </div>
      </v-card>
    </div></div>
    <div v-if="gameStartDialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;"><div class="v-overlay__content" style="width: auto; height: 160px;">
      <v-card color="deep-orange-accent-3">
        <v-card-text color="deep-orange-accent-3">
          <div class="text-h6 pa-12">Game Start!</div>
          <div class="text-h6 pa-12">{{ is_first ? 'YOUR TURN!' : 'ENEMY TURN' }}</div>
        </v-card-text>
        <v-btn
          color="success"
          @click="gameStartDialog = false"
          style="margin-top: 30px; width: 100%;"
        >
          OK
        </v-btn>
      </v-card>
    </div></div>
    <div v-if="gameEndDialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;"><div class="v-overlay__content" style="width: auto; height: 290px;">
      <v-card color="yellow-lighten-1">
        <v-card-text color="yellow-lighten-1">
          <div class="text-h6 pa-12">Your victory is confirmed!</div>
        </v-card-text>
        <v-btn
          color="success"
          @click="gameEndDialog = false; onMatching = 1"
          style="margin: 0 auto 40px; width: 50%; display: block; "
        >
          OK
        </v-btn>
      </v-card>
    </div></div>
    <div v-if="show_surrendar_dialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 9900;"><div class="v-overlay__content" style="width: auto; height: 360px;">
      <v-card color="light-blue">
        <v-card-text color="light-blue">
          <div class="text-h6 pa-12">Do you want to surrender?</div>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="white"
            size="x-large"
            @click="show_surrendar_dialog = false"
          >
            No
          </v-btn>
          <v-btn
            size="x-large"
            color="red"
            @click="surrendar"
          >
            Yes
            <template v-slot:loader>
              <span class="custom-loader">
                <v-icon light>mdi-cached</v-icon>
              </span>
            </template>
          </v-btn>
        </v-card-actions>
      </v-card>
    </div></div>

    <div v-if="show_game_dialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;"><div class="v-overlay__content" style="width: auto;">
      <div style="width: 400px; padding: 35px; background-color: #9C27B0; color: white; border-radius: 20px; margin: 0 auto;">
        <div v-if=!battleDialogText>To start a game, click Game Start button</div>
        {{ battleDialogText }}
        <v-card-text style="font-size: 15px;">
          {{ battleDialogText2 }}
        </v-card-text>
        <v-btn
          v-if="!game_started"
          color="success"
          @click="gameStart"
          style="margin-top: 30px; width: 100%;"
        >
          Game Start
        </v-btn>
        <v-btn
          v-if="game_started && is_first !== is_first_turn"
          :loading="customLoading"
          :disabled="customLoading"
          size="x-large"
          color="info"
          @click="claimWin"
          style="margin: 0 auto; display: block;"
        >
          Yes
          <template v-slot:loader>
            <span class="custom-loader">
              <v-icon light>mdi-cached</v-icon>
            </span>
          </template>
        </v-btn>
        <v-btn
          v-if="game_started && is_first === is_first_turn"
          :loading="customLoading"
          :disabled="customLoading"
          size="x-large"
          color="info"
          @click="turnChange"
          style="margin: 0 auto; display: block;"
        >
          Yes
          <template v-slot:loader>
            <span class="custom-loader">
              <v-icon light>mdi-cached</v-icon>
            </span>
          </template>
        </v-btn>
      </div>
    </div></div>
    <div v-if="show_battle_dialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;"><div class="v-overlay__content" style="width: auto;">
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
          v-if="enemyAttack && selected_card_id != null"
          :src="`/img/cards/card_${selected_card_id}.jpeg`"
          aspect-ratio="0.65"
          cover
          class="attack-anime"
          style="width: 250px; margin: 0 auto;"
        ></v-img>
        <v-img
          v-if="!enemyAttack && selected_card_id != null"
          :src="`/img/cards/card_${selected_card_id}.jpeg`"
          aspect-ratio="0.65"
          cover
          style="width: 250px; margin: 0 auto;"
        ></v-img>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="green-darken-1"
            size="x-large"
            @click="show_battle_dialog = false"
          >
            No
          </v-btn>
          <v-btn
            size="x-large"
            color="info"
            @click="cardMoveDecided"
          >
            Yes
            <template v-slot:loader>
              <span class="custom-loader">
                <v-icon light>mdi-cached</v-icon>
              </span>
            </template>
          </v-btn>
        </v-card-actions>
      </v-card>
    </div></div>
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
      watchCurrentStatusFlg: false,
      loadingDialog: false,
      gameStartDialog: false,
      gameEndDialog: false,
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
      game_started: false,
      turn_timer: 60,
      opponent: null,
      your_score: [],
      opponent_score: [],
      turn: null,
      is_first: null,
      is_first_turn: null,
      last_time_turnend: null,
      matched_time: null,
      your_life: 7,
      opponent_life: 7,
      your_cp: 2,
      opponent_cp: 2,
      your_remain_deck: 36,
      opponent_remain_deck: 36,
      your_hand: {},
      opponent_hand: 0,
      triggers_boxes: 4,
      your_trigger_cards: {1: null, 2: null, 3: null, 4: null},
      opponent_trigger_cards: 0,
      your_field_unit: {1: null, 2: null, 3: null, 4: null, 5: null},
      opponent_field_unit: {1: null, 2: null, 3: null, 4: null, 5: null},
      your_dead_cards: [],
      opponent_dead_cards: [],
      selected_card_id: null,
      current_turn: '',
      display_cardinfo: '',
      display_card_type: null,
      display_card_position: null,
      attacked_cards: {'A': 0}, // 空だとTransactionがバリデーションエラーを吐くため
      used_card: {'A': 0}, // 空だとTransactionがバリデーションエラーを吐くため
      show_game_dialog: false,
      show_battle_dialog: false,
      customLoading: false,
      battleDialogText: '',
      battleDialogText2: '',
      show_game_dialog: false,
      show_surrendar_dialog: false,
      turnChangeActionDone: false,
      show_turn_change_dialog: {1: [false, false], 2: [false, false], 3: [false, false], 4: [false, false], 5: [false, false], 6: [false, false], 7: [false, false], 8: [false, false], 9: [false, false], 10: [false, false]},
      card_information: {},
      stopCountdownTimer: null,
      enemyAttack: false,
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

      setTimeout(() => {
        this.matching_time_second = ''
        this.matchingDialog = false
        this.matchingTimeup = true
      }, 60000)
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
      this.stopCountdownTimer = setInterval(() => {
        this.turn_timer -= 1
        if (this.turn_timer <= 0) {
          this.turn_timer = '00'
          clearInterval(this.stopCountdownTimer)
          this.stopCountdownTimer = null
        }
      }, 1000)
    },
    async gameStart() {
      this.show_game_dialog = false
      const arg1 = [this.your_hand[1], this.your_hand[2], this.your_hand[3], this.your_hand[4]]
      const transactionId = await this.$fcl.mutate({
        cadence: FlowTransactions.gameStart,
        args: (arg, t) => [
          arg(arg1, t.Array(t.UInt16))
        ],
        proposer: this.$fcl.authz,
        payer: this.$fcl.authz,
        authorizations: [this.$fcl.authz],
        limit: 999
      })
      console.log(`TransactionId: ${transactionId}`)
      this.loadingDialog = true
      this.checkTransactionComplete('gameStart')
    },
    showCardInfo(card_id, display_card_type, display_card_position) {
      const d = this.card_information[card_id]
      let info = ''
      if (d) {
        info = `Card ID: ${d.card_id} COST: ${d.cost}
        BP: ${d.bp},
        ■${d.skill.description}
        `
      }
      this.display_cardinfo = info
      this.selected_card_id = card_id
      this.display_card_type = display_card_type
      this.display_card_position = display_card_position
    },
    showBattleDialogWindow() {
      if (this.display_card_type === 1 || this.display_card_type === 3) {
        this.show_battle_dialog = true
      }
    },
    async turnChange() {
      this.customLoading = true
      setTimeout(() => (this.customLoading = false), 5000)
      console.log(this.attacked_cards, this.used_card, 777)
      const transactionId = await this.$fcl.mutate({
        cadence: FlowTransactions.turnChange,
        args: (arg, t) => [
          arg([], t.Dictionary({ key: t.String, value: t.UInt16 })),
          arg([], t.Dictionary({ key: t.String, value: t.UInt16 }))
        ],
        proposer: this.$fcl.authz,
        payer: this.$fcl.authz,
        authorizations: [this.$fcl.authz],
        limit: 999
      })
      console.log(`TransactionId: ${transactionId}`)
      this.show_game_dialog = false
      this.turnChangeActionDone = true
      this.loadingDialog = true
      this.checkTransactionComplete('turnChange')
    },
    async claimWin() {
      this.customLoading = true
      setTimeout(() => (this.customLoading = false), 5000)
      const transactionId = await this.$fcl.mutate({
        cadence: FlowTransactions.claimWin,
        args: (arg, t) => [
        ],
        proposer: this.$fcl.authz,
        payer: this.$fcl.authz,
        authorizations: [this.$fcl.authz],
        limit: 999
      })
      console.log(`TransactionId: ${transactionId}`)
      this.show_game_dialog = false
      this.loadingDialog = true
      this.checkTransactionComplete('claimWin')
    },
    async surrendar() {
      const transactionId = await this.$fcl.mutate({
        cadence: FlowTransactions.surrendar,
        args: (arg, t) => [
        ],
        proposer: this.$fcl.authz,
        payer: this.$fcl.authz,
        authorizations: [this.$fcl.authz],
        limit: 999
      })
      console.log(`TransactionId: ${transactionId}`)
      this.show_surrendar_dialog = false
      this.loadingDialog = true
      this.checkTransactionComplete('surrendar')
    },
    async cardMoveDecided() {
      this.customLoading = true
      setTimeout(() => (this.customLoading = false), 5000)

      const card = this.card_information[this.selected_card_id]
      console.log('display_card_type', this.display_card_type, 'display_card_position', this.display_card_position, 'selected_card_id', this.selected_card_id, card)
      if (card) {
        switch (this.display_card_type) {
          case 1:
            console.log('your_hand:', this.your_hand, 'opponent_field_unit:', this.opponent_field_unit, this.display_card_position)
            this.your_hand[display_card_position] = null

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
        if (this.watchCurrentStatusFlg === false) {
          this.checkTransactionComplete('watchCurrentStatus')
          this.watchCurrentStatusFlg = true
        }
        this.get_card_info()
        const ret = await this.isRegistered()
        this.registered = ret !== null
        if (this.registered) {
          console.log('User:', ret)
          await this.getPlayersScore()
        }
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
      const audio = document.getElementById("audio1");
      audio.play();
      const video1 = document.getElementById("video1");
      video1.play();
      setTimeout(() => {
        this.onMatching = 3
        setTimeout(() => {
          this.marigan_dialog = true
          // ハンドの初期値
          this.your_hand['1'] = this.marigan_cards[0][0]
          this.your_hand['2'] = this.marigan_cards[0][1]
          this.your_hand['3'] = this.marigan_cards[0][2]
          this.your_hand['4'] = this.marigan_cards[0][3]
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
                // this.turn_timer = 60
                // this.countdown()
              }, 300)
            }
          }, 50)
        }, 1000)
      }, 17000)
      this.marigan_cards = await this.get_marigan_cards()
      await this.getPlayersScore()
    },
    async getPlayersScore() {
        const result = await this.$fcl.query({
          cadence: FlowScripts.getPlayersScore,
          args: (arg, t) => [
            arg(this.address, t.Address)
          ]
        })
        console.log('SCORE:', result)
        if (result && result.length === 1) {
          this.your_score = result[0]
        } else if(result && result.length === 2) {
          this.your_score = result[0]
          this.opponent_score = result[0]
        }
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
    async get_card_info() {
        const result = await this.$fcl.query({
          cadence: FlowScripts.getCardInfo,
          args: (arg, t) => [
          ]
        })
        console.log(result)
        this.card_information = result
    },
    async get_matching_limits() {
        const result = await this.$fcl.query({
          cadence: FlowScripts.getMatchingLimits,
          args: (arg, t) => [
          ]
        })
        console.log(result)
        result.forEach((t) => {
          const d = new Date(parseFloat(t) * 1000)
          const n = new Date()
          console.log((n.getTime() - d.getTime()) / 1000 + '秒前')
        })
    },
    checkTransactionComplete (transactionName) {
      const func = async () => {
        this.get_matching_limits() // DEBUG
        try {
          if (transactionName === 'createPlayer') {
            const result = await this.isRegistered()
            console.log(transactionName, result)
            if (result) {
              this.loadingDialog = false
              this.registered = true
              clearInterval(timerID)
              await this.getPlayersScore()
            }
          } else if (
            transactionName === 'matchingStart' ||
            transactionName === 'watchCurrentStatus' ||
            transactionName === 'gameStart' ||
            transactionName === 'turnChange' ||
            transactionName === 'claimWin' ||
            transactionName === 'surrendar'
            ) {
            const result = await this.getCurrentStatus()
            console.log(transactionName, result)
            if (result) {
              if (!isNaN(parseFloat(result))) {
                let matchingTime = parseFloat(result)
                let d = new Date()
                if (d.getTime() / 1000 - matchingTime > 60) {
                  if (d.getTime() / 1000 - matchingTime > 100){
                    // 古い情報。
                    if (transactionName !== 'watchCurrentStatus') {
                      clearInterval(timerID)
                    }
                    return
                  }
                  this.matching_time_second = ''
                  this.matchingTimeup = true
                  this.matchingDialog = false
                  if (transactionName !== 'watchCurrentStatus') {
                    clearInterval(timerID)
                  }
                }
              } else {
                this.game_started = result.game_started
                // ゲーム開始前
                if (this.game_started === false && (transactionName === 'matchingStart' || transactionName === 'watchCurrentStatus')) {
                  if (transactionName === 'matchingStart') {
                    this.matchingSuccess()
                  } else {
                    // リロード対策
                    if (this.onMatching != 2) {
                      this.onMatching = 3
                      this.marigan_cards = await this.get_marigan_cards()
                      this.your_hand['1'] = !this.your_hand['1'] ? this.marigan_cards[0][0] : this.your_hand['1']
                      this.your_hand['2'] = !this.your_hand['2'] ? this.marigan_cards[0][1] : this.your_hand['2']
                      this.your_hand['3'] = !this.your_hand['3'] ? this.marigan_cards[0][2] : this.your_hand['3']
                      this.your_hand['4'] = !this.your_hand['4'] ? this.marigan_cards[0][3] : this.your_hand['4']
                    }
                  }
                  if (transactionName !== 'watchCurrentStatus') {
                    clearInterval(timerID)
                  }
                // ゲーム開始済み
                } else if (this.game_started === true) {
                  if (transactionName === 'turnChange' && this.is_first_turn !== result.is_first_turn) {
                    this.battleDialogText = ''
                    this.battleDialogText2 = ''
                    this.turnChangeActionDone = false
                  }
                  if (this.onMatching != 2) {
                    this.onMatching = 3
                  }
                  this.turn = result.turn
                  this.is_first = result.is_first
                  this.is_first_turn = result.is_first_turn
                  this.last_time_turnend = new Date(parseFloat(result.last_time_turnend) * 1000)
                  this.matched_time = new Date(parseFloat(result.matched_time) * 1000)
                  this.opponent = result.opponent
                  this.your_life = parseInt(result.your_life)
                  this.your_remain_deck = result.your_remain_deck?.length
                  this.your_hand = result.your_hand
                  this.your_field_unit = result.your_field_unit
                  this.your_trigger_cards = result.your_trigger_cards
                  this.opponent_life = parseInt(result.opponent_life)
                  this.opponent_remain_deck = result.opponent_remain_deck
                  this.opponent_hand = parseInt(result.opponent_hand)
                  this.opponent_field_unit = result.opponent_field_unit
                  this.opponent_trigger_cards = result.opponent_trigger_cards
                  if (transactionName !== 'turnChange') {
                    this.gameControl()
                  }
                  if (transactionName === 'gameStart') {
                    this.loadingDialog = false
                    this.gameStartDialog = true // (Game Start)
                    setTimeout(() => {
                      this.gameStartDialog = false
                    }, 2000)
                  }
                  if (transactionName !== 'watchCurrentStatus') {
                    clearInterval(timerID)
                  }
                }
              }
            } else {
              if (transactionName === 'claimWin' || transactionName === 'surrendar') {
                this.onMatching = 1
              } else if (this.is_first_turn != this.is_first) {
                this.gameEndDialog = true
              }
              this.show_game_dialog = false
              this.show_battle_dialog = false
              this.show_game_dialog = false
              this.show_surrendar_dialog = false
            }
          } else {
            clearInterval(timerID)
          }
        } catch(e) {
          console.log(e)
        }
      }
      const timerID = setInterval(func, 3000)
      func()
    },
    gameControl () {
      const now = new Date()
      this.current_turn = `Now Turn ${this.turn}, ${this.is_first === this.is_first_turn ? 'Your' : "Enemy's"} Turn`
      const p = this.is_first_turn ? 0 : 1
      const pastTime = 60 - ((now.getTime() / 1000) - (this.last_time_turnend.getTime() / 1000))
      if (pastTime <= 0) {
        this.turn_timer = '00'
        if (this.is_first !== this.is_first_turn) {
          this.battleDialogText = 'TIME UP'
          this.battleDialogText2 = "Oppenent seems doesn't do any action in this turn. Claim the win of this game now!"
        } else if (!this.show_game_dialog && this.turnChangeActionDone === false) {
          this.battleDialogText = 'TIME UP'
          this.battleDialogText2 = "Give the turn to the opponent's turn."
          this.show_game_dialog = true
        }
      } else {
        if (this.show_turn_change_dialog[this.turn][p] === false) {
        }
        if (this.stopCountdownTimer === null) {
          this.turn_timer = parseInt(pastTime)
          this.countdown()
        }
      }
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

.header-bar {
  font-size: 20px;
}

.remaining_time {
  width: 350px;
  margin: 0 auto;
}
.macthing_time {
  width: 28px;
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
.custom-loader {
  animation: loader 1s infinite;
  display: flex;
}
@keyframes loader {
  from {
    transform: rotate(0);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>
