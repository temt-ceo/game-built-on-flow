<script setup lang="ts">
import {Authenticator} from "@aws-amplify/ui-vue"
import "@aws-amplify/ui-vue/styles.css"
</script>
<template>
  <div>
    <Authenticator>
      <NuxtPage />
    </Authenticator>
  </div>
</template>
