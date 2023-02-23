export default {
    createPlayer: `
      import CodeOfFlowDay3_8 from 0xCOF

      transaction(nickname: String) {
        prepare(acct: AuthAccount) {
          // Step1
          acct.save(<- CodeOfFlowDay3_8.createPlayer(nickname: nickname), to: CodeOfFlowDay3_8.PlayerStoragePath)
          // Step2
          acct.link<&CodeOfFlowDay3_8.Player{CodeOfFlowDay3_8.IPlayerPublic}>(CodeOfFlowDay3_8.PlayerPublicPath, target: CodeOfFlowDay3_8.PlayerStoragePath)
          }
        execute {
          log("success")
        }
      }
    `,
    matchingStart: `
      import CodeOfFlowDay3_8 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay3_8.Player>(from: CodeOfFlowDay3_8.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.matching_start()
        }
        execute {
          log("success")
        }
      }
    `,
    gameStart: `
      import CodeOfFlowDay3_8 from 0xCOF

      transaction(drawed_cards: [UInt16]) {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay3_8.Player>(from: CodeOfFlowDay3_8.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.game_start(drawed_cards: drawed_cards)
        }
        execute {
          log("success")
        }
      }
    `,
    turnChange: `
      import CodeOfFlowDay3_8 from 0xCOF

      transaction(attacked_cards: {String: UInt16}, used_card: {String: UInt16}) {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay3_8.Player>(from: CodeOfFlowDay3_8.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.turn_change(attacked_cards: attacked_cards, used_card: used_card)
        }
        execute {
          log("success")
        }
      }
    `,
    claimWin: `
      import CodeOfFlowDay3_8 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay3_8.Player>(from: CodeOfFlowDay3_8.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.claimWin()
        }
        execute {
          log("success")
        }
      }
    `,
    surrendar: `
      import CodeOfFlowDay3_8 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay3_8.Player>(from: CodeOfFlowDay3_8.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.surrendar()
        }
        execute {
          log("success")
        }
      }
    `,
}