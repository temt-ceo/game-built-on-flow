export default {
    isRegistered: `
    import CodeOfFlowDayAlpha1 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDayAlpha1.Player{CodeOfFlowDayAlpha1.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDayAlpha1.Player{CodeOfFlowDayAlpha1.IPlayerPublic}>(CodeOfFlowDayAlpha1.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDayAlpha1 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDayAlpha1.Player{CodeOfFlowDayAlpha1.IPlayerPublic}>(CodeOfFlowDayAlpha1.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowDayAlpha1 from 0xCOF
    pub fun main(address: Address): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowDayAlpha1.Player{CodeOfFlowDayAlpha1.IPlayerPublic}>(CodeOfFlowDayAlpha1.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards()
    }
    `,
    getCardInfo: `
    import CodeOfFlowDayAlpha1 from 0xCOF
    pub fun main(): {UInt16: CodeOfFlowDayAlpha1.CardStruct} {
        return CodeOfFlowDayAlpha1.getCardInfo()
    }
    `,
    getMatchingLimits: `
    import CodeOfFlowDayAlpha1 from 0xCOF
    pub fun main(): [UFix64] {
        return CodeOfFlowDayAlpha1.getMatchingLimits()
    }
    `,
    getPlayersScore: `
    import CodeOfFlowDayAlpha1 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDayAlpha1.Player{CodeOfFlowDayAlpha1.IPlayerPublic}>(CodeOfFlowDayAlpha1.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_players_score()
    }
    `,
}
