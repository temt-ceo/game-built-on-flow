<script setup>
import {Authenticator, useAuthenticator} from "@aws-amplify/ui-vue"
import "@aws-amplify/ui-vue/styles.css"
const auth = useAuthenticator()
</script>top-screen
<template>
  <div>
    <authenticator :initial-state="'signup'" :social-provider="['facebook', 'google']" variation="modal">
      <template v-slot="{ user }">
        <nav
          class="navbar header has-shadow"
          role="navigation"
          aria-label="main navigation"
        >
          <div class="navbar-brand">
            <img src="/img/CODE_Of_Flow.png" style="height: 37px;" />
            <div style="font-size: 10px; margin-top: 5px;">Agent Name: {{ user.username }}</div>
            <v-btn @click="signOut(auth)" color="primary" class="sign-out">Sign Out</v-btn>
          </div>
        </nav>
        <section class="section top-screen">
          <NuxtPage :player="user" />
        </section>
      </template >

    <template v-slot:sign-in-header>
      <h1><img src="/img/CODE_Of_Flow.png" style="height: 30px;" /></h1>
    </template >

    <template v-slot:sign-up-header>
      <h1>
        <img src="/img/CODE_Of_Flow.png" style="height: 30px;" />
        <v-dialog
          transition="dialog-top-transition"
          width="auto"
        >
          <template v-slot:activator="{ props }">
            <v-btn
              color="red-darken-4"
              v-bind="props"
            >Mission Description</v-btn>
          </template>
          <template v-slot:default="{ isActive }">
            <v-card>
              <v-tabs
                v-model="mission_tab"
                bg-color="red-darken-3"
              >
                <v-tab value="en">EN</v-tab>
                <v-tab value="ja">JP</v-tab>
              </v-tabs>
              <v-toolbar
                color="red-darken-4"
                title="Mission Description"
              ></v-toolbar>
              <v-card-text>
                <v-window v-model="mission_tab">
                  <v-window-item value="en">
                    Welcome. My name is Actis. I am here to support you and your agents. Your mission as agents is to keep cyberspace safe. Your role is to infiltrate the cyberspace, Arcana, and fight off hackers and others who try to destroy the cyberspace Arcana. Register your agent name and register on the Flow Blockchain to infiltrate Arcana. If you are matched with other opponents, the game will switch to battle mode. I will support you and you will have to use your abilities to fight them off to keep Arkana safe. <br><br>
                    (CODE-Of-Flow is an homage to SEGA's "Code Of Joker")
                    <div>
                      If you don't know Code Of Joker👇<br>
                      <a href="https://m.youtube.com/watch?v=tYioSA10Ckc">https://m.youtube.com/watch?v=tYioSA10Ckc</a><br>
                      Tutorial👇<br>
                      <a href="https://www.youtube.com/watch?v=zKBCmXlFOLU">https://www.youtube.com/watch?v=zKBCmXlFOLU</a>
                    </div>
                  </v-window-item>

                  <v-window-item value="ja">
                    ようこそ。私の名前はアクティス。貴方達エージェントのサポートを致します。貴方達エージェントの使命はサイバー空間の安全を保つ事です。貴方達の役割はサイバー空間、アルカナに潜入し、ハッカーなどサイバー空間アルカナを壊そうとする連中を撃退する事です。
                    あなたのエージェント名を登録し、アルカナに潜入する為、Flow Blockchain 上で登録を行ってください。貴方達以外の対立する組織とマッチングした場合はバトルモードに切り替わります。
                    私はサポートに回りますので、貴方は能力を発揮してアルカナの安全を守るため相手を撃退して下さい。<br><br>
                    (このCODE-Of-FlowはSEGAの”Code Of Joker”をオマージュしたゲームです)
                    <div>
                      Code Of Joker👇<br>
                      <a href="https://m.youtube.com/watch?v=tYioSA10Ckc">https://m.youtube.com/watch?v=tYioSA10Ckc</a><br>
                      チュートリアル👇<br>
                      <a href="https://www.youtube.com/watch?v=zKBCmXlFOLU">https://www.youtube.com/watch?v=zKBCmXlFOLU</a>
                    </div>
                  </v-window-item>
                </v-window>
              </v-card-text>
              <v-card-actions class="justify-end">
                <v-btn
                  variant="text"
                  @click="isActive.value = false"
                >Close</v-btn>
              </v-card-actions>
            </v-card>
          </template>
        </v-dialog>
      </h1>
    </template >

    <template v-slot:sign-in-footer>
    </template >

    <template v-slot:sign-up-footer>
    </template >
  </Authenticator>
</div>
</template>
<script>
import { Auth, API } from 'aws-amplify'
import { createTodo } from '~/src/graphql/mutations'
import { onCreateTodo } from '~/src/graphql/subscriptions'
import FlowTransactions from '~/cadence/transactions'
import FlowScripts from '~/cadence/scripts'
import { useAttrs } from 'vue'
export default {
  data() {
    return {
      mission_tab: 'en',
    }
  },
  methods: {
    async signOut (auth) {
      await this.$fcl.unauthenticate()
      auth.signOut()
    },
  },
}
</script>
<style>
body {
  margin: 0;
}

h1, h2, h3, h4, h5{
  margin: 0;
  padding: 5px;
}

h6 {
  color: green;
  margin: 0;
  padding-left: 25px;
  padding-right: 25px;
  padding-bottom: 25px;
}

.navbar {
  position: sticky;
  top: 0;
  background-color: #596886 !important;
  font-size: 17px;
}

.navbar-brand {
  -webkit-box-align: stretch;
  -ms-flex-align: stretch;
  align-items: stretch;
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
  -ms-flex-negative: 0;
  flex-shrink: 0;
  min-height: 2.25rem;
}

.sign-out {
  margin: 3px 3px 3px auto;
}

.section {
  height: calc(100vh - 53px);
  padding: 1.0rem 0.3rem 0 2.5rem;
  max-width: 1300px;
  margin: 0 auto;
  position: relative;
}

.section .game-screen {
  width: 100%;
  max-width: 1300px;
  height: calc(100vh - 70px);
  margin: 0 auto;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 30px;
  border: 2px solid rgba(255, 255, 5, 0.7);
  position: relative;
  overflow: hidden;
}

.section .content.top-screen {
  background-image: url(https://cdn.vuetifyjs.com/images/backgrounds/bg-2.jpg);
  background-repeat: repeat;
  padding-top: 2px;
  top: 65px;
  margin-bottom: 0.3rem;
}
.section .content {
  position: absolute;
  left: 0;
  right: 0;
  overflow: auto;
  top: 75px;
  padding-top: 20px;
  background-color: white;
  bottom: 0;
  border-bottom-left-radius: 30px;
  border-bottom-right-radius: 30px;
}


.header-bar {
  width: 100%;
  transform: translateY(16px);
  position: relative;
}
/* 

.header-bar .control {
  width: 90%;
  font-family: 'Roboto', sans-serif;
  outline: none;
  border: none;
  border-radius: 40px;
  margin: auto;
  display: block;
  -webkit-box-shadow: 0px 3px 10px -2px #cccccc;
  box-shadow: 0px 3px 10px -2px #cccccc;
}

.header-bar .control .content {
  position: absolute;
  left: 0;
  right: 0;
  overflow: auto;
  top: 75px;
  padding-top: 20px;
  background-color: white;
  bottom: 0;
  border-bottom-left-radius: 30px;
  border-bottom-right-radius: 30px;
} */

[data-amplify-authenticator] {
  --amplify-colors-background-primary: var(--amplify-colors-neutral-90);
  --amplify-colors-background-secondary: var(--amplify-colors-neutral-90);
  --amplify-colors-brand-primary-10: var(--amplify-colors-neutral-90);
  --amplify-colors-brand-primary-80: var(--amplify-colors-neutral-90);
  --amplify-colors-brand-primary-90: var(--amplify-colors-neutral-90);
  --amplify-colors-brand-primary-100: var(--amplify-colors-neutral-90);
  --amplify-colors-font-interactive: var(--amplify-colors-neutral-90);
  --amplify-components-tabs-item-active-color: var(--amplify-colors-neutral-90);
  --amplify-components-tabs-item-focus-color: var(--amplify-colors-neutral-90);
  --amplify-components-tabs-item-hover-color: var(--amplify-colors-neutral-90);
}

@media screen and (min-width: 1024px) {
  .navbar {
    display: block;
  }
}
@media screen and (min-width: 700px) {
  body {
    background-image: url('/img/453d816d7d25d5a4aa075a8c64c79818.jpg');
    background-repeat: repeat-x;
    animation: bg 45s linear infinite;
  }

  .navbar {
    font-size: 17px;
  }
}
@media screen and (max-width: 750px) {
  .section {
    padding: 0.6rem 0.3rem 0 2.5rem;
  }
}
@media screen and (max-width: 700px) {
  body {
    background-image: url('/img/453d816d7d25d5a4aa075a8c64c79818.jpg');
    background-repeat: repeat;
    animation: bg_sp 80s linear infinite;
  }
}

@keyframes bg {
  0% {
    background-image: url('/img/198ff9cc76f5a86ad1de61447a01a57b.jpg');
  }
  40% {
    background-image: url('/img/hearthands.jpg');
  }
  100% {
    background-image: url('/img/198ff9cc76f5a86ad1de61447a01a57b.jpg');
  }
}

@keyframes bg_sp {
  0% {
    background-image: url('/img/hearthands.jpg');
  }
  50% {
    background-image: url('/img/198ff9cc76f5a86ad1de61447a01a57b.jpg');
  }
  100% {
    background-image: url('/img/hearthands.jpg');
  }
}
</style>