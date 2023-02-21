import * as fcl from "@onflow/fcl"
import * as types from "@onflow/types"

fcl.config({
    "accessNode.api": "https://rest-testnet.onflow.org",
    "discovery.wallet": "https://fcl-discovery.onflow.org/testnet/authn",
    "app.detail.title": "Sample App", 
    "app.detail.icon": "https://fcl-discovery.onflow.org/images/blocto.png", 
    '0xCOF': '0x9e447fb949c3f1b6' // The account address where the smart contract lives
})

export default defineNuxtPlugin((nuxtApp) => {
    nuxtApp.provide("fcl", fcl)
    nuxtApp.provide("fclArgType", types)
})