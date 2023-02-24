export default {
    createPlayer: `
      import CodeOfFlowDay4_2 from 0xCOF

      transaction(nickname: String) {
        prepare(acct: AuthAccount) {
          // Step1
          acct.save(<- CodeOfFlowDay4_2.createPlayer(nickname: nickname), to: CodeOfFlowDay4_2.PlayerStoragePath)
          // Step2
          acct.link<&CodeOfFlowDay4_2.Player{CodeOfFlowDay4_2.IPlayerPublic}>(CodeOfFlowDay4_2.PlayerPublicPath, target: CodeOfFlowDay4_2.PlayerStoragePath)
          }
        execute {
          log("success")
        }
      }
    `,
    matchingStart: `
      import CodeOfFlowDay4_2 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay4_2.Player>(from: CodeOfFlowDay4_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.matching_start()
        }
        execute {
          log("success")
        }
      }
    `,
    gameStart: `
      import CodeOfFlowDay4_2 from 0xCOF

      transaction(drawed_cards: [UInt16]) {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay4_2.Player>(from: CodeOfFlowDay4_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.game_start(drawed_cards: drawed_cards)
        }
        execute {
          log("success")
        }
      }
    `,
    turnChange: `
      import CodeOfFlowDay4_2 from 0xCOF

      transaction(attacked_cards: [UInt8], enemy_skill_target: {UInt8: UInt8}, trigger_cards: {UInt8: UInt16?}, used_intercept_positions: {UInt8: [UInt8]}) {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay4_2.Player>(from: CodeOfFlowDay4_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.turn_change(attacked_cards: attacked_cards, enemy_skill_target: enemy_skill_target, trigger_cards: trigger_cards, used_intercept_positions: used_intercept_positions)
        }
        execute {
          log("success")
        }
      }
    `,
    putCardOnField: `
      import CodeOfFlowDay4_2 from 0xCOF

      transaction(unit_card: {UInt8: UInt16}, enemy_skill_target: {UInt8: UInt8}, trigger_cards: {UInt8: UInt16?}, used_intercept_positions: [UInt8]) {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay4_2.Player>(from: CodeOfFlowDay4_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.put_card_on_the_field(unit_card: unit_card, enemy_skill_target: enemy_skill_target, trigger_cards: trigger_cards, used_intercept_positions: used_intercept_positions)
        }
        execute {
          log("success")
        }
      }
    `,
    claimWin: `
      import CodeOfFlowDay4_2 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay4_2.Player>(from: CodeOfFlowDay4_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.claimWin()
        }
        execute {
          log("success")
        }
      }
    `,
    surrendar: `
      import CodeOfFlowDay4_2 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay4_2.Player>(from: CodeOfFlowDay4_2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.surrendar()
        }
        execute {
          log("success")
        }
      }
    `,
}