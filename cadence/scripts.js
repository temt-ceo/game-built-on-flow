export default {
    isRegistered: `
    import CodeOfFlowDay5 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay5.Player{CodeOfFlowDay5.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay5.Player{CodeOfFlowDay5.IPlayerPublic}>(CodeOfFlowDay5.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDay5 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay5.Player{CodeOfFlowDay5.IPlayerPublic}>(CodeOfFlowDay5.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowDay5 from 0xCOF
    pub fun main(address: Address): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay5.Player{CodeOfFlowDay5.IPlayerPublic}>(CodeOfFlowDay5.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards()
    }
    `,
    getCardInfo: `
    import CodeOfFlowDay5 from 0xCOF
    pub fun main(): {UInt16: CodeOfFlowDay5.CardStruct} {
        return CodeOfFlowDay5.getCardInfo()
    }
    `,
    getMatchingLimits: `
    import CodeOfFlowDay5 from 0xCOF
    pub fun main(): [UFix64] {
        return CodeOfFlowDay5.getMatchingLimits()
    }
    `,
    getPlayersScore: `
    import CodeOfFlowDay5 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay5.Player{CodeOfFlowDay5.IPlayerPublic}>(CodeOfFlowDay5.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_players_score()
    }
    `,
}
