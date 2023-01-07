export default {
    get1stMints: `
    import MyNFT from 0x9e447fb949c3f1b6
    pub fun main(): {Address: [MyNFT.NFT1stStruct]} {
        return MyNFT.nft1stInfos
    }
    `
}
