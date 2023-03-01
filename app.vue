<script setup>
import {Authenticator, useAuthenticator} from "@aws-amplify/ui-vue"
import "@aws-amplify/ui-vue/styles.css"
const auth = useAuthenticator()
</script>top-screen
<template>
  <div>
    <authenticator variation="modal">
      <template v-slot="{ user }">
        <nav
          class="navbar header has-shadow"
          role="navigation"
          aria-label="main navigation"
        >
          <div class="navbar-brand">
            <img src="/img/CODE_Of_Flow.png" style="height: 37px;" />
            <div style="font-size: 12px; margin-top: 3px;">Agent Name: {{ user.username }}</div>
            <v-btn @click="signOut(auth)" color="primary" class="sign-out" style="margin-top: 5px; height: 29px;">Sign Out</v-btn>
          </div>
        </nav>
        <section class="section top-screen">
          <NuxtPage :player="user" />
        </section>
      </template >

      <template v-slot:sign-in-header>
         <!-- DIALOG BUTTON -->
         <h1>
          <img src="/img/CODE_Of_Flow.png" style="height: 30px;" />
          <v-btn
            color="red-darken-4"
            style="position: absolute; left: 45%;"
            @click="showDialog2 = true"
          >Tutorial</v-btn>
          <!-- DIALOG START -->
          <div v-if="showDialog2" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;">
            <div class="v-overlay__content" style="width: auto;">
              <div class="v-card v-theme--light bg-primary v-card--density-default v-card--variant-elevated">
                <div class="v-card__loader"><div class="v-progress-linear v-theme--light" role="progressbar" aria-hidden="true" aria-valuemin="0" aria-valuemax="100" style="top: 0px; height: 0px; --v-progress-linear-height:2px; left: 50%; transform: translateX(-50%);">
                  <div class="v-progress-linear__background" style="width: 100%;"></div><div class="v-progress-linear__indeterminate"><div class="v-progress-linear__indeterminate long"></div><div class="v-progress-linear__indeterminate short"></div>
                </div>
                </div>
              </div>
              <div class="v-card-text" style="font-size: 14px;">
                <a href="https://www.youtube.com/watch?v=tD3yP_aWlDA&list=PLqsOlIn4zb87Pzk-82mFccQsGG0zRUzzd&index=1" target="_blank" style="color: white;">PC Tutorial</a><br>
                <a href="https://www.youtube.com/watch?v=vBLIsxPzeCU&list=PLqsOlIn4zb87Pzk-82mFccQsGG0zRUzzd&index=2" target="_blank" style="color: white;">SmartPhone(portrait) Tutorial</a><br>
                <a href="https://www.youtube.com/watch?v=icNegdUYlx4&list=PLqsOlIn4zb87Pzk-82mFccQsGG0zRUzzd&index=3" target="_blank" style="color: white;">SmartPhone(landscape) Tutorial</a><br><br><br><br><br>
                  (CODE-Of-Flow is an homage to SEGA's "Code Of Joker")
                  <div><br>
                    If you don't know Code Of Joker👇<br>
                    <a href="https://m.youtube.com/watch?v=tYioSA10Ckc" target="_blank" style="color:aqua;">https://m.youtube.com/watch?v=tYioSA10Ckc</a><br>
                  </div><br>
                  <v-btn
                    class="ma-1"
                    @click="showDialog2 = false"
                  >Close</v-btn><br><br>

                <div class="v-progress-linear v-progress-linear--active v-theme--light mb-0" role="progressbar" aria-hidden="false" aria-valuemin="0" aria-valuemax="100" style="top: 0px; height: 4px; --v-progress-linear-height:4px; left: 50%; transform: translateX(-50%);">
                  <div class="v-progress-linear__background bg-white" style="width: 100%;"></div>
                  <div class="v-progress-linear__indeterminate">
                    <div class="v-progress-linear__indeterminate long bg-white"></div>
                    <div class="v-progress-linear__indeterminate short bg-white"></div>
                  </div>
                </div>
                </div><span class="v-card__underlay"></span>
              </div>
            </div>
          </div>
          <!-- DIALOG SEND -->
        </h1>
      </template >

      <template v-slot:sign-up-header>
        <h1>
          <img src="/img/CODE_Of_Flow.png" style="height: 30px;" />
          <!-- DIALOG BUTTON -->
          <v-btn
            color="red-darken-4"
            @click="showDialog = true"
          >Mission Description</v-btn>
          <!-- DIALOG START -->
          <div v-if="showDialog" class="v-overlay v-overlay--active v-theme--light v-locale--is-ltr v-dialog v-overlay--scroll-blocked" aria-role="dialog" aria-modal="true" style="z-index: 2400;">
            <div class="v-overlay__content" style="width: auto;">
              <div class="v-card v-theme--light bg-primary v-card--density-default v-card--variant-elevated">
                <div class="v-card__loader"><div class="v-progress-linear v-theme--light" role="progressbar" aria-hidden="true" aria-valuemin="0" aria-valuemax="100" style="top: 0px; height: 0px; --v-progress-linear-height:2px; left: 50%; transform: translateX(-50%);">
                  <div class="v-progress-linear__background" style="width: 100%;"></div><div class="v-progress-linear__indeterminate"><div class="v-progress-linear__indeterminate long"></div><div class="v-progress-linear__indeterminate short"></div>
                </div>
                </div>
              </div>
              <div class="v-card-text" style="font-size: 14px;">
                  Welcome. My name is Actis. I am here to support you and your agents. Your mission as agents is to keep cyberspace safe. Your role is to infiltrate the cyberspace, Arcana, and fight off hackers and others who try to destroy the cyberspace Arcana. Register your agent name and register on the Flow Blockchain to infiltrate Arcana. If you are matched with other opponents, the game will switch to battle mode. I will support you and you will have to use your abilities to fight them off to keep Arkana safe. <br><br>
                  (CODE-Of-Flow is an homage to SEGA's "Code Of Joker")
                  <div><br><br><br><br>
                    If you don't know Code Of Joker👇<br>
                    <a href="https://m.youtube.com/watch?v=tYioSA10Ckc" target="_blank">https://m.youtube.com/watch?v=tYioSA10Ckc</a><br>
                  </div><br>
                  <v-btn
                    class="ma-1"
                    @click="showDialog = false"
                  >Close</v-btn><br><br>

                <div class="v-progress-linear v-progress-linear--active v-theme--light mb-0" role="progressbar" aria-hidden="false" aria-valuemin="0" aria-valuemax="100" style="top: 0px; height: 4px; --v-progress-linear-height:4px; left: 50%; transform: translateX(-50%);">
                  <div class="v-progress-linear__background bg-white" style="width: 100%;"></div>
                  <div class="v-progress-linear__indeterminate">
                    <div class="v-progress-linear__indeterminate long bg-white"></div>
                    <div class="v-progress-linear__indeterminate short bg-white"></div>
                  </div>
                </div>
                </div><span class="v-card__underlay"></span>
              </div>
            </div>
          </div>
          <!-- DIALOG SEND -->
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
      showDialog: false,
      showDialog2: false,
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
  z-index: 999;
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
  text-align: center;
  transform: translateY(5px);
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
    background-image: url(https://cdn.vuetifyjs.com/images/backgrounds/bg-2.jpg);
    background-repeat: repeat;
  }

  body > div {
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
    background-image: url(https://cdn.vuetifyjs.com/images/backgrounds/bg-2.jpg);
    background-repeat: repeat;
  }

  body > div {
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