export default {
    setupNFTResourceForNFTClearingHouse: `
    import NFTClearingHousev2 from 0x9e447fb949c3f1b6
    import NonFungibleToken from 0x631e88ae7f1d7c20
    import MyNFTv2 from 0x9e447fb949c3f1b6
    import FungibleToken from 0x9a0766d93b6608b7
    import FlowToken from 0x7e60df042a9c0868
    transaction (nickname: String, imagepath: String) {
      prepare(acct: AuthAccount) {
        // Step1
        acct.save(<- MyNFTv2.createEmptyCollection(), to: /storage/MyNFTv2Collection)

        // Step2
        acct.link<&MyNFTv2.Collection{NonFungibleToken.CollectionPublic}>(/public/MyNFTv2Collection, target: /storage/MyNFTv2Collection)

        // Step3
        acct.link<&MyNFTv2.Collection>(/private/MyNFTv2Collection, target: /storage/MyNFTv2Collection)

        // Step4
        let MyNFTv2Collection = acct.getCapability<&MyNFTv2.Collection>(/private/MyNFTv2Collection)
        let FlowTokenVault = acct.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
        acct.save(<- NFTClearingHousev2.createSaleCollection(NFTCollectionCaps: MyNFTv2Collection, FlowTokenVault: FlowTokenVault), to: /storage/MySaleCollectionv2)
        acct.link<&NFTClearingHousev2.SaleCollection{NFTClearingHousev2.SaleCollectionPublic}>(/public/MySaleCollectionv2, target: /storage/MySaleCollectionv2)

        // Step5
        let collection = acct.borrow<&MyNFTv2.Collection>(from: /storage/MyNFTv2Collection)
                            ?? panic("This collection does not exist here")
        let nft <- MyNFTv2.createToken(nickname: nickname, imagepath: imagepath, addr: acct.address)
        collection.deposit(token: <- nft)
      }
      execute {
        log("A user minted his/her first NFT onto their account")
      }
    }
    `,
    listForSaleTx: `
    import NFTClearingHousev2 from 0x9e447fb949c3f1b6
    transaction(nftId: UInt64, price: UFix64) {
        prepare(acct: AuthAccount) {
            let saleCollection = acct.borrow<&NFTClearingHousev2.SaleCollection>(from: /storage/MySaleCollectionv2)
                                    ?? panic("This SaleCollection does not exist")
            saleCollection.listForSale(id: nftId, price: price)
        }
        execute {
            log("A user listed an NFT for Sale")
        }
    }
    `
}