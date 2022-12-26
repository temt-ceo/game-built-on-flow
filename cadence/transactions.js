
export default {
    // import NonFungibleToken from 0x631e88ae7f1d7c20
    // import MyNFT from 0x863184a6f20fab5c

    // transaction() {

    //   prepare(acct: AuthAccount) {
    //     let collection = acct.borrow<&MyNFT.Collection>(from: /storage/MyNFTCollection) 
    //       ?? panic("The Collection does not exist.")

    //     let nft <- MyNFT.createToken()

    //     collection.deposit(token: <- nft)


    //   }

    //   execute {
    //   }
    // }
    createSaleCollection: `
import NonFungibleToken from 0x01
import MyNFT from 0x02
import FungibleToken from 0x03
import FlowToken from 0x04
import NFTClearingHouse from 0x05

transaction {

   prepare(acct: AuthAccount) {
      let MyNFTCollection = acct.getCapability<&MyNFT.Collection>
          (/public/MyNFTCollection)

      let FlowTokenVault = acct.getCapability<&FlowToken.Vault{
           FungibleToken.Receiver}>(/public/flowTokenReceiver)

      acct.save(<- NFTClearingHouse.createSaleCollection(
           NFTCollectionCaps: MyNFTCollection,
        FlowTokenVault: FlowTokenVault), to: /storage/MySaleCollection)

      acct.link<&NFTClearingHouse.SaleCollection{
          NFTClearingHouse.SaleCollectionPublic}>
          (/public/MySaleCollection, target: /storage/MySaleCollection)
   }


   init () {
   }
}
  `
}

