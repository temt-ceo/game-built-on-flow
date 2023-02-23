export default {
    isRegistered: `
    import CodeOfFlowDay3_8 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay3_8.Player{CodeOfFlowDay3_8.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay3_8.Player{CodeOfFlowDay3_8.IPlayerPublic}>(CodeOfFlowDay3_8.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDay3_8 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay3_8.Player{CodeOfFlowDay3_8.IPlayerPublic}>(CodeOfFlowDay3_8.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowDay3_8 from 0xCOF
    pub fun main(address: Address): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay3_8.Player{CodeOfFlowDay3_8.IPlayerPublic}>(CodeOfFlowDay3_8.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards()
    }
    `,
    getCardInfo: `
    import CodeOfFlowDay3_8 from 0xCOF
    pub fun main(): {UInt16: CodeOfFlowDay3_8.CardStruct} {
        return CodeOfFlowDay3_8.getCardInfo()
    }
    `,
    getMatchingLimits: `
    import CodeOfFlowDay3_8 from 0xCOF
    pub fun main(): [UFix64] {
        return CodeOfFlowDay3_8.getMatchingLimits()
    }
    `,
    getPlayersScore: `
    import CodeOfFlowDay3_8 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay3_8.Player{CodeOfFlowDay3_8.IPlayerPublic}>(CodeOfFlowDay3_8.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_players_score()
    }
    `,
}
