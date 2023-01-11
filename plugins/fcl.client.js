import * as fcl from "@onflow/fcl"
import * as types from "@onflow/types"

fcl.config({
    "accessNode.api": "https://rest-testnet.onflow.org",
    "discovery.wallet": "https://fcl-discovery.onflow.org/testnet/authn",
    "app.detail.title": "Sample App", 
    "app.detail.icon": "https://fcl-discovery.onflow.org/images/blocto.png", 
    "0xmyAddr": "0x631e88ae7f1d7c20" 
})

export default defineNuxtPlugin((nuxtApp) => {
    nuxtApp.provide("fcl", fcl)
    nuxtApp.provide("fclArgType", types)
})