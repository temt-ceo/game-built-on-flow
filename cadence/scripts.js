export default {
    isRegistered: `
    import CodeOfFlowDay6 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay6.Player{CodeOfFlowDay6.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay6.Player{CodeOfFlowDay6.IPlayerPublic}>(CodeOfFlowDay6.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDay6 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay6.Player{CodeOfFlowDay6.IPlayerPublic}>(CodeOfFlowDay6.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowDay6 from 0xCOF
    pub fun main(address: Address): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay6.Player{CodeOfFlowDay6.IPlayerPublic}>(CodeOfFlowDay6.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards()
    }
    `,
    getCardInfo: `
    import CodeOfFlowDay6 from 0xCOF
    pub fun main(): {UInt16: CodeOfFlowDay6.CardStruct} {
        return CodeOfFlowDay6.getCardInfo()
    }
    `,
    getMatchingLimits: `
    import CodeOfFlowDay6 from 0xCOF
    pub fun main(): [UFix64] {
        return CodeOfFlowDay6.getMatchingLimits()
    }
    `,
    getPlayersScore: `
    import CodeOfFlowDay6 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay6.Player{CodeOfFlowDay6.IPlayerPublic}>(CodeOfFlowDay6.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_players_score()
    }
    `,
}
