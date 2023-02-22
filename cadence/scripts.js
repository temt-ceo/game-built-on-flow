export default {
    isRegistered: `
    import CodeOfFlowDay2_4 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay2_4.Player{CodeOfFlowDay2_4.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay2_4.Player{CodeOfFlowDay2_4.IPlayerPublic}>(CodeOfFlowDay2_4.PlayerPublicPath).borrow()
    }
    `,
    getCurrentStatus: `
    import CodeOfFlowDay2_4 from 0xCOF
    pub fun main(address: Address): AnyStruct {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay2_4.Player{CodeOfFlowDay2_4.IPlayerPublic}>(CodeOfFlowDay2_4.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_current_status()
    }
    `,
    getMariganCards: `
    import CodeOfFlowDay2_4 from 0xCOF
    pub fun main(address: Address): [[UInt16]] {
        let cap = getAccount(address).getCapability<&CodeOfFlowDay2_4.Player{CodeOfFlowDay2_4.IPlayerPublic}>(CodeOfFlowDay2_4.PlayerPublicPath).borrow()
          ?? panic("Doesn't have capability!")
        return cap.get_marigan_cards()
    }
    `,
    getCardInfo: `
    import CodeOfFlowDay2_4 from 0xCOF
    pub fun main(): {UInt16: CodeOfFlowDay2_4.CardStruct} {
        return CodeOfFlowDay2_4.getCardInfo()
    }
    `,
    getMatchingLimits: `
    import CodeOfFlowDay2_4 from 0xCOF
    pub fun main(): [UFix64] {
        return CodeOfFlowDay2_4.getMatchingLimits()
    }
    `,
}
