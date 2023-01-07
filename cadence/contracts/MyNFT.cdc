   import NonFungibleToken from 0x631e88ae7f1d7c20

   pub contract MyNFTv2: NonFungibleToken {

     pub var totalSupply: UInt64

     pub event ContractInitialized()
     pub event Withdraw(id: UInt64, from: Address?)
     pub event Deposit(id: UInt64, to: Address?)

     pub let nft1stInfos: {Address: [NFT1stStruct]}

     pub struct NFT1stStruct {
       pub let nickname: String
       pub let imagepath: String
       init(nickname: String, imagepath: String) {
         self.nickname = nickname
         self.imagepath = imagepath
       }
     }

     pub resource NFT: NonFungibleToken.INFT {
       pub let id: UInt64
       init (nickname: String, imagepath: String, addr: Address) {
         self.id = MyNFTv2.totalSupply
         MyNFTv2.totalSupply = MyNFTv2.totalSupply + 1
         let nft1stInfo = NFT1stStruct(nickname: nickname, imagepath: imagepath)
         MyNFTv2.nft1stInfos[addr] = [nft1stInfo]
       }
     }


     pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {

       pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

       pub fun deposit(token: @NonFungibleToken.NFT) {
         let downCastedToken <- token as! @MyNFTv2.NFT
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

     pub fun createToken(nickname: String, imagepath: String, addr: Address): @MyNFTv2.NFT {
       return <- create NFT(nickname: nickname, imagepath: imagepath, addr: addr)
     }

     pub fun createEmptyCollection(): @Collection {
      return <- create Collection()
     }


     init () {
       self.totalSupply = 0
       self.nft1stInfos = {}
     }
   }
