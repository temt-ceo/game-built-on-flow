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
                CP <i style="color: white;">0{{ opponent_cp }}</i>
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
                  v-for="n in 5"
                  cols="2.5"
                >
                  <v-img
                    :src="`/img/cards/card_${opponent_field_unit[n]}.jpeg`"
                    aspect-ratio="0.65"
                    cover
                    @click="showCardInfo(opponent_field_unit[n], 4, n)"
                  ></v-img>
                  <div style="position: absolute; top: 60px; font-size: 12px;">
                    <v-icon v-if="opponent_field_unit_action[n] >= 1" color="green-accent-2" icon="mdi-shield-cross-outline"></v-icon>
                    <v-icon v-if="opponent_field_unit_action[n] >= 2" color="white" icon="mdi-fencing" style="position: absolute; left: 18px;"></v-icon>
                  </div>
                </v-col>
              </v-row>
            </div>
            <div class="your_cards">
              <v-row>
                <v-col
                  v-for="n in 5"
                  cols="2.5"
                >
                  <v-img
                    :src="`/img/cards/card_${your_field_unit[n]}.jpeg`"
                    aspect-ratio="0.65"
                    cover
                    @click="showCardInfo(your_field_unit[n], 3, n)"
                  ></v-img>
                  <div style="position: absolute; bottom: 0px; font-size: 12px;">
                    <v-icon v-if="your_field_unit_action[n] >= 1" color="green-accent-2" icon="mdi-shield-cross-outline"></v-icon>
                    <v-icon v-if="your_field_unit_action[n] >= 2" color="white" icon="mdi-fencing" style="position: absolute; left: 18px;"></v-icon>
                    <v-icon v-if="your_field_unit_attack_action[n] == 1" color="red-darken-3" icon="mdi-fencing" style="position: absolute; left: 10px;    bottom: 90px;    font-size: 40px;"></v-icon>
                  </div>
                </v-col>
              </v-row>
            </div>
          </div>
          <div class="your_hands">
            <div style="width: 205px;">
              <span>You: LIFE
                <b v-if="your_life == '7' || your_life == 7">{{ your_life }}</b>
                <b v-if="your_life < 7" style="color: red">{{ your_life }}</b>
                <i v-for="i in your_life">🔹</i></span><br>
              <span style="padding-left:40px;">
                CP <i style="color: white;">0{{ your_cp }}</i>
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
                  v-for="n in 4"
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
          <div class="card_information" style="max-width: 600px;">
            Card Information: Cost: 
            <span :style="selected_card_cost <= your_cp || this.display_card_type === 3 ? 'color:white;': 'color:red;'">{{ selected_card_cost }}</span><br>
            <span :style="selected_card_cost <= your_cp || this.display_card_type === 3 ? 'color:white;': 'color:red;'">{{ display_cardinfo }}</span>
          </div>
        </div>

        <div>
          <h2 v-if="!registered">Hello! {{ attrs.player.username }}</h2>
          <div v-if="!registered" style="margin: 10px;">
            Welcome. My name is Actis. I am here to support you and your agents. Your mission as agents is to keep cyberspace safe. Your role is to infiltrate the cyberspace, Arcana, and fight off hackers and others who try to destroy the cyberspace Arcana. Register your agent name and register on the Flow Blockchain to infiltrate Arcana. If you are matched with other opponents, the game will switch to battle mode. I will support you and you will have to use your abilities to fight them off to keep Arkana safe. <br><br>
            (CODE-Of-Flow is an homage to SEGA's "Code Of Joker")
            <div><br><br><br><br>
              If you don't know Code Of Joker👇<br>
              <a href="https://m.youtube.com/watch?v=tYioSA10Ckc">https://m.youtube.com/watch?v=tYioSA10Ckc</a><br><br><br>
            </div>
          </div>
          <p v-if="address && hasNFT">
            <h3>Hi {{ nickname }}</h3>
            <div><button v-if="!showClearingHouse" @click="showClearingHouse = true">Show Clearing House</button></div>
            <div><button v-if="showClearingHouse" @click="showClearingHouse = false">Close Clearing House</button></div>
            
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
      <div v-if="onMatching === 3 && game_started === true" class="remaining_time" :class="is_first == is_first_turn ? 'you' : 'opponent'">
        {{ current_turn }} | TIME: {{ turn_timer }}
      </div>
      <div v-if="onMatching === 1" class="macthing_time">
        {{ matching_time_second }}
      </div>
    </div>
  </div>
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
    style="position: absolute; bottom: 10%; left: -5px;"
  ></v-btn>
  <v-btn
    v-if="
      game_started === true &&
      onMatching === 3 &&
      is_first === is_first_turn &&
      turn_timer !== '00'
    "
    class="ma-1"
    color="indigo"
    icon="mdi-gavel"
    @click="giveTurn"
    style="position: absolute; bottom: 180px; left: -5px;"
  ></v-btn>
  <v-btn
    v-if="
      game_started === true &&
      onMatching === 3 &&
      display_cardinfo !== '' &&
      (display_card_type === 1 || display_card_type === 3) &&
      is_first === is_first_turn &&
      turn_timer !== '00' &&
      (selected_card_cost <= your_cp || this.display_card_type === 3) &&
      !(display_card_type === 3 && attack_unit_cards.includes(display_card_position))
    "
    class="ma-1"
    :color="display_card_type !== 3  ? 'purple' : 'deep-orange-accent-4'"
    :icon="display_card_type !== 3  ? 'mdi-call-split' : 'mdi-sword'"
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
    <div v-if="gameStartDialog || turnChangedDialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;"><div class="v-overlay__content" style="width: auto; height: 160px;">
      <v-card color="deep-orange-accent-3">
        <v-card-text color="deep-orange-accent-3">
          <div v-if="gameStartDialog" class="text-h6 pa-12">Game Start!</div>
          <div v-if="gameStartDialog" class="text-h6 pa-12">{{ is_first ? 'YOUR TURN!' : 'ENEMY TURN' }}</div>
          <div v-if="turnChangedDialog" class="text-h6 pa-12">{{ is_first === is_first_turn ? 'YOUR TURN!' : 'ENEMY TURN' }}</div>
        </v-card-text>
        <v-btn
          color="success"
          @click="gameStartDialog = false; turnChangedDialog = false"
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
      <div class="game_dialog">
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
        <div style="display: flex;">
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
            v-if="game_started && is_first === is_first_turn && battleDialogText !== `Your turn! Draw two cards!`"
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
          <v-btn
            v-if="battleDialogText === `Your turn! Draw two cards!`"
            :loading="customLoading"
            :disabled="customLoading"
            size="x-large"
            color="info"
            @click="startYourTurn"
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
            v-if="battleDialogText == 'Do you give the turn to the opponent?'"
            size="x-large"
            color="red"
            @click="show_game_dialog = false"
            style="margin: 0 auto; display: block;"
          >
            No
            <template v-slot:loader>
              <span class="custom-loader">
                <v-icon light>mdi-cached</v-icon>
              </span>
            </template>
          </v-btn>
        </div>
      </div>
    </div></div>
    <div v-if="show_battle_dialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;"><div class="v-overlay__content" style="width: auto;">
      <v-card>
        <v-card-title class="text-h5">
          <div class="dialog_title" v-if="!enemyAttack && display_card_type === 1 && selected_card_category === 0">
            Do you put this card on the FIELD?
          </div>
          <div class="dialog_title" v-if="!enemyAttack && display_card_type === 1 && (selected_card_category === 1 || selected_card_category === 2)">
            Do you put this card on the Trigger Zone?
          </div>
          <div class="dialog_title" v-if="!enemyAttack && display_card_type === 3">
            Do you attack using this card?
          </div>
          <div class="dialog_title" v-if="enemyAttack" style="text-align: center;">
            Enemy draws near! What to do?<br>
            TIME: {{ attack_timer }}
          </div>
        </v-card-title>
        <v-img
          v-if="enemyAttack && enemy_attacking_card_id != null"
          :src="`/img/cards/card_${enemy_attacking_card_id}.jpeg`"
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
        <v-card-actions v-if="!enemyAttack">
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
        <div v-if="enemyAttack" class="your_cards enemy_attack" style="margin: 1px">
          <div style="width: 80px; height: 120px; position: absolute;margin-bottom: 50px; z-index: 9; bottom: 190px;">
            <v-img
              v-if="battleActionObj.enemyTrigger1"
              :src="`/img/cards/card_${battleActionObj.enemyTrigger1}.jpeg`"
              aspect-ratio="0.65"
              cover
              class="used-intercept"
            ></v-img>
            <v-img
              v-if="battleActionObj.enemyTrigger2"
              :src="`/img/cards/card_${battleActionObj.enemyTrigger2}.jpeg`"
              aspect-ratio="0.65"
              cover
              class="used-intercept"
            ></v-img>
          </div>
          <div v-if="battleActionObj.result === 1" style="position: absolute; left: 45px; font-size: 70px; bottom: 150px; color: #FFEE58">SUCCESS</div>
          <div v-if="battleActionObj.result === 3" style="position: absolute; left: 45px; font-size: 70px; bottom: 150px; color: #FFEE58">FAILED</div>
          <div v-if="battleActionObj.result === 2" style="position: absolute; left: 45px; font-size: 70px; bottom: 150px; color: #FFEE58">DRAW</div>
          <div v-if="battleActionObj.enemyPump" style="position: absolute; left: 110px; font-size: 38px; bottom: 300px; color: white;">{{ battleActionObj.enemyPump }}BP</div>
          <div v-if="battleActionObj.enemyPump" style="position: absolute; left: 100px; font-size: 38px; bottom: 200px; color: white;">{{ battleActionObj.enemyPump }}BP UP</div>
          <v-icon v-if="defence_executed" class="defence_executed" color="white" icon="mdi-fencing" style="position: absolute; left: 155px; font-size: 100px; bottom: 100px;"></v-icon>
          <v-row>
            <v-col
              v-for="n in 5"
              cols="2.5"
            >
              <v-img
                :src="`/img/cards/card_${your_field_unit[n]}.jpeg`"
                aspect-ratio="0.65"
                cover
                @click="defence(your_field_unit[n], n)"
              ></v-img>
              <div style="position: absolute; bottom: 0px; font-size: 12px;">
                <div v-if="battleActionObj.yourDamage && battleActionObj.yourDamage[n]" style="position: absolute; left: 1px; font-size: 18px; bottom: 15px; color: white; text-align: center;">{{ battleActionObj.yourDamage[n] }}<br>Damage</div>
                <div v-if="battleActionObj.yourPump && battleActionObj.yourPump[n]" style="position: absolute; left: 1px; font-size: 16px; bottom: 15px; width: 68px; color: #00BCD4; text-align: center;"> {{ battleActionObj.yourPump[n] }}<br>BP UP</div>
                <v-icon v-if="your_field_unit_action[n] >= 1" color="green-accent-2" icon="mdi-shield-cross-outline"></v-icon>
              </div>
            </v-col>
          </v-row>
        </div>
      </v-card>
    </div></div>
    <confirm ref="confirmRef"></confirm>
  </v-row>
</template>
<script>
import confirm from '../components/confirm'
import { Auth, API } from 'aws-amplify'
import { createTodo } from '~/src/graphql/mutations'
import { onCreateTodo } from '~/src/graphql/subscriptions'
import FlowTransactions from '~/cadence/transactions'
import FlowScripts from '~/cadence/scripts'
import { useAttrs } from 'vue'
import { collapseTextChangeRangesAcrossMultipleVersions } from 'typescript'
import { ConsoleLogger } from '@aws-amplify/core'
export default {
  components: {
    confirm
  },
  setup () {
    const confirmRef = ref(null)
    onMounted(() => {
    })
    return {
      confirmRef
    }
  },
  data() {
    return {
      walletUser: {},
      watchCurrentStatusFlg: false,
      loadingDialog: false,
      gameStartDialog: false,
      gameEndDialog: false,
      turnChangedDialog: false,
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
      matchingStartFlg: false,
      matching_time_second: '',
      marigan_time_second: 5,
      marigan_time_millisecond_1: 0,
      marigan_time_millisecond_2: 0,
      marigan_dialog: false,
      marigan_cards: [],
      marigan_count: 0,
      game_started: false,
      turn_timer: 60,
      attack_timer: 5,
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
      your_field_unit_bp_amount_of_change: {},
      opponent_field_unit_bp_amount_of_change: {},
      your_dead_cards: [],
      opponent_dead_cards: [],
      your_field_unit_action: {},
      your_field_unit_attack_action: {},
      opponent_field_unit_action: {},
      selected_card_id: null,
      selected_card_cost: null,
      selected_card_category: null,
      current_turn: '',
      display_cardinfo: '',
      display_card_type: null,
      display_card_position: null,
      show_game_dialog: false,
      show_battle_dialog: false,
      customLoading: false,
      battleDialogText: '',
      battleDialogText2: '',
      game_start_done: false,
      show_surrendar_dialog: false,
      turnChangeActionDone: false,
      show_turn_change_dialog: {1: [false, false], 2: [false, false], 3: [false, false], 4: [false, false], 5: [false, false], 6: [false, false], 7: [false, false], 8: [false, false], 9: [false, false], 10: [false, false]},
      card_information: {},
      stopCountdownTimer: null,
      attack_unit_cards: [],
      enemy_attacking_cards: [],
      enemyAttack: false,
      enemy_attacking_card_id: null,
      tempSavedCardInfo: null,
      defence_executed: false,
      defence_unit_position: null,
      battleActionObj: {},
      used_intercept_position: {},
      enemy_skill_target: {},
      defenced_unit: {},
      defenced_used_intercept: {},
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
    // const ret = await this.confirmRef.prompt('Choose the target', 'Are you sure?', { color: 'red' })
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
    countdown() { // DUBUG
      // this.stopCountdownTimer = setInterval(() => {
      //   this.turn_timer -= 1
      //   if (this.turn_timer <= 0) {
      //     this.turn_timer = '00'
      //     clearInterval(this.stopCountdownTimer)
      //     this.stopCountdownTimer = null
      //   }
      // }, 1000)
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
      console.log(`TransactionId: ${transactionId}`, arg1)
      this.loadingDialog = true
      this.checkTransactionComplete('gameStart')
    },
    showCardInfo(card_id, display_card_type, display_card_position) {
      const d = this.card_information[card_id]
      if (d) {
        let info = ''
        if (d) {
          info += '"' + d.name + '"  ' + (d.bp > 0 ? `BP: ${d.bp}` : '')
          info += ` ${d.skill.description}`
        }
        console.log('CARD:', d)
        this.display_cardinfo = info
        this.selected_card_cost = parseInt(d.cost)
        this.selected_card_category = parseInt(d.category)
        this.selected_card_id = card_id
        this.display_card_type = display_card_type
        this.display_card_position = display_card_position
      }
    },
    showBattleDialogWindow() {
      if ((this.display_card_type === 1 || this.display_card_type === 3) && this.is_first === this.is_first_turn && this.turn_timer !== '00') {
        this.show_battle_dialog = true
      }
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
    async showListings () {
      const result = await this.$fcl.query({
        cadence: FlowScripts.getOnsaleNFTs,
        args: (arg, t) => [
          arg(this.nftSeller, t.Address)
        ]
      })
      console.log(result)
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
        this.matchingStartFlg = true
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
              }, 300)
            }
          }, 50)
        }, 1000)
        if (this.game_started === false && this.onMatching === 3) {
          setTimeout(() => {
            this.show_game_dialog = true
            this.game_start_done = true
          }, 7300)
        }
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
            transactionName === 'surrendar' ||
            transactionName === 'putCardOnTheField' ||
            transactionName === 'startYourTurn'
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
                    if (this.onMatching === 1 && this.matchingStartFlg === false) {
                      this.onMatching = 3
                      this.marigan_cards = await this.get_marigan_cards()
                      this.your_hand['1'] = !this.your_hand['1'] ? this.marigan_cards[0][0] : this.your_hand['1']
                      this.your_hand['2'] = !this.your_hand['2'] ? this.marigan_cards[0][1] : this.your_hand['2']
                      this.your_hand['3'] = !this.your_hand['3'] ? this.marigan_cards[0][2] : this.your_hand['3']
                      this.your_hand['4'] = !this.your_hand['4'] ? this.marigan_cards[0][3] : this.your_hand['4']
                      if (this.game_started === false && this.onMatching === 3 && this.game_start_done === false) {
                        setTimeout(() => {
                          this.show_game_dialog = true
                        }, 1300)
                      }
                    }
                  }
                  if (transactionName !== 'watchCurrentStatus') {
                    clearInterval(timerID)
                  }
                // ゲーム開始済み
                } else if (this.game_started === true) {
                  if (transactionName === 'turnChange' && result.is_first !== result.is_first_turn) {
                    this.loadingDialog = false
                    this.battleDialogText = ''
                    this.battleDialogText2 = ''
                    this.turnChangeActionDone = false
                    clearInterval(timerID)
                  } else if(transactionName === 'putCardOnTheField' && Object.keys(this.your_field_unit).length === Object.keys(result.your_field_unit).length) { // ブロックチェーン側が反映されたという事だから
                    this.loadingDialog = false
                    this.your_remain_deck = result.your_remain_deck?.length
                    this.your_hand = result.your_hand
                    this.your_field_unit = result.your_field_unit
                    this.your_trigger_cards = result.your_trigger_cards
                    this.your_field_unit_action = result.your_field_unit_action
                    this.opponent_hand = parseInt(result.opponent_hand)
                    this.opponent_field_unit = result.opponent_field_unit
                    this.opponent_trigger_cards = result.opponent_trigger_cards
                    this.opponent_field_unit_action = result.opponent_field_unit_action
                    clearInterval(timerID)
                  } else if(transactionName === 'startYourTurn' && Object.keys(this.your_hand).length !== Object.keys(result.your_hand).length) {
                    console.log('startYourTurn:', this.your_hand, result.your_hand)
                    this.loadingDialog = false
                    this.your_remain_deck = result.your_remain_deck?.length
                    this.your_hand = result.your_hand
                    this.your_field_unit = result.your_field_unit
                    this.your_trigger_cards = result.your_trigger_cards
                    this.your_field_unit_action = result.your_field_unit_action
                    this.opponent_hand = parseInt(result.opponent_hand)
                    this.opponent_field_unit = result.opponent_field_unit
                    this.opponent_trigger_cards = result.opponent_trigger_cards
                    this.opponent_field_unit_action = result.opponent_field_unit_action
                    clearInterval(timerID)
                  }
                  if (this.onMatching != 2) {
                    this.onMatching = 3
                  }
                  // 自ターンに変わる時、且つカードを引いていない時、バトルの対応とカードドロー
                  if (!(result.is_first_turn && result.turn == '1')) {
                    if (result.is_first === result.is_first_turn && result.card_draw_in_this_turn === false && this.show_turn_change_dialog[result.turn][result.is_first_turn ? 0 : 1] === false) {
                      this.show_turn_change_dialog[result.turn][result.is_first_turn ? 0 : 1] = true
                      this.used_intercept_position = {}
                      if (this.enemyAttack === false) {
                        // バトルの対応
                        if (this.enemy_attacking_cards.length < result.enemy_attacking_cards.length) {
                          this.enemy_attacking_cards = result.enemy_attacking_cards
                          this.enemyAttack = true
                          this.battleAction()
                        } else {
                          this.enemyAttack = false
                        }
                        if (!this.enemyAttack) {
                          // カードドロー
                          this.battleDialogText = "Your turn! Draw two cards!"
                          this.battleDialogText2 = ''
                          this.show_game_dialog = true
                        }
                      }
                    }
                  }
                  // 自ターン時は更新せずあとで更新
                  if (this.turn !== result.turn || this.is_first_turn !== result.is_first_turn || result.is_first !== result.is_first_turn) {
                    this.your_life = parseInt(result.your_life)
                    this.your_remain_deck = result.your_remain_deck?.length
                    this.your_hand = result.your_hand
                    this.your_field_unit = result.your_field_unit
                    this.your_trigger_cards = result.your_trigger_cards
                    this.your_field_unit_action = result.your_field_unit_action
                    this.your_field_unit_bp_amount_of_change = result.your_field_unit_bp_amount_of_change
                    this.opponent_life = parseInt(result.opponent_life)
                    this.opponent_remain_deck = result.opponent_remain_deck
                    this.opponent_hand = parseInt(result.opponent_hand)
                    this.opponent_field_unit = result.opponent_field_unit
                    this.opponent_trigger_cards = result.opponent_trigger_cards
                    this.opponent_field_unit_action = result.opponent_field_unit_action
                    this.opponent_field_unit_bp_amount_of_change = result.opponent_field_unit_bp_amount_of_change
                    this.enemy_skill_target = {}
                  }
                  this.turn = result.turn
                  this.is_first = result.is_first
                  this.is_first_turn = result.is_first_turn
                  this.last_time_turnend = new Date(parseFloat(result.last_time_turnend) * 1000)
                  this.matched_time = new Date(parseFloat(result.matched_time) * 1000)
                  this.opponent = result.opponent
                  if (transactionName === 'watchCurrentStatus') {
                    this.gameControl()
                  }
                  if (transactionName === 'gameStart') {
                    this.loadingDialog = false
                    this.gameStartDialog = true // (Game Start)
                    this.show_turn_change_dialog[1][0] = true
                    setTimeout(() => {
                      this.gameStartDialog = false
                    }, 2000)
                    clearInterval(timerID)
                  }
                }
              }
            } else {
              if (transactionName === 'claimWin' || transactionName === 'surrendar') {
                this.onMatching = 1
              } else if (this.is_first_turn != this.is_first && this.onMatching === 3) {
                this.gameEndDialog = true
              }
              this.show_game_dialog = false
              this.show_battle_dialog = false
              this.show_surrendar_dialog = false
              this.loadingDialog = false
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
    battleAction() {
      setTimeout(()=> {
        const attackingCard = this.enemy_attacking_cards.shift()
        this.defence_executed = false
        this.defence_unit_position = null
        if (attackingCard) {
          const card = this.card_information[parseInt(attackingCard.card_id)]
          this.tempSavedCardInfo = attackingCard
          console.log('バトル発生!', card.name, attackingCard)
          this.battleActionObj.result = 0
          this.enemyAttack = true
          this.enemy_attacking_card_id = card.card_id
          this.battleActionObj.enemyTrigger1 = attackingCard.used_trigger_cards.length >= 1 ? attackingCard.used_trigger_cards[0] : null
          this.battleActionObj.enemyTrigger2 = attackingCard.used_trigger_cards.length >= 2 ? attackingCard.used_trigger_cards[1] : null
          if (attackingCard.pump) {
            this.battleActionObj.enemyPump = attackingCard.pump
          } else {
            this.battleActionObj.enemyPump = 0
          }
          this.battleActionObj.yourPump = this.your_field_unit_bp_amount_of_change
          this.battleActionObj.yourDamage = this.your_field_unit_bp_amount_of_change
          this.show_battle_dialog = true
          this.attack_timer = '5:00'
          let attack_time_second = 0
          let attack_time_millisecond_1 = 0
          let attack_time_millisecond_2 = 0
          let counter = 0
          const stopTimer = setInterval(() => {
            counter += 50
            attack_time_second = Math.floor((5000 - counter) / 1000)
            if (counter % 100 === 0) {
              attack_time_millisecond_1 = counter % 1000 / 100
              attack_time_millisecond_2 = 0
            } else {
              attack_time_millisecond_2 = 5
            }
            if (attack_time_second === 0) {
              attack_time_millisecond_2 = 0
              this.show_battle_dialog = false
              clearInterval(stopTimer)
              if (this.defence_executed) {
                if (this.battleActionObj.result === 2 || this.battleActionObj.result === 3) {
                  this.your_field_unit[this.defence_unit_position] = null
                  this.your_field_unit_action[this.defence_unit_position] = null
                }
                if (this.battleActionObj.result === 1 || this.battleActionObj.result === 2) {
                }
                setTimeout(this.battleAction, 1000)
              } else {
                this.your_life = this.your_life - 1
                setTimeout(this.battleAction, 1000)
              }
            }
            this.attack_timer = attack_time_second + ':' + attack_time_millisecond_1 + attack_time_millisecond_2
          }, 50)
        } else {
          this.enemyAttack = false
          setTimeout(() => {
            // カードドロー
            this.battleDialogText = "Your turn! Draw two cards!"
            this.battleDialogText2 = ''
            this.show_game_dialog = true
          }, 1000)
        }
      }, 1000)
    },

    async defence(card_id, position) {
      const myCard = this.card_information[card_id]
      this.defence_executed = true
      this.defence_unit_position = position
      const enemy_bp = parseInt(this.tempSavedCardInfo.bp)
      const enemy_skill_damage = this.tempSavedCardInfo.damage
      const enemy_skill_damage_to = this.tempSavedCardInfo.damage_to
      const enemy_field_position = this.tempSavedCardInfo.field_position
      const triggerCardName = "Hero's sword"
      const triggerCardCategory = 1
      let yourBP = myCard.bp
      let opponentBP = this.tempSavedCardInfo.bp

      // 攻撃をブロックしたユニットのポジション
      this.defenced_unit[enemy_field_position] = position

      for (let i = 1; i <= 4; i++){
        // トリガーゾーンにカードをセットしている場合
        if (this.your_trigger_cards[i]) {
          const card = this.card_information[this.your_trigger_cards[i]]
          // インターセプトカードの場合
          if (card.category == 2) {
            if (card.skill.trigger_1 == 5) {
              if (await this.confirmRef.confirm('Intercept Card can be invoked', `Do you use "${card.name}" Intercept Card?`, {color: 'red'})) {
                if (card.skill.type_1 == 2) {
                  yourBP += card.skill.tamount_1
                  this.battleActionObj.yourPump[position] = card.skill.tamount_1
                  // 攻撃をブロック時、使用したインターセプトのポジション
                  this.defenced_used_intercept[i] = enemy_field_position
                }
              }
            }
          }
        }
      }
      if (this.battleActionObj.yourPump[position]) {
        yourBP += this.battleActionObj.yourPump[position]
      }
      if (this.battleActionObj.yourDamage[position]) {
        yourBP -= this.battleActionObj.yourDamage[position]
      }
      if (this.battleActionObj.enemyPump) {
        opponentBP += this.battleActionObj.enemyPump
      }
      if (yourBP > opponentBP) {
        // Defence Success
        this.battleActionObj.result = 1
      } else if (yourBP == opponentBP) {
        // Draw
        this.battleActionObj.result = 2
      } else {
        // Fail
        this.battleActionObj.result = 3
      }
    },
    giveTurn() {
      this.battleDialogText = 'Do you give the turn to the opponent?'
      this.battleDialogText2 = ''
      this.show_game_dialog = true

    },
    gameControl () {
      const now = new Date()
      this.current_turn = `Turn ${this.turn} | ${this.is_first === this.is_first_turn ? 'Your' : "Enemy"} Turn`
      const p = this.is_first_turn ? 0 : 1
      const pastTime = 60 - ((now.getTime() / 1000) - (this.last_time_turnend.getTime() / 1000))
      if (pastTime <= 0) {
        // this.turn_timer = '00' // DUBUG
        if (this.is_first !== this.is_first_turn) {
          this.battleDialogText = 'TIME UP'
          this.battleDialogText2 = "Oppenent seems doesn't do any action in this turn. Claim the win of this game now!"
        } else if (!this.show_game_dialog && this.turnChangeActionDone === false) {
          this.battleDialogText = 'TIME UP'
          this.battleDialogText2 = "Give the turn to the opponent's turn."
          // this.show_game_dialog = true // DEBUG
        }
      } else {
        if (this.stopCountdownTimer === null) {
          this.turn_timer = parseInt(pastTime)
          this.countdown()
        }
      }
    },
    async turnChange() {
      this.customLoading = true
      this.attack_unit_cards.forEach((card_position) => {
        this.enemy_skill_target[card_position] = this.enemy_skill_target[card_position] || 0
      })
      console.log(999999, 'attack_unit_cards', this.attack_unit_cards, 'enemy_skill_target', this.enemy_skill_target, 'your_trigger_cards', this.your_trigger_cards)
      const transactionId = await this.$fcl.mutate({
        cadence: FlowTransactions.turnChange,
        args: (arg, t) => [
          arg(this.attack_unit_cards, t.Array(t.UInt8)), // attacking_cards
          arg({
            key: 1, value: parseInt(this.enemy_skill_target[1]) || 0,
            key: 2, value: parseInt(this.enemy_skill_target[2]) || 0,
            key: 3, value: parseInt(this.enemy_skill_target[3]) || 0,
            key: 4, value: parseInt(this.enemy_skill_target[4]) || 0,
            key: 5, value: parseInt(this.enemy_skill_target[5]) || 0,
          }, t.Dictionary({ key: t.UInt8, value: t.UInt8 })), // enemy_skill_target
          arg([{
            key: 1, value: parseInt(this.your_trigger_cards[1]) || 0,
            key: 2, value: parseInt(this.your_trigger_cards[2]) || 0,
            key: 3, value: parseInt(this.your_trigger_cards[3]) || 0,
            key: 4, value: parseInt(this.your_trigger_cards[4]) || 0,
          }], t.Dictionary({ key: t.UInt8, value: t.UInt16 })), // trigger_cards
          arg({
            key: 1, value: this.used_intercept_position[1] ? this.used_intercept_position : [],
            key: 2, value: this.used_intercept_position[2] ? this.used_intercept_position : [],
            key: 3, value: this.used_intercept_position[3] ? this.used_intercept_position : [],
            key: 4, value: this.used_intercept_position[4] ? this.used_intercept_position : [],
            key: 5, value: this.used_intercept_position[5] ? this.used_intercept_position : [],
          }, t.Dictionary({ key: t.UInt8, value: t.Array(t.UInt8) })) // used_intercept_position
        ],
        proposer: this.$fcl.authz,
        payer: this.$fcl.authz,
        authorizations: [this.$fcl.authz],
        limit: 999
      })
      console.log(`TransactionId: ${transactionId}`)
      this.show_game_dialog = false
      this.turnChangeActionDone = true
      this.customLoading = false
      this.loadingDialog = true
      this.checkTransactionComplete('turnChange')
    },
    async startYourTurn() {
      this.customLoading = true
      const transactionId = await this.$fcl.mutate({
        cadence: FlowTransactions.startYourTurn,
        args: (arg, t) => [
          arg([{
            key: 1, value: this.defenced_unit[1] || 0,
            key: 2, value: this.defenced_unit[2] || 0,
            key: 3, value: this.defenced_unit[3] || 0,
            key: 4, value: this.defenced_unit[4] || 0,
            key: 5, value: this.defenced_unit[4] || 0,
          }], t.Dictionary({ key: t.UInt8, value: t.UInt8 })), // blocked_unit
          arg([{
            key: 1, value: this.defenced_used_intercept[1] || 0,
            key: 2, value: this.defenced_used_intercept[2] || 0,
            key: 3, value: this.defenced_used_intercept[3] || 0,
            key: 4, value: this.defenced_used_intercept[4] || 0,
          }], t.Dictionary({ key: t.UInt8, value: t.UInt8 })), // used_intercept_position
        ],
        proposer: this.$fcl.authz,
        payer: this.$fcl.authz,
        authorizations: [this.$fcl.authz],
        limit: 999
      })
      console.log(`TransactionId: ${transactionId}`)
      this.show_game_dialog = false
      this.turnChangeActionDone = true
      this.customLoading = false
      this.loadingDialog = true
      this.checkTransactionComplete('startYourTurn')
    },
    async putCardOnTheField(field_position, card_id, used_intercept_card, enemy_skill_target) {
      this.customLoading = true
      setTimeout(() => (this.customLoading = false), 5000)
      console.log("The Card Put on the Field:", card_id, field_position, card_id, used_intercept_card, enemy_skill_target)
      const transactionId = await this.$fcl.mutate({
        cadence: FlowTransactions.putCardOnField,
        args: (arg, t) => [
          arg([{key: field_position, value: card_id }], t.Dictionary({ key: t.UInt8, value: t.UInt16 })), // unit_card
          arg(enemy_skill_target || 0, t.UInt8), // enemy_skill_target
          arg([{
            key: 1, value: this.your_trigger_cards[1] || 0,
            key: 2, value: this.your_trigger_cards[2] || 0,
            key: 3, value: this.your_trigger_cards[4] || 0,
            key: 4, value: this.your_trigger_cards[4] || 0,
          }], t.Dictionary({ key: t.UInt8, value: t.UInt16 })), // trigger_cards
          arg(used_intercept_card, t.Array(t.UInt8)) // used_intercept_positions
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
      this.checkTransactionComplete('putCardOnTheField')
    },
    async cardMoveDecided() {
      this.show_battle_dialog = false
      const card = this.card_information[this.selected_card_id]
      if (card) {
        switch (this.display_card_type) {
          case 1:
            let enemy_skill_target = null
            // The card trigger is when the unit is put on the field
            if (card.skill.trigger_1 === 1 || card.skill.trigger_1 === '1') {
              if (card.skill.ask_1 === 1 || card.skill.ask_1 === '1') {
                let enemy_targets = []
                Object.keys(this.opponent_field_unit).forEach((position) => {
                  if (this.opponent_field_unit[position] && this.opponent_field_unit[position] != '0') {
                    const unit3 = this.card_information[this.opponent_field_unit[position]]
                    enemy_targets.push({position: position, name: unit3.name})
                  }
                })
                if (enemy_targets.length > 0) {
                  enemy_skill_target = await this.confirmRef.prompt('Choose the unit target', enemy_targets, {color: 'red'})
                }
              } else if (card.skill.ask_1 === 3 || card.skill.ask_1 === '3') {
                let enemy_targets = []
                Object.keys(this.opponent_field_unit_action).forEach((position) => {
                  if (this.opponent_field_unit_action[position] == 2) {
                    const unit3 = this.card_information[this.opponent_field_unit[position]]
                    enemy_targets.push({position: position, name: unit3.name})
                  }
                })
                if (enemy_targets.length > 0) {
                  enemy_skill_target = await this.confirmRef.prompt('Choose the unit target', enemy_targets, {color: 'red'})
                }
              }
            }

            const used_intercept_cards = []
            for (let position in Object.keys(this.your_trigger_cards)) {
              if (this.your_trigger_cards[position] != null && this.your_trigger_cards[position] > 0) {
                const d = this.card_information[this.your_trigger_cards[position]]
                if (d) {
                  // トリガー
                  if (d.category === 1) {
                    // The card trigger is when the unit is put on the field
                    if (d.skill.trigger_1 === 1 || d.skill.trigger_1 === '1') {
                      used_intercept_cards.push(parseInt(d.card_id))
                    }
                  }
                  // インターセプト
                  if (d.category === 2) {
                    // 無色 color
                    if (d.type === 4) {
                      // The card trigger is when the unit is put on the field
                      if (d.skill.trigger_1 === 1 || d.skill.trigger_1 === '1') {
                        if (await this.confirmRef.confirm('Intercept Card can be invoked', `Do you use "${d.name}" Intercept Card?`, {color: 'red'})) {
                          if (d.skill.ask_1 === 1 || d.skill.ask_1 === '1') {
                            used_intercept_cards.push(parseInt(d.card_id))
                            let enemy_targets = []
                            Object.keys(this.opponent_field_unit).forEach((position) => {
                              if (this.opponent_field_unit[position] && this.opponent_field_unit[position] != '0') {
                                const unit3 = this.card_information[this.opponent_field_unit[position]]
                                enemy_targets.push({position: position, name: unit3.name})
                              }
                            })
                            if (enemy_targets.length > 0) {
                              enemy_skill_target = await this.confirmRef.prompt('Choose the unit target', enemy_targets, {color: 'red'})
                            } else {
                              alert('Sorry, in this field, there is no target of this trigger card. Do again.')
                            }
                          }
                        }
                      }
                    } else {
                      let same_color_on_the_field = false
                      if (card.type === d.type) {
                        same_color_on_the_field = true
                      }
                      for (let unit_position in Object.keys(this.your_field_unit)) {
                        const unit2 = this.card_information[this.your_field_unit[unit_position]]
                        console.log(4, unit2)
                        if (d.type === unit2.type) {
                          same_color_on_the_field = true
                        }
                      }
                      // The card trigger is when the unit is put on the field
                      if (same_color_on_the_field && (d.skill.trigger_1 === 1 || d.skill.trigger_1 === '1')) {
                        if (await this.confirmRef.confirm('Intercept Card can be invoked', `Do you use "${d.name}" Intercept Card?`, {color: 'red'})) {
                          used_intercept_cards.push(parseInt(d.card_id))
                          if (d.skill.ask_1 === 1 || d.skill.ask_1 === '1') {
                            let enemy_targets = []
                            Object.keys(this.opponent_field_unit).forEach((position) => {
                              if (this.opponent_field_unit[position] && this.opponent_field_unit[position] != '0') {
                                const unit3 = this.card_information[this.opponent_field_unit[position]]
                                enemy_targets.push({position: position, name: unit3.name})
                              }
                            })
                            if (enemy_targets.length > 0) {
                              enemy_skill_target = await this.confirmRef.prompt('Choose the unit target', enemy_targets, {color: 'red'})
                            } else {
                              alert('Sorry, in this field, there is no target of this trigger card. Do again.')
                            }
                          } else if (d.skill.ask_1 === 3 || d.skill.ask_1 === '3') {
                            let enemy_targets = []
                            Object.keys(this.opponent_field_unit_action).forEach((position) => {
                              if (this.opponent_field_unit_action[position] == 2) {
                                const unit3 = this.card_information[this.opponent_field_unit[position]]
                                enemy_targets.push({position: position, name: unit3.name})
                              }
                            })
                            if (enemy_targets.length > 0) {
                              enemy_skill_target = await this.confirmRef.prompt('Choose the unit target', enemy_targets, {color: 'red'})
                            } else {
                              alert('Sorry, in this field, there is no target of this trigger card. Do again.')
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            // ユニットカード且つフィールドに置けるスペースがある場合
            if (this.selected_card_category === 0 && !this.your_field_unit[5]) {
              if (this.your_cp >= card.cost) {
                // ハンドを減らす
                this.your_cp -= card.cost
                for (let i = this.display_card_position; i <= 6; i++) {
                  this.your_hand[i] = this.your_hand[i+1]
                }
                this.your_hand[7] = null
                // 場に出す
                let isSet = false
                for (let i = 1; i <= 5; i++) {
                  if (!this.your_field_unit[i] && !isSet) {
                    this.your_field_unit[i] = this.selected_card_id
                    this.your_field_unit_action[i] = 1
                    isSet = true
                    this.putCardOnTheField(i, this.selected_card_id, used_intercept_cards)
                  }
                }
              }
            }
            // トリガー（インターセプト）カード且つフトリガーゾーンに置けるスペースがある場合
            if ((this.selected_card_category === 1 || this.selected_card_category === 2) && !this.your_trigger_cards[4]) {
              // ハンドを減らす
              this.your_cp -= card.cost
              for (let i = this.display_card_position; i <= 6; i++) {
                this.your_hand[i] = this.your_hand[i+1]
              }
              this.your_hand[7] = null
              // 場に出す
              let isSet = false
              for (let i = 1; i <= 4; i++) {
                if (!this.your_trigger_cards[i] && !isSet) {
                  this.your_trigger_cards[i] = this.selected_card_id
                  isSet = true
                }
              }
            }
            // if (this.your_hand[this.display_card_position] === this.selected_card_id) {
            //   this.your_hand
            // }
            break
          case 3:
            console.log('display_card_type', this.display_card_type, 'display_card_position', this.display_card_position, 'selected_card_id', this.selected_card_id, card)
            console.log('your_hand:', this.your_hand, 'opponent_field_unit:', this.opponent_field_unit, this.display_card_position)
            this.your_field_unit_attack_action[this.display_card_position] = 1
            let skill_target = 0
            if (card.skill.ask_1 === 1 || card.skill.ask_1 === '1') {
              let enemy_targets = []
              Object.keys(this.opponent_field_unit).forEach((position) => {
                if (this.opponent_field_unit[position] && this.opponent_field_unit[position] != '0') {
                  const unit3 = this.card_information[this.opponent_field_unit[position]]
                  enemy_targets.push({position: position, name: unit3.name})
                }
              })
              if (enemy_targets.length > 0) {
                skill_target = await this.confirmRef.prompt('Choose the unit target', enemy_targets, {color: 'red'})
              }
              this.enemy_skill_target[this.display_card_position] = skill_target
            }
            if (!this.attack_unit_cards.includes(this.display_card_position)) {
              this.attack_unit_cards.push(this.display_card_position)
              for (let i = 1; i <= 4; i++){
                // トリガーゾーンにカードをセットしている場合
                if (this.your_trigger_cards[i]) {
                  const card = this.card_information[this.your_trigger_cards[i]]
                  // インターセプトカードの場合
                  if (card.category == 2) {
                    if (card.skill.trigger_1 == 2 || card.skill.trigger_1 == 5) {
                      if (await this.confirmRef.confirm('Intercept Card can be invoked', `Do you use "${card.name}" Intercept Card?`, {color: 'red'})) {
                        if (card.skill.type_1 == 2) {
                          if (!this.used_intercept_position[this.display_card_position]) {
                            this.used_intercept_position[this.display_card_position] = []
                            this.used_intercept_position[this.display_card_position].push(card.card_id)
                          } else {
                            this.used_intercept_position[this.display_card_position].push(card.card_id)
                          }
                        }
                      }
                    }
                  } else if (card.category == 1 && card.skill.trigger_1 == 2) {
                    await this.confirmRef.confirm('Trigger Card has been invoked', `${card.name}" trigger card is activated!`, {color: 'red'})
                    if (!this.used_intercept_position[this.display_card_position]) {
                      this.used_intercept_position[this.display_card_position] = []
                      this.used_intercept_position[this.display_card_position].push(card.card_id)
                    } else {
                      this.used_intercept_position[this.display_card_position].push(card.card_id)
                    }
                  }
                }
              }
            }
            break
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

/* field */
.your_cards {
  clear: both;
  margin-top: 60px;
}
.your_cards .v-col {
  padding-right: 6px;
}
.rival_cards .v-col {
  padding-right: 6px;
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
  color: #00BCD4;
  text-align: center;
}

.remaining_time.opponent {
  width: 290px;
  color: #FF5722;
}

.macthing_time {
  width: 28px;
  margin: 0 auto;
}

.dialog_title {
  margin: 5px;
}

.game_dialog {
  width: 400px;
  font-size: 18px;
  padding: 35px;
  background-color: #9C27B0;
  color: white;
  border-radius: 20px;
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
@media screen and (max-width: 700px) and (orientation: portrait) {
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
    margin-top: 5px;
  }
  .dialog_title {
    font-size: 16px;
  }

  .marigan_buttons {
    display: block;
    margin: 0 auto;
    width: 200px;
  }

  .remaining_time {
    width: 290px;
  }

  .enemy_attack div {
    font-size: 22px !important;
  }

  .enemy_attack .v-row {
    padding: 3px;
  }

  .defence_executed {
    left: 100px !important;
  }

  .text-h6 {
    font-size: 1.0rem !important;
  }

  .game_dialog {
    width: 340px;
    font-size: 15px;
    padding: 35px;
    background-color: #9C27B0;
    color: white;
    border-radius: 20px;
    margin: 0 auto;
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
/* landscape対応 */
@media (orientation: landscape) and (max-width: 1000px) {
  .section {
    height: calc(100vh);
  }

  .navbar {
    z-index: 99;
  }

  .navbar.header {
    display: none;
  }
  .main-screen {
    font-size: 10px;
  }
  .section .content.top-screen {
    top: 50px;
  }
  .section .game-screen {
    height: calc(100vh - 35px);
  }
  .your_hands {
    margin-top: 5px;
  }
  .card_information {
    max-width: 400px !important;
  }
  #field {
    bottom: 20%;
    right: 5%;
  }
}
@media screen and (max-width: 700px) and (orientation: landscape) {
  .your_hands {
    max-width: 310px;
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
    width: 325px;
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
