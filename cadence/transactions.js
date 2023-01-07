export default {
  setupNFTResourceForNFTClearingHouse: `
  import NFTClearingHouse from 0x9e447fb949c3f1b6
  import NonFungibleToken from 0x631e88ae7f1d7c20
  import MyNFT from 0x9e447fb949c3f1b6
  import FungibleToken from 0x9a0766d93b6608b7
  import FlowToken from 0x7e60df042a9c0868
  transaction (nickname: String, imagepath: String) {
    prepare(acct: AuthAccount) {
      // Step1
      acct.save(<- MyNFT.createEmptyCollection(), to: /storage/MyNFTCollection)

      // Step2
      acct.link<&MyNFT.Collection{NonFungibleToken.CollectionPublic}>(/public/MyNFTCollection, target: /storage/MyNFTCollection)

      // Step3
      acct.link<&MyNFT.Collection>(/private/MyNFTCollection, target: /storage/MyNFTCollection)

      // Step4
      let MyNFTCollection = acct.getCapability<&MyNFT.Collection>(/private/MyNFTCollection)
      let FlowTokenVault = acct.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
      acct.save(<- NFTClearingHouse.createSaleCollection(NFTCollectionCaps: MyNFTCollection, FlowTokenVault: FlowTokenVault), to: /storage/MySaleCollection)
      acct.link<&NFTClearingHouse.SaleCollection{NFTClearingHouse.SaleCollectionPublic}>(/public/MySaleCollection, target: /storage/MySaleCollection)

      // Step5
      let collection = acct.borrow<&MyNFT.Collection>(from: /storage/MyNFTCollection)
                          ?? panic("This collection does not exist here")
      let nft <- MyNFT.createToken(nickname: nickname, imagepath: imagepath, addr: acct.address)
      collection.deposit(token: <- nft)
    }
    execute {
      log("A user minted his/her first NFT onto their account")
    }
  }
  `
}