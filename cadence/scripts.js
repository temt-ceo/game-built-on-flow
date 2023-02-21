export default {
    isRegistered: `
    import CodeOfFlowDay1 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay1.Player{CodeOfFlowDay1.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay1.Player{CodeOfFlowDay1.IPlayerPublic}>(CodeOfFlowDay1.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDay1 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay1.Player{CodeOfFlowDay1.IPlayerPublic}>(CodeOfFlowDay1.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
}
