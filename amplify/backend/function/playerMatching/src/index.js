const fcl = require("@onflow/fcl");
const t = require("@onflow/types");
const { SecretsManagerClient, GetSecretValueCommand } = require("@aws-sdk/client-secrets-manager");
const { SHA3 } = require("sha3");

const FlowTransactions = {
  matchingStart: `
    import CodeOfFlowDayAlpha1 from 0x9e447fb949c3f1b6

    transaction() {
      prepare(acct: AuthAccount) {
        let gamePlayer = acct.borrow<&CodeOfFlowDayAlpha1.Player>(from: CodeOfFlowDayAlpha1.PlayerStoragePath)
          ?? panic("This Player has not registered")
        gamePlayer.matching_start()
      }
      execute {
        log("success")
      }
    }
  `
}

exports.handler = async function (event) {
  console.log("Event", JSON.stringify(event, 3))
  const input = event.arguments?.input || {};

  let player_id = input.player_id || ""
  let message = ""
  try {
    if (input.type === "player_matching") {

      const client = new SecretsManagerClient({region: "ap-northeast-1"});
      const response = await client.send(new GetSecretValueCommand({
        SecretId: "SmartContractPK",
        VersionStage: "AWSCURRENT",
      }));
      
      const EC = require('elliptic').ec;
      
      const ec = new EC('p256');    
      fcl.config()
        .put("accessNode.api", "https://rest-testnet.onflow.org")
      
      // CHANGE THESE THINGS FOR YOU
      const PRIVATE_KEY = response.SecretString;
      const ADDRESS = "0x9e447fb949c3f1b6";
      const KEY_ID = 0;
      const CONTRACT_NAME = "CodeOfFlowDayAlpha1";
      
      const sign = (message) => {
        const key = ec.keyFromPrivate(Buffer.from(PRIVATE_KEY, "hex"))
        const sig = key.sign(hash(message)) // hashMsgHex -> hash
        const n = 32
        const r = sig.r.toArrayLike(Buffer, "be", n)
        const s = sig.s.toArrayLike(Buffer, "be", n)
        return Buffer.concat([r, s]).toString("hex")
      }
      const hash = (message) => {
        const sha = new SHA3(256);
        sha.update(Buffer.from(message, "hex"));
        return sha.digest();
      }
      
      async function authorizationFunction(account) {
        return {
          ...account,
          tempId: `${ADDRESS}-${KEY_ID}`,
          addr: fcl.sansPrefix(ADDRESS),
          keyId: Number(KEY_ID),
          signingFunction: async (signable) => {
            return {
              addr: fcl.withPrefix(ADDRESS),
              keyId: Number(KEY_ID),
              signature: sign(signable.message)
            }
          }
        }
      }
      
      const transactionId = await fcl.mutate({
        cadence: FlowTransactions.matchingStart,
        args: (arg, t) => [
        ],
        proposer: authorizationFunction,
        payer: authorizationFunction,
        authorizations: [fcl.authorizationFunction],
        limit: 999
      })
      console.log(`TransactionId: ${transactionId}`)
      message = 'Transaction is On Going'
      fcl.tx(transactionId).subscribe(res => {
        console.log(res);
      })
    }

    return {
      id: new Date().getTime(),
      type: input.type || "",
      message: message,
      playerId: player_id,
      createdAt: new Date(),
      updatedAt: new Date()
    };
  } catch (error) {
    return {
      id: new Date().getTime(),
      type: input.type || "",
      message: error.toString(),
      playerId: player_id,
      createdAt: new Date(),
      updatedAt: new Date()
    };
  }
};
