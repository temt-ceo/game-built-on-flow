  import NonFungibleToken from 0x631e88ae7f1d7c20
  import MyNFT from ./MyNFT
  import FungibleToken from 0x9a0766d93b6608b7
  import FlowToken from 0x7e60df042a9c0868

  pub contract NFTClearingHouse {
    pub resource interface SaleCollectionPublic {

        pub fun getIDs(): [UInt64]

        pub fun getPrice(id: UInt64): UFix64

        pub fun purchase(id: UInt64,
             recipientCollection: &MyNFT.Collection{NonFungibleToken.CollectionPublic}, payment: @FlowToken.Vault)
    }

    pub resource SaleCollection: SaleCollectionPublic {

    
        pub var forSale: {UInt64: UFix64}

        pub let NFTCollectionCaps: Capability<&MyNFT.Collection>

        pub let FlowTokenVault:  Capability<&FlowToken.Vault{FungibleToken.Receiver}>

        pub fun listForSale(id: UInt64, price: UFix64) {
           pre{
              price > 0.0: "doesn't make sense to list a token for less than 0"
           }
           self.forSale[id] = price
        }

        pub fun unlistFromSale(id: UInt64, price: UFix64) {
           self.forSale.remove(key: id)
        }

        pub fun purchase(id: UInt64, recipientCollection: &MyNFT.Collection{NonFungibleToken.CollectionPublic}, payment: @FlowToken.Vault) {

           pre{
              payment.balance == self.forSale[id]: 
          "This payment is not equal to the price of the NFT"
           }

           recipientCollection.deposit(token: <-
             self.NFTCollectionCaps.borrow()!.withdraw(withdrawID: id))

           self.FlowTokenVault.borrow()!.deposit(from: <- payment)
        }

        pub fun getIDs(): [UInt64] {
           return self.forSale.keys
        }


        pub fun getPrice(id: UInt64): UFix64 {
           return self.forSale[id]!
        }

        init (_NFTCollectionCaps: Capability<&MyNFT.Collection>, _FlowTokenVault: Capability<&FlowToken.Vault{FungibleToken.Receiver}>) {

           self.forSale = {}
           self.NFTCollectionCaps = _NFTCollectionCaps
           self.FlowTokenVault = _FlowTokenVault
        }
     }
     pub fun createSaleCollection(NFTCollectionCaps: Capability<&MyNFT.Collection>, FlowTokenVault: Capability<&FlowToken.Vault{FungibleToken.Receiver}>): @SaleCollection {

        return <- create SaleCollection(_NFTCollectionCaps: NFTCollectionCaps, _FlowTokenVault: FlowTokenVault)
     }

     init () {
     }
  }
