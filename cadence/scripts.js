export default {
    isRegistered: `
    import CodeOfFlowDay4_2 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay4_2.Player{CodeOfFlowDay4_2.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay4_2.Player{CodeOfFlowDay4_2.IPlayerPublic}>(CodeOfFlowDay4_2.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDay4_2 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay4_2.Player{CodeOfFlowDay4_2.IPlayerPublic}>(CodeOfFlowDay4_2.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowDay4_2 from 0xCOF
    pub fun main(address: Address): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay4_2.Player{CodeOfFlowDay4_2.IPlayerPublic}>(CodeOfFlowDay4_2.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards()
    }
    `,
    getCardInfo: `
    import CodeOfFlowDay4_2 from 0xCOF
    pub fun main(): {UInt16: CodeOfFlowDay4_2.CardStruct} {
        return CodeOfFlowDay4_2.getCardInfo()
    }
    `,
    getMatchingLimits: `
    import CodeOfFlowDay4_2 from 0xCOF
    pub fun main(): [UFix64] {
        return CodeOfFlowDay4_2.getMatchingLimits()
    }
    `,
    getPlayersScore: `
    import CodeOfFlowDay4_2 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay4_2.Player{CodeOfFlowDay4_2.IPlayerPublic}>(CodeOfFlowDay4_2.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_players_score()
    }
    `,
}
