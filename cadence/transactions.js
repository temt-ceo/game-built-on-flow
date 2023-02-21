export default {
    createPlayer: `
      import CodeOfFlowDay1 from 0xCOF

      transaction(nickname: String) {
        prepare(acct: AuthAccount) {
          // Step1
          acct.save(<- CodeOfFlowDay1.createPlayer(nickname: nickname), to: CodeOfFlowDay1.PlayerStoragePath)
          // Step2
          acct.link<&CodeOfFlowDay1.Player{CodeOfFlowDay1.IPlayerPublic}>(CodeOfFlowDay1.PlayerPublicPath, target: CodeOfFlowDay1.PlayerStoragePath)
          }
        execute {
          log("success")
        }
      }
    `,
    matchingStart: `
      import CodeOfFlowDay1 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay1.Player>(from: CodeOfFlowDay1.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.matching_start()
        }
        execute {
          log("success")
        }
      }
    `,
}