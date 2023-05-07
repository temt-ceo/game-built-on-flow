const fs = require('fs');
const fcl = require("@onflow/fcl");
const t = require("@onflow/types");
const { SecretsManagerClient, GetSecretValueCommand } = require("@aws-sdk/client-secrets-manager");
const { SHA3 } = require("sha3");

const FlowTransactions = {
  matchingStart: `
    import CodeOfFlowAlpha4 from 0x9e447fb949c3f1b6

    transaction(player_id: UInt32) {
      prepare(signer: AuthAccount) {
        let admin = signer.borrow<&CodeOfFlowAlpha4.Admin>(from: CodeOfFlowAlpha4.AdminStoragePath)
            ?? panic("Could not borrow reference to the Administrator Resource.")
        admin.matching_start(player_id: player_id)
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

  let player_id = input.playerId ? parseInt(input.playerId) : 0
  let message = ""
  var KEY_ID_IT = 1
  if (fs.existsSync('/tmp/sequence.txt')) {
    KEY_ID_IT = parseInt(fs.readFileSync('/tmp/sequence.txt', {encoding: 'utf8'}));
  }
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
      const PRIVATE_KEY = JSON.parse(response.SecretString)?.SmartContractPK;
      const ADDRESS = "0x9e447fb949c3f1b6";
      const KEY_ID = 0;
      const CONTRACT_NAME = "CodeOfFlowAlpha4";
      
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
      async function authorizationFunctionProposer(account) {
        KEY_ID_IT = !KEY_ID_IT || KEY_ID_IT > 5 ? 1 : KEY_ID_IT + 1
        fs.writeFileSync('/tmp/sequence.txt', KEY_ID_IT.toString());
        return {
          ...account,
          tempId: `${ADDRESS}-${KEY_ID_IT}`,
          addr: fcl.sansPrefix(ADDRESS),
          keyId: Number(KEY_ID_IT),
          signingFunction: async (signable) => {
            return {
              addr: fcl.withPrefix(ADDRESS),
              keyId: Number(KEY_ID_IT),
              signature: sign(signable.message)
            }
          }
        }
      }
      const transactionId = await fcl.mutate({
        cadence: FlowTransactions.matchingStart,
        args: (arg, t) => [
          arg(player_id, t.UInt32)
        ],
        proposer: authorizationFunctionProposer,
        payer: authorizationFunction,
        authorizations: [authorizationFunction],
        limit: 999
      })
      console.log(`TransactionId: ${transactionId}`)
      message = `Transaction is On Going. TransactionId: ${transactionId}`
      fcl.tx(transactionId).subscribe(res => {
        console.log(res);
      })
    }

    return {
      id: new Date().getTime(),
      type: input.type || "",
      message: KEY_ID_IT + " : " + message,
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
