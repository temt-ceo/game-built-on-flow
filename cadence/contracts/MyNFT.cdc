   import NonFungibleToken from 0x631e88ae7f1d7c20
   pub contract MyNFT: NonFungibleToken {

     pub var totalSupply: UInt64

     pub event ContractInitialized()
     pub event Withdraw(id: UInt64, from: Address?)
     pub event Deposit(id: UInt64, to: Address?)


     pub resource NFT: NonFungibleToken.INFT {
       pub let id: UInt64
       init () {
         self.id = MyNFT.totalSupply
         MyNFT.totalSupply = MyNFT.totalSupply + 1
       }
     }


     pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {

       pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

       pub fun deposit(token: @NonFungibleToken.NFT) {
         let downCastedToken <- token as! @MyNFT.NFT
         emit Deposit(id: downCastedToken.id, to: self.owner?.address)
         self.ownedNFTs[downCastedToken.id] <-! downCastedToken
       }

       pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
         let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("This is not exist")
         emit Withdraw(id: token.id, from: self.owner?.address)
         return <- token
       }

       pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
         pre {
           self.ownedNFTs[id] != nil: "NFT does not exist in the collection!"
         }
         return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
       }

       pub fun getIDs(): [UInt64] {
         return self.ownedNFTs.keys
       }


       init () {
         self.ownedNFTs <- {}
       }
       destroy () {
         destroy self.ownedNFTs
       }
     }

     pub fun createToken(): @MyNFT.NFT {
       return <- create NFT()
     }

     pub fun createEmptyCollection(): @Collection {
      return <- create Collection()
     }


     init () {
       self.totalSupply = 0
     }
   }