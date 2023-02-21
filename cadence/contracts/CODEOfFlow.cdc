pub contract CodeOfFlowDay1 {

  // Events
  pub event WaitingTheMatch(player_id: UInt32)
  pub event GameStart(first: UInt32, second: UInt32)
  pub event GameResult(first: UInt32, second: UInt32, winner: UInt32)

  // Paths
  pub let AdminStoragePath: StoragePath
  pub let PlayerStoragePath: StoragePath
  pub let PlayerPublicPath: PublicPath

  // Variants
  priv var totalPlayers: UInt32

  // Objects
  priv let cardInfo: {UInt16: CardStruct}
  priv let battleInfo: {UInt32: BattleStruct}
  priv var matchingLimits: [UFix64]
  priv var matchingPlayers: [UInt32]
  priv let onMatchList: {UInt32: UInt32}

  // [Struct] CardStruct
  pub struct CardStruct {
    pub let card_id: UInt16
    init(card_id: UInt16) {
      self.card_id = card_id
    }
  }

  // [Struct] BattleStruct
  pub struct BattleStruct {
    pub var turn: UInt8
    init() {
      self.turn = 1
    }
  }

  // [Interface] IPlayerPublic
  pub resource interface IPlayerPublic {
  }

  // [Interface] IPlayerPrivate
  pub resource interface IPlayerPrivate {
  }

  // [Resource] Player
  pub resource Player: IPlayerPublic, IPlayerPrivate {
    priv let player_id: UInt32
    priv let nickname: String
    priv let last10matchScore: [UInt8]
    priv var totalScore: String
    priv let deck: [UInt16]
    priv var onMatch: UInt32?
    priv var lastTimeBattled: UFix64?
    priv var lastTimeMatching: UFix64?

    pub fun matching_start() {
      pre {
        self.lastTimeMatching == nil || self.lastTimeMatching! >= getCurrentBlock().timestamp + 60.0 : "still matching."
      }
      var counter = 0
      var outdated = -1
      let current_time = getCurrentBlock().timestamp

      // Search where matching times are already past 60 seconds
      for time in CodeOfFlowDay1.matchingLimits {
        if outdated == -1 && current_time > time {
          outdated = counter
        }
        counter = counter + 1
      }

      // If there are some expired matching times
      if outdated > -1 {
        // Save only valid matchin times
        CodeOfFlowDay1.matchingLimits = CodeOfFlowDay1.matchingLimits.slice(from: 0, upTo: outdated)
        CodeOfFlowDay1.matchingPlayers = CodeOfFlowDay1.matchingPlayers.slice(from: 0, upTo: outdated)
      }

      if CodeOfFlowDay1.matchingLimits.length >= 1 {
        // Pick the opponent from still matching players.
        CodeOfFlowDay1.matchingLimits.removeLast()
        let opponent = CodeOfFlowDay1.matchingPlayers.removeLast()
        emit GameStart(first: opponent, second: self.player_id)
        self.onMatch = opponent
        self.lastTimeMatching = nil
      } else {
        // Put player_id in the matching list.
        self.lastTimeMatching = current_time
        CodeOfFlowDay1.matchingLimits.append(current_time + 60.0)
        CodeOfFlowDay1.matchingPlayers.append(self.player_id)
      }
    }

    init(nickname: String) {
      CodeOfFlowDay1.totalPlayers = CodeOfFlowDay1.totalPlayers + 1
      self.player_id = CodeOfFlowDay1.totalPlayers + 1
      self.nickname = nickname
      self.last10matchScore = []
      self.totalScore = ""
      self.deck = [14, 15, 16, 17, 18, 19, 20, 21, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9]
      self.onMatch = nil
      self.lastTimeBattled = nil
      self.lastTimeMatching = nil
    }
  }

  pub fun createPlayer(nickname: String): @CodeOfFlowDay1.Player {
    return <- create Player(nickname: nickname)
  }

  init () {
    self.AdminStoragePath = /storage/CodeOfFlowDay1Admin
    self.PlayerStoragePath = /storage/CodeOfFlowDay1Player
    self.PlayerPublicPath = /public/CodeOfFlowDay1Player
    self.totalPlayers = 0
    self.cardInfo = {}
    self.battleInfo = {}
    self.matchingLimits = []
    self.matchingPlayers = []
    self.onMatchList = {}
  }
}
 