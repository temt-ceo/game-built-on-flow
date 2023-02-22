export default {
    createPlayer: `
      import CodeOfFlowDay2_4 from 0xCOF

      transaction(nickname: String) {
        prepare(acct: AuthAccount) {
          // Step1
          acct.save(<- CodeOfFlowDay2_4.createPlayer(nickname: nickname), to: CodeOfFlowDay2_4.PlayerStoragePath)
          // Step2
          acct.link<&CodeOfFlowDay2_4.Player{CodeOfFlowDay2_4.IPlayerPublic}>(CodeOfFlowDay2_4.PlayerPublicPath, target: CodeOfFlowDay2_4.PlayerStoragePath)
          }
        execute {
          log("success")
        }
      }
    `,
    matchingStart: `
      import CodeOfFlowDay2_4 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay2_4.Player>(from: CodeOfFlowDay2_4.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.matching_start()
        }
        execute {
          log("success")
        }
      }
    `,
    gameStart: `
      import CodeOfFlowDay2_4 from 0xCOF

      transaction(drawed_cards: [UInt16]) {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay2_4.Player>(from: CodeOfFlowDay2_4.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.game_start(drawed_cards: drawed_cards)
        }
        execute {
          log("success")
        }
      }
    `,
}