export default {
    createPlayer: `
      import CodeOfFlowDay3_2 from 0xCOF

      transaction(nickname: String) {
        prepare(acct: AuthAccount) {
          // Step1
          acct.save(<- CodeOfFlowDay3_2.createPlayer(nickname: nickname), to: CodeOfFlowDay3_2.PlayerStoragePath)
          // Step2
          acct.link<&CodeOfFlowDay3_2.Player{CodeOfFlowDay3_2.IPlayerPublic}>(CodeOfFlowDay3_2.PlayerPublicPath, target: CodeOfFlowDay3_2.PlayerStoragePath)
          }
        execute {
          log("success")
        }
      }
    `,
    matchingStart: `
      import CodeOfFlowDay3_2 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay3_2.Player>(from: CodeOfFlowDay3_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.matching_start()
        }
        execute {
          log("success")
        }
      }
    `,
    gameStart: `
      import CodeOfFlowDay3_2 from 0xCOF

      transaction(drawed_cards: [UInt16]) {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay3_2.Player>(from: CodeOfFlowDay3_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.game_start(drawed_cards: drawed_cards)
        }
        execute {
          log("success")
        }
      }
    `,
    turnChange: `
      import CodeOfFlowDay3_2 from 0xCOF

      transaction(attacked_cards: {UInt8: UInt16}, used_card: {UInt8: UInt16}) {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay3_2.Player>(from: CodeOfFlowDay3_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.turn_change(attacked_cards: attacked_cards, used_card: used_card)
        }
        execute {
          log("success")
        }
      }
    `,
}