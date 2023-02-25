export default {
    isRegistered: `
    import CodeOfFlowDay5_4 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay5_4.Player{CodeOfFlowDay5_4.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay5_4.Player{CodeOfFlowDay5_4.IPlayerPublic}>(CodeOfFlowDay5_4.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDay5_4 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay5_4.Player{CodeOfFlowDay5_4.IPlayerPublic}>(CodeOfFlowDay5_4.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowDay5_4 from 0xCOF
    pub fun main(address: Address): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay5_4.Player{CodeOfFlowDay5_4.IPlayerPublic}>(CodeOfFlowDay5_4.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards()
    }
    `,
    getCardInfo: `
    import CodeOfFlowDay5_4 from 0xCOF
    pub fun main(): {UInt16: CodeOfFlowDay5_4.CardStruct} {
        return CodeOfFlowDay5_4.getCardInfo()
    }
    `,
    getMatchingLimits: `
    import CodeOfFlowDay5_4 from 0xCOF
    pub fun main(): [UFix64] {
        return CodeOfFlowDay5_4.getMatchingLimits()
    }
    `,
    getPlayersScore: `
    import CodeOfFlowDay5_4 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay5_4.Player{CodeOfFlowDay5_4.IPlayerPublic}>(CodeOfFlowDay5_4.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_players_score()
    }
    `,
}
