export default {
    isRegistered: `
    import CodeOfFlowDay2 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay2.Player{CodeOfFlowDay2.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay2.Player{CodeOfFlowDay2.IPlayerPublic}>(CodeOfFlowDay2.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDay2 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay2.Player{CodeOfFlowDay2.IPlayerPublic}>(CodeOfFlowDay2.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowDay2 from 0xCOF
    pub fun main(address: Address): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay2.Player{CodeOfFlowDay2.IPlayerPublic}>(CodeOfFlowDay2.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards()
    }
    `,
}
