pub contract CodeOfFlowDay1 {

  // Events
  pub event PlayerRegistered(player_id: UInt32)
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
  priv let playerList: {UInt32: String}

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
    pub let is_first: Bool
    pub let opponent: UInt32

    init(is_first: Bool, opponent: UInt32) {
      self.turn = 1
      self.is_first = is_first
      self.opponent = opponent
    }
  }

  // [Interface] IPlayerPublic
  pub resource interface IPlayerPublic {
    pub fun get_current_status(): AnyStruct
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


    pub fun get_current_status(): AnyStruct {
      if let info = CodeOfFlowDay1.battleInfo[self.player_id] {
        return info
      }
      return self.lastTimeMatching
    }

    pub fun matching_start() {
      pre {
        self.lastTimeMatching == nil || self.lastTimeMatching! <= getCurrentBlock().timestamp + 60.0 : "Still matching."
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
        let time = CodeOfFlowDay1.matchingLimits.removeLast()
        let opponent = CodeOfFlowDay1.matchingPlayers.removeLast()

        var is_first = false
        // Decides which is first
        if (CodeOfFlowDay1.matchingLimits.length % 2 == 1) {
          is_first = true
        }
        CodeOfFlowDay1.battleInfo[self.player_id] = BattleStruct(is_first: is_first, opponent: opponent)
        CodeOfFlowDay1.battleInfo[opponent] = BattleStruct(is_first: !is_first, opponent: self.player_id)

        emit GameStart(first: opponent, second: self.player_id)
        self.onMatch = opponent
        self.lastTimeMatching = nil
      } else {
        // Put player_id in the matching list.
        self.lastTimeMatching = current_time
        emit WaitingTheMatch(player_id: self.player_id)
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
      CodeOfFlowDay1.playerList[self.player_id] = nickname
      emit PlayerRegistered(player_id: self.player_id)
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
    self.playerList = {}
  }
}
 