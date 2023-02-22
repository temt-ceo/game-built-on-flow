export default {
    createPlayer: `
      import CodeOfFlowDay2 from 0xCOF

      transaction(nickname: String) {
        prepare(acct: AuthAccount) {
          // Step1
          acct.save(<- CodeOfFlowDay2.createPlayer(nickname: nickname), to: CodeOfFlowDay2.PlayerStoragePath)
          // Step2
          acct.link<&CodeOfFlowDay2.Player{CodeOfFlowDay2.IPlayerPublic}>(CodeOfFlowDay2.PlayerPublicPath, target: CodeOfFlowDay2.PlayerStoragePath)
          }
        execute {
          log("success")
        }
      }
    `,
    matchingStart: `
      import CodeOfFlowDay2 from 0xCOF

      transaction() {
        prepare(acct: AuthAccount) {
          let gamePlayer = acct.borrow<&CodeOfFlowDay2.Player>(from: CodeOfFlowDay2.PlayerStoragePath)
            ?? panic("This Player has not registered")
          gamePlayer.matching_start()
        }
        execute {
          log("success")
        }
      }
    `,
}