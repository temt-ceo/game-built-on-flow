export default {
    isPlayerHasRegistered: `
    import CodeOfFlowDay1 from 0xCOF
    pub fun main(address: Address): &CodeOfFlowDay1.Player{CodeOfFlowDay1.IPlayerPublic}? {
        return getAccount(address).getCapability<&CodeOfFlowDay1.Player{CodeOfFlowDay1.IPlayerPublic}>(CodeOfFlowDay1.PlayerPublicPath).borrow()
    }
    `,
    get1stMints: `
    import MyNFTv2 from 0x9e447fb949c3f1b6
    pub fun main(): {Address: [MyNFTv2.NFT1stStruct]} {
        return MyNFTv2.nft1stInfos
    }
    `,
    getOnsaleNFTs: `
    import MyNFTv2 from 0x9e447fb949c3f1b6
    import NonFungibleToken from 0x631e88ae7f1d7c20
    import NFTClearingHousev2 from 0x9e447fb949c3f1b6

    pub fun main(account: Address): {UInt64: UFix64} {

        let saleCollectionCap = getAccount(account).getCapability(/public/MySaleCollectionv2)
                    .borrow<&NFTClearingHousev2.SaleCollection{NFTClearingHousev2.SaleCollectionPublic}>()
                            ?? panic("Could not borrow the user's SaleCollection")

        let saleIDs = saleCollectionCap.getIDs()

        let returnVals: {UInt64: UFix64} = {}
        for saleID in saleIDs {
            let price = saleCollectionCap.getPrice(id: saleID)
            returnVals.insert(key: saleID, price)
        }
        return returnVals
    }
    `
}
