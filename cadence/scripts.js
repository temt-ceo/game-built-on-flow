export default {
    isRegistered: `
    import CodeOfFlowAlpha4 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowAlpha4.Player{CodeOfFlowAlpha4.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowAlpha4.Player{CodeOfFlowAlpha4.IPlayerPublic}>(CodeOfFlowAlpha4.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowAlpha4 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowAlpha4.Player{CodeOfFlowAlpha4.IPlayerPublic}>(CodeOfFlowAlpha4.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowAlpha4 from 0xCOF
    pub fun main(address: Address, player_id: UInt32): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowAlpha4.Player{CodeOfFlowAlpha4.IPlayerPublic}>(CodeOfFlowAlpha4.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards(player_id: player_id)
    }
    `,
    getCardInfo: `
    import CodeOfFlowAlpha4 from 0xCOF
    pub fun main(): {UInt16: CodeOfFlowAlpha4.CardStruct} {
        return CodeOfFlowAlpha4.getCardInfo()
    }
    `,
    getMatchingLimits: `
    import CodeOfFlowAlpha4 from 0xCOF
    pub fun main(): [UFix64] {
        return CodeOfFlowAlpha4.getMatchingLimits()
    }
    `,
    getPlayersScore: `
    import CodeOfFlowAlpha4 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowAlpha4.Player{CodeOfFlowAlpha4.IPlayerPublic}>(CodeOfFlowAlpha4.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_players_score()
    }
    `,
}
