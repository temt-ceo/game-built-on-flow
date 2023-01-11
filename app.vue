<script setup lang="ts">
import {Authenticator, useAuthenticator} from "@aws-amplify/ui-vue"
import "@aws-amplify/ui-vue/styles.css"
const auth = useAuthenticator()
</script>
<template>
  <div>
    <Authenticator>
      <button @click="auth.signOut">Sign Out</button>
      <NuxtPage />
    </Authenticator>
  </div>
</template>

