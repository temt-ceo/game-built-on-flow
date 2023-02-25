pub contract CodeOfFlowDay5_4 {

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
  priv let playerList: {UInt32: ScoreStruct}

  // [Struct] CardStruct
  pub struct CardStruct {
    pub let card_id: UInt16
    pub let name: String
    pub let bp: UInt32
    pub let cost: UInt8
    pub let type: UInt8
    pub let category: UInt8
    pub let skill: Skill
    init(card_id: UInt16, name: String, bp: UInt32, cost: UInt8, type: UInt8, category: UInt8, skill: Skill) {
      self.card_id = card_id
      self.name = name
      self.bp = bp
      self.cost = cost
      self.type = type
      self.category = category
      self.skill = skill
    }
  }

  // [Struct] Skill
  pub struct Skill {
    pub let description: String
    pub let trigger_1: UInt8
    pub let trigger_2: UInt8
    pub let trigger_3: UInt8
    pub let trigger_4: UInt8
    pub let ask_1: UInt8
    pub let ask_2: UInt8
    pub let ask_3: UInt8
    pub let ask_4: UInt8
    pub let type_1: UInt8
    pub let type_2: UInt8
    pub let type_3: UInt8
    pub let type_4: UInt8
    pub let amount_1: UInt32
    pub let amount_2: UInt32
    pub let amount_3: UInt32
    pub let amount_4: UInt32
    pub let nestedSkill_1: Skill?
    pub let nestedSkill_2: Skill?
    pub let nestedSkill_3: Skill?
    pub let nestedSkill_4: Skill?
    init(description: String, triggers: [UInt8], asks: [UInt8], types: [UInt8], amounts: [UInt32], skills: [Skill]) {
      self.description = description
      self.trigger_1 = triggers[0]
      self.ask_1 = asks[0]
      self.type_1 = types[0]
      self.amount_1 = amounts[0]
      if triggers.length >= 2 {
        self.trigger_2 = triggers[1]
        self.ask_2 = asks[1]
        self.type_2 = types[1]
        self.amount_2 = amounts[1]
      } else {
        self.trigger_2 = 0
        self.ask_2 = 0
        self.type_2 = 0
        self.amount_2 = 0
      }
      if triggers.length >= 3 {
        self.trigger_3 = triggers[2]
        self.ask_3 = asks[2]
        self.type_3 = types[2]
        self.amount_3 = amounts[2]
      } else {
        self.trigger_3 = 0
        self.ask_3 = 0
        self.type_3 = 0
        self.amount_3 = 0
      }
      if triggers.length >= 4 {
        self.trigger_4 = triggers[3]
        self.ask_4 = asks[3]
        self.type_4 = types[3]
        self.amount_4 = amounts[3]
      } else {
        self.trigger_4 = 0
        self.ask_4 = 0
        self.type_4 = 0
        self.amount_4 = 0
      }
      if (skills.length >= 1) {
        self.nestedSkill_1 = skills[0]
      } else {
        self.nestedSkill_1 = nil
      }
      self.nestedSkill_2 = nil
      self.nestedSkill_3 = nil
      self.nestedSkill_4 = nil
    }
  }

  // [Struct] BattleStruct
  pub struct BattleStruct {
    pub(set) var turn: UInt8
    pub(set) var is_first_turn: Bool
    pub let is_first: Bool
    pub let opponent: UInt32
    pub let matched_time: UFix64
    pub(set) var game_started: Bool
    pub(set) var last_time_turnend: UFix64?
    pub(set) var opponent_life: UInt8
    pub(set) var opponent_cp: UInt8
    pub(set) var opponent_field_unit: {UInt8: UInt16}
    pub(set) var opponent_field_unit_action: {UInt8: UInt8}
    pub(set) var opponent_trigger_cards: Int
    pub(set) var opponent_remain_deck: Int
    pub(set) var opponent_hand: Int
    pub(set) var your_life: UInt8
    pub(set) var your_cp: UInt8
    pub(set) var your_field_unit: {UInt8: UInt16}
    pub(set) var your_field_unit_action: {UInt8: UInt8}
    pub(set) var your_trigger_cards: {UInt8: UInt16}
    pub(set) var your_remain_deck: [UInt16]
    pub(set) var your_hand: {UInt8: UInt16}
    pub(set) var card_draw_in_this_turn: Bool
    pub(set) var enemy_attacking_cards: [AttackStruct]

    init(is_first: Bool, opponent: UInt32, matched_time: UFix64) {
      self.turn = 1
      self.is_first_turn = true
      self.is_first = is_first
      self.opponent = opponent
      self.matched_time = matched_time
      self.game_started = false
      self.last_time_turnend = nil
      self.opponent_life = 7
      self.opponent_cp = 2
      self.opponent_field_unit = {}
      self.opponent_field_unit_action = {}
      self.opponent_trigger_cards = 0
      self.opponent_remain_deck = 30
      self.opponent_hand = 0
      self.your_life = 7
      self.your_cp = 2
      self.your_field_unit = {}
      self.your_field_unit_action = {}
      self.your_trigger_cards = {}
      self.your_remain_deck = []
      self.your_hand = {}
      self.enemy_attacking_cards = []
      self.card_draw_in_this_turn = false
    }
  }

  // [Struct] AttackStruct
  pub struct AttackStruct {
    pub let card_id: UInt16
    pub let bp: UInt32
    pub let damage: UInt16
    pub let damage_to: UInt8
    pub let used_trigger_cards: [UInt16]

    init(card_id: UInt16, bp: UInt32, damage: UInt16, damage_to: UInt8, used_trigger_cards: [UInt16]) {
      self.card_id = card_id
      self.bp = bp
      self.damage = damage
      self.damage_to = damage_to
      self.used_trigger_cards = used_trigger_cards
    }
  }

  // [Struct] ScoreStruct
  pub struct ScoreStruct {
    pub let player_name: String
    pub(set) var score: [{UFix64: UInt8}]

    init(player_name: String) {
      self.player_name = player_name
      self.score = []
    }
  }

  // [Interface] IPlayerPublic
  pub resource interface IPlayerPublic {
    pub fun get_current_status(): AnyStruct
    pub fun get_marigan_cards(): [[UInt16]]
    pub fun get_players_score(): [ScoreStruct]
  }

  // [Interface] IPlayerPrivate
  pub resource interface IPlayerPrivate {
  }

  // [Resource] Player
  pub resource Player: IPlayerPublic, IPlayerPrivate {
    priv let player_id: UInt32
    priv let nickname: String
    priv var marigan_cards: [[UInt8]]
    priv let deck: [UInt16]
    priv var lastTimeMatching: UFix64?

    pub fun get_marigan_cards(): [[UInt16]] {
      let ret_arr = [
        [self.deck[self.marigan_cards[0][0]], self.deck[self.marigan_cards[0][1]], self.deck[self.marigan_cards[0][2]], self.deck[self.marigan_cards[0][3]]],
        [self.deck[self.marigan_cards[1][0]], self.deck[self.marigan_cards[1][1]], self.deck[self.marigan_cards[1][2]], self.deck[self.marigan_cards[1][3]]],
        [self.deck[self.marigan_cards[2][0]], self.deck[self.marigan_cards[2][1]], self.deck[self.marigan_cards[2][2]], self.deck[self.marigan_cards[2][3]]],
        [self.deck[self.marigan_cards[3][0]], self.deck[self.marigan_cards[3][1]], self.deck[self.marigan_cards[3][2]], self.deck[self.marigan_cards[3][3]]],
        [self.deck[self.marigan_cards[4][0]], self.deck[self.marigan_cards[4][1]], self.deck[self.marigan_cards[4][2]], self.deck[self.marigan_cards[4][3]]]
      ]

      return ret_arr
    }

    pub fun get_players_score(): [ScoreStruct] {
      let retArr: [ScoreStruct] = []
      retArr.append(CodeOfFlowDay5_4.playerList[self.player_id]!)
      if let info = CodeOfFlowDay5_4.battleInfo[self.player_id] {
        let opponent = info.opponent
        retArr.append(CodeOfFlowDay5_4.playerList[opponent]!)
      }
      return retArr
    }

    pub fun get_current_status(): AnyStruct {
      if let info = CodeOfFlowDay5_4.battleInfo[self.player_id] {
        return info
      }
      return self.lastTimeMatching
    }

    pub fun matching_start() {
      pre {
        self.lastTimeMatching == nil || self.lastTimeMatching! + 60.0 <= getCurrentBlock().timestamp : "Still matching."
      }
      var counter = 0
      var outdated = -1
      let current_time = getCurrentBlock().timestamp
      self.lastTimeMatching = current_time

      // Search where matching times are already past 60 seconds
      for time in CodeOfFlowDay5_4.matchingLimits {
        if outdated == -1 && current_time > time + 60.0 {
          outdated = counter
        }
        counter = counter + 1
      }

      // If there are some expired matching times
      if outdated > -1 {
        // Save only valid matchin times
        if (outdated == 0) {
          CodeOfFlowDay5_4.matchingLimits = []
          CodeOfFlowDay5_4.matchingPlayers = []
        } else {
          CodeOfFlowDay5_4.matchingLimits = CodeOfFlowDay5_4.matchingLimits.slice(from: 0, upTo: outdated)
          CodeOfFlowDay5_4.matchingPlayers = CodeOfFlowDay5_4.matchingPlayers.slice(from: 0, upTo: outdated)
        }
      }

      emit WaitingTheMatch(player_id: self.player_id)
      if CodeOfFlowDay5_4.matchingLimits.length >= 1 {
        // Pick the opponent from still matching players.
        let time = CodeOfFlowDay5_4.matchingLimits.removeLast()
        let opponent = CodeOfFlowDay5_4.matchingPlayers.removeLast()

        var is_first = false
        // Decides which is first
        if (CodeOfFlowDay5_4.matchingLimits.length % 2 == 1) {
          is_first = true
        }

        self.lastTimeMatching = nil
        CodeOfFlowDay5_4.battleInfo[self.player_id] = BattleStruct(is_first: is_first, opponent: opponent, matched_time: current_time)
        CodeOfFlowDay5_4.battleInfo[opponent] = BattleStruct(is_first: !is_first, opponent: self.player_id, matched_time: current_time)
      } else {
        // Put player_id in the matching list.
        CodeOfFlowDay5_4.matchingLimits.append(current_time)
        CodeOfFlowDay5_4.matchingPlayers.append(self.player_id)
      }

      // Creates Pseudorandom Numbe for the marigan cards
      let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
      let decodedArray = blockCreatedAt.decodeHex()

      let pseudorandomNumber1 = decodedArray[decodedArray.length - 1]
      let pseudorandomNumber2 = decodedArray[decodedArray.length - 2]
      let pseudorandomNumber3 = decodedArray[decodedArray.length - 3]
      let pseudorandomNumber4 = decodedArray[decodedArray.length - 4]
      let pseudorandomNumber5 = decodedArray[decodedArray.length - 5]
      let pseudorandomNumber6 = decodedArray[decodedArray.length - 1]
      let pseudorandomNumber7 = decodedArray[decodedArray.length - 2]
      let pseudorandomNumber8 = decodedArray[decodedArray.length - 3]
      let pseudorandomNumber9 = decodedArray[decodedArray.length - 4]
      let pseudorandomNumber10 = decodedArray[decodedArray.length - 5]
      let pseudorandomNumber11 = decodedArray[decodedArray.length - 1]
      let pseudorandomNumber12 = decodedArray[decodedArray.length - 2]
      let pseudorandomNumber13 = decodedArray[decodedArray.length - 3]
      let pseudorandomNumber14 = decodedArray[decodedArray.length - 4]
      let pseudorandomNumber15 = decodedArray[decodedArray.length - 5]
      let pseudorandomNumber16 = decodedArray[decodedArray.length - 1]
      let pseudorandomNumber17 = decodedArray[decodedArray.length - 2]
      let pseudorandomNumber18 = decodedArray[decodedArray.length - 3]
      let pseudorandomNumber19 = decodedArray[decodedArray.length - 4]
      let pseudorandomNumber20 = decodedArray[decodedArray.length - 5]

      let withdrawPosition1 = pseudorandomNumber1 % 30
      let withdrawPosition2 = pseudorandomNumber2 % 29
      let withdrawPosition3 = pseudorandomNumber3 % 28
      let withdrawPosition4 = pseudorandomNumber4 % 27

      let withdrawPosition5 = pseudorandomNumber5 % 30
      let withdrawPosition6 = pseudorandomNumber6 % 29
      let withdrawPosition7 = pseudorandomNumber7 % 28
      let withdrawPosition8 = pseudorandomNumber8 % 27

      let withdrawPosition9 = pseudorandomNumber9 % 30
      let withdrawPosition10 = pseudorandomNumber10 % 29
      let withdrawPosition11 = pseudorandomNumber11 % 28
      let withdrawPosition12 = pseudorandomNumber12 % 27

      let withdrawPosition13 = pseudorandomNumber13 % 30
      let withdrawPosition14 = pseudorandomNumber14 % 29
      let withdrawPosition15 = pseudorandomNumber15 % 28
      let withdrawPosition16 = pseudorandomNumber16 % 27

      let withdrawPosition17 = pseudorandomNumber17 % 30
      let withdrawPosition18 = pseudorandomNumber18 % 29
      let withdrawPosition19 = pseudorandomNumber19 % 28
      let withdrawPosition20 = pseudorandomNumber20 % 27

      self.marigan_cards = [
        [withdrawPosition1, withdrawPosition2, withdrawPosition3, withdrawPosition4],
        [withdrawPosition5, withdrawPosition6, withdrawPosition7, withdrawPosition8],
        [withdrawPosition9, withdrawPosition10, withdrawPosition11, withdrawPosition12],
        [withdrawPosition13, withdrawPosition14, withdrawPosition15, withdrawPosition16],
        [withdrawPosition17, withdrawPosition18, withdrawPosition19, withdrawPosition20]
      ]
    }

    pub fun game_start(drawed_cards: [UInt16]) {
      pre {
        drawed_cards.length == 4 : "Invalid argument."
        CodeOfFlowDay5_4.battleInfo[self.player_id] != nil && CodeOfFlowDay5_4.battleInfo[self.player_id]!.game_started == false : "Game already started."
      }
      var drawed_pos: [UInt8] = []
      for arr in self.marigan_cards {
        if (self.deck[arr[0]] == drawed_cards[0] && self.deck[arr[1]] == drawed_cards[1] && self.deck[arr[2]] == drawed_cards[2] && self.deck[arr[3]] == drawed_cards[3]) {
          drawed_pos = arr
        }
      }
      if (drawed_pos.length == 0) {
        panic("Invalid argument.")
      }


      if let info = CodeOfFlowDay5_4.battleInfo[self.player_id] {
        info.game_started = true
        info.your_remain_deck = self.deck
        info.last_time_turnend = getCurrentBlock().timestamp
        // Set hand
        var key: UInt8 = 1
        for pos in drawed_pos {
          let card_id = info.your_remain_deck.remove(at: pos - (key - 1))
          info.your_hand[key] = card_id
          key = key + 1
        }
        if (info.is_first == true) {
          info.card_draw_in_this_turn = true
        }
        let opponent = info.opponent
        if let opponentInfo = CodeOfFlowDay5_4.battleInfo[opponent] {
          if opponentInfo.last_time_turnend != nil { // If both people pushed Game Start button..
            opponentInfo.last_time_turnend = info.last_time_turnend // set time same time
            opponentInfo.game_started = true
            opponentInfo.opponent_remain_deck = info.your_remain_deck.length
            opponentInfo.opponent_hand = info.your_hand.keys.length
            CodeOfFlowDay5_4.battleInfo[opponent] = opponentInfo
          }
        }
        if (info.is_first == true) {
          info.your_cp = 2
          emit GameStart(first: self.player_id, second: info.opponent)
        } else {
          info.your_cp = 3
          emit GameStart(first: info.opponent, second: self.player_id)
        }
        CodeOfFlowDay5_4.battleInfo[self.player_id] = info
      }
    }

    pub fun turn_change(attacking_cards: [UInt8], enemy_skill_target: {UInt8: UInt8}, trigger_cards: {UInt8: UInt16}, used_intercept_position: {UInt8: [UInt8]}) {
      for position in attacking_cards {
        if CodeOfFlowDay5_4.battleInfo[self.player_id]!.your_field_unit[position] == nil {
          panic("You have not set unit card in this position!")
        }
      }
      for position in trigger_cards.keys {
        if CodeOfFlowDay5_4.battleInfo[self.player_id]!.your_trigger_cards[position] != trigger_cards[position] || CodeOfFlowDay5_4.battleInfo[self.player_id]!.your_trigger_cards[position] == nil {
          panic("Your trigger card is Tampered!")
        }
      }
      for position in used_intercept_position.keys {
        if used_intercept_position[position]!.length > 0 && CodeOfFlowDay5_4.battleInfo[self.player_id]!.your_trigger_cards[position] == nil {
          panic("You have not set trigger card in this position!")
        }
      }
      var enemy_attacking_cards: [AttackStruct] = []
      var your_trigger_cards_count: Int = 0
      if let info = CodeOfFlowDay5_4.battleInfo[self.player_id] {
        info.last_time_turnend = getCurrentBlock().timestamp
        // トリガーゾーンのカードを合わせる
        for position in trigger_cards.keys {
          if (trigger_cards[position] != 0) {
            info.your_trigger_cards[position] = trigger_cards[position]
          }
        }

        // Set Field Unit Actions To Defence Only
        for position in info.your_field_unit.keys {
          info.your_field_unit_action[position] = 1 // 2: can attack, 1: can defence only, 0: nothing can do.
        }

        // Process Battle Action
        var bp_change: UInt32 = 0
        for position in attacking_cards {
          info.your_field_unit_action[position] = 0 // 2: can attack, 1: can defence only, 0: nothing can do.
          // TODO Trigger Card
          let used_trigger_cards: [UInt16] = []
          if let usedTriggerCards = used_intercept_position[position] {
            for triggerPosition in usedTriggerCards {
              let trigger_card_id = info.your_trigger_cards[triggerPosition]!
              let cardData = CodeOfFlowDay5_4.cardInfo[trigger_card_id]!
              if (cardData.skill.type_1 == 2) {
                // Pump BP
                bp_change = bp_change + cardData.skill.amount_1
              }
              info.your_trigger_cards[triggerPosition] = nil
              used_trigger_cards.append(trigger_card_id)
            }
          }
          let card_id: UInt16 = info.your_field_unit[position]! // CardID
          let unit = CodeOfFlowDay5_4.cardInfo[card_id]!
          // TODO Damage Setting
          let target: UInt8? = enemy_skill_target[position]
          enemy_attacking_cards.append(AttackStruct(card_id: unit.card_id, bp: unit.bp + bp_change, damage: 0, damage_to: 0, used_trigger_cards: used_trigger_cards))
        }
        your_trigger_cards_count = info.your_trigger_cards.keys.length

        // Turn Change
        info.last_time_turnend = getCurrentBlock().timestamp
        info.is_first_turn = !info.is_first_turn
        if (info.is_first_turn) {
          info.turn = info.turn + 1
          info.your_cp = info.turn + 1
          if (info.turn == 1 && !info.is_first) {
            info.your_cp = 3
          }
        }
        info.card_draw_in_this_turn = false
        CodeOfFlowDay5_4.battleInfo[self.player_id] = info

        let opponent = info.opponent
        for position in enemy_skill_target.values {
          if CodeOfFlowDay5_4.battleInfo[opponent]!.your_field_unit[position] == nil {
            panic("You can not use skill for the target of this position!")
          }
        }
        if let infoOpponent = CodeOfFlowDay5_4.battleInfo[opponent] {
          // Recover Field Unit Actions
          for position in infoOpponent.your_field_unit_action.keys {
            infoOpponent.your_field_unit_action[position] = 2 // 2: can attack, 1: can defence only, 0: nothing can do.
          }
          // Process Battle Action
          for position in attacking_cards {
            infoOpponent.opponent_field_unit_action = info.your_field_unit_action
            infoOpponent.enemy_attacking_cards = enemy_attacking_cards
            infoOpponent.opponent_trigger_cards = your_trigger_cards_count
          }
          // Turn Change
          infoOpponent.last_time_turnend = info.last_time_turnend
          infoOpponent.is_first_turn = !infoOpponent.is_first_turn
          if (infoOpponent.is_first_turn) {
            infoOpponent.turn = infoOpponent.turn + 1
            infoOpponent.your_cp = infoOpponent.turn + 1
            if (infoOpponent.turn == 1 && !infoOpponent.is_first) {
              info.your_cp = 3
            }
          }
          CodeOfFlowDay5_4.battleInfo[opponent] = infoOpponent
        }
      }
    }

    pub fun start_your_turn_and_draw_two_cards(blocked_unit: {UInt8: UInt8}, used_intercept_position: {UInt8: UInt8}) {

      if let info = CodeOfFlowDay5_4.battleInfo[self.player_id] {
        info.last_time_turnend = getCurrentBlock().timestamp

        // draw card
        let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
        let decodedArray = blockCreatedAt.decodeHex()

        let pseudorandomNumber1 = decodedArray[decodedArray.length - 1] // as! Int
        let pseudorandomNumber2 = decodedArray[decodedArray.length - 2] // as! Int

        let cardRemainCounts = info.your_remain_deck.length
        let withdrawPosition1 = pseudorandomNumber1 % 15 // (cardRemainCounts - 1)
        let withdrawPosition2 = pseudorandomNumber2 % 15 // (cardRemainCounts - 2)
        let drawed_card_id2 = info.your_remain_deck.remove(at: decodedArray[0])
        var isSetCard1 = false
        var isSetCard2 = false
        var handCnt = 0
        let handPositions: [UInt8] = [1, 2, 3, 4, 5 ,6, 7]
        for hand_position in handPositions {
          if info.your_hand[hand_position] == nil && isSetCard1 == false {
            info.your_hand[hand_position] = info.your_remain_deck.remove(at: withdrawPosition1)
            isSetCard1 = true
          }
          if info.your_hand[hand_position] == nil && isSetCard2 == false {
            info.your_hand[hand_position] = info.your_remain_deck.remove(at: withdrawPosition2)
            isSetCard2 = true
          }
          if info.your_hand[hand_position] != nil {
            handCnt = handCnt + 1
          }
        }
        info.card_draw_in_this_turn = true
        CodeOfFlowDay5_4.battleInfo[self.player_id] = info

        let opponent = info.opponent
        if let infoOpponent = CodeOfFlowDay5_4.battleInfo[opponent] {
          infoOpponent.last_time_turnend = info.last_time_turnend // set time same time
          infoOpponent.opponent_remain_deck = info.your_remain_deck.length
          infoOpponent.opponent_hand = handCnt
          CodeOfFlowDay5_4.battleInfo[opponent] = infoOpponent
        }
      }
    }

    pub fun put_card_on_the_field(unit_card: {UInt8: UInt16}, enemy_skill_target: {UInt8: UInt8}, trigger_cards: {UInt8: UInt16?}, used_intercept_positions: [UInt8]) {
      for position in unit_card.keys {
        if CodeOfFlowDay5_4.battleInfo[self.player_id]!.your_field_unit[position] != nil {
          panic("You can't put unit in this position!")
        }
      }
      for position in trigger_cards.keys {
        if CodeOfFlowDay5_4.battleInfo[self.player_id]!.your_trigger_cards[position] != nil && CodeOfFlowDay5_4.battleInfo[self.player_id]!.your_trigger_cards[position] != trigger_cards[position] {
          panic("Your trigger card is Tampered!")
        }
      }
      for position in used_intercept_positions {
        if CodeOfFlowDay5_4.battleInfo[self.player_id]!.your_trigger_cards[position] == nil {
          panic("You have not set trigger card in this position!")
        }
      }
      var your_field_unit: {UInt8: UInt16} = {}
      var your_trigger_cards_count: Int = 0
      var your_hand_count: Int = 0
      var your_field_unit_action: {UInt8: UInt8} = {}
      if let info = CodeOfFlowDay5_4.battleInfo[self.player_id] {
        // ハンドの整合性を合わせる(トリガーゾーンに移動した分、ハンドから取る)
        var isRemoved = false
        for trigger_position in trigger_cards.keys {
          if info.your_trigger_cards[trigger_position] != trigger_cards[trigger_position] && trigger_cards[trigger_position] != 0 {
            let card_id = trigger_cards[trigger_position]
            for hand_position in info.your_hand.keys {
                if card_id == info.your_hand[hand_position] {
                  info.your_hand[hand_position] = nil
                  isRemoved = true
                }
            }
            if (isRemoved == false) {
              panic("You set the card on trigger zone which is not exist in your hand")
            }
          }
        }
        // Process Card Skills
        for field_position in unit_card.keys {
          let card_id: UInt16 = unit_card[field_position]!
          let unit = CodeOfFlowDay5_4.cardInfo[card_id]!
          if (unit.category != 0) {
            panic("The card you put on the field is not a Unit Card!")
          }
          // ハンドの整合性を合わせる(フィールドに移動した分、ハンドから取る)
          var isRemoved2 = false
          for hand_position in info.your_hand.keys {
              if card_id == info.your_hand[hand_position] {
                info.your_hand[hand_position] = nil
                isRemoved2 = true
              }
              if info.your_hand[hand_position] != nil {
                your_hand_count = your_hand_count + 1
              }
          }
          if (isRemoved2 == false) {
            panic("You set the card on trigger zone which is no exist in your hand")
          }

          info.your_field_unit[field_position] = card_id
          info.your_field_unit_action[field_position] = 1 // 2: can attack, 1: can defence only, 0: nothing can do.
          your_field_unit_action = info.your_field_unit_action
          // TODO Trigger Card
          for card in used_intercept_positions {
            let trigger_card_id = info.your_trigger_cards[card]!
            let cardData = CodeOfFlowDay5_4.cardInfo[trigger_card_id]!
            info.your_trigger_cards[card] = nil
            //infoOpponent.opponent_remain_deck = info.your_remain_deck.length // カードを引いた場合
            //infoOpponent.opponent_hand = handCnt
          }
          // TODO Damage Setting
          for enemy_position in enemy_skill_target.keys {
            let target = enemy_skill_target[enemy_position]!
          }
        }
        your_field_unit = info.your_field_unit
        your_trigger_cards_count = info.your_trigger_cards.keys.length
        CodeOfFlowDay5_4.battleInfo[self.player_id] = info

        let opponent = info.opponent
        for position in enemy_skill_target.values {
          if CodeOfFlowDay5_4.battleInfo[opponent]!.your_field_unit[position] == nil {
            panic("You can not use skill for the target of this position!")
          }
        }
        if let infoOpponent = CodeOfFlowDay5_4.battleInfo[opponent] {
          infoOpponent.opponent_field_unit_action = your_field_unit_action
          infoOpponent.opponent_field_unit = your_field_unit
          infoOpponent.opponent_trigger_cards = your_trigger_cards_count
          infoOpponent.opponent_hand = your_hand_count
          CodeOfFlowDay5_4.battleInfo[opponent] = infoOpponent
        }
      }
    }

    pub fun claimWin() {
      if let info = CodeOfFlowDay5_4.battleInfo[self.player_id] {
        if (info.last_time_turnend! > getCurrentBlock().timestamp + 60.0 && info.is_first != info.is_first_turn) {
          let opponent = info.opponent
          CodeOfFlowDay5_4.battleInfo.remove(key: self.player_id)
          CodeOfFlowDay5_4.battleInfo.remove(key: opponent)
          CodeOfFlowDay5_4.playerList[self.player_id]!.score.append({getCurrentBlock().timestamp: 1})
          CodeOfFlowDay5_4.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 0})
          self.lastTimeMatching = nil
        }
      }
    }

    pub fun surrendar() {
      if CodeOfFlowDay5_4.battleInfo[self.player_id] != nil {
        let opponent = CodeOfFlowDay5_4.battleInfo[self.player_id]!.opponent
        CodeOfFlowDay5_4.battleInfo.remove(key: self.player_id)
        CodeOfFlowDay5_4.playerList[self.player_id]!.score.append({getCurrentBlock().timestamp: 0})
        if (CodeOfFlowDay5_4.battleInfo[opponent] != nil) {
          CodeOfFlowDay5_4.battleInfo.remove(key: opponent)
          CodeOfFlowDay5_4.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 1})
        }
        self.lastTimeMatching = nil
      }
    }

    init(nickname: String) {
      CodeOfFlowDay5_4.totalPlayers = CodeOfFlowDay5_4.totalPlayers + 1
      self.player_id = CodeOfFlowDay5_4.totalPlayers + 1
      self.nickname = nickname
      self.deck = [14, 15, 16, 17, 18, 19, 20, 21, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9]
      self.lastTimeMatching = nil

      self.marigan_cards = []
      CodeOfFlowDay5_4.playerList[self.player_id] = ScoreStruct(player_name: nickname)
      emit PlayerRegistered(player_id: self.player_id)
    }
  }

  pub fun createPlayer(nickname: String): @CodeOfFlowDay5_4.Player {
    return <- create Player(nickname: nickname)
  }

  pub fun getCardInfo(): {UInt16: CardStruct} {
    return self.cardInfo
  }

  pub fun getMatchingLimits(): [UFix64] {
    return self.matchingLimits
  }

  init () {
    self.AdminStoragePath = /storage/CodeOfFlowDay5_4Admin
    self.PlayerStoragePath = /storage/CodeOfFlowDay5_4Player
    self.PlayerPublicPath = /public/CodeOfFlowDay5_4Player
    self.totalPlayers = 0
    self.cardInfo = {
      1: CardStruct(card_id: 1, name: "Hound", bp: 1000, cost: 0, type: 0, category: 0, skill: Skill(description: "No Skill", triggers: [0], asks: [0], types: [0], amounts: [0], skills: [])),
      2: CardStruct(card_id: 2, name: "Fighter", bp: 3000, cost: 1, type: 0, category: 0, skill: Skill(description: "When this unit attacks, this unit's BP increases 2000.", triggers: [2], asks: [0], types: [2], amounts: [2000], skills: [])),
      3: CardStruct(card_id: 3, name: "Lancer", bp: 5000, cost: 2, type: 0, category: 0, skill: Skill(description: "When this unit attacks, you choose an enemy unit, then give 1000 BP damage.", triggers: [2], asks: [1], types: [1], amounts: [1000], skills: [])),
      4: CardStruct(card_id: 4, name: "HellDog", bp: 6000, cost: 3, type: 0, category: 0, skill: Skill(description: "When this unit is put on the field, one of enemy't trigger card zone's card is lost.", triggers: [1], asks: [0], types: [3], amounts: [1], skills: [])),
      5: CardStruct(card_id: 5, name: "Arty", bp: 2000, cost: 2, type: 0, category: 0, skill: Skill(description: "This unit can attack when the turn this card is put on the field.(except 1st turn's first)", triggers: [1], asks: [0], types: [11], amounts: [0], skills: [])),
      6: CardStruct(card_id: 6, name: "Valkyrie", bp: 3000, cost: 3, type: 0, category: 0, skill: Skill(description: "This unit can attack withiout enemy's defence(If attacks, it damages the enemy's life)", triggers: [4], asks: [0], types: [12], amounts: [0], skills: [])),
      7: CardStruct(card_id: 7, name: "Lilim", bp: 4000, cost: 4, type: 0, category: 0, skill: Skill(description: "When this unit is put on the field, you choose an enemy unit, then give 4000 BP damage. When this unit attacks, one of enemy't trigger card zone's card is lost.", triggers: [1,2], asks: [1,0], types: [1,3], amounts: [4000,1], skills: [])),
      8: CardStruct(card_id: 8, name: "Belial", bp: 7000, cost: 7, type: 0, category: 0, skill: Skill(description: "When this unit is put on the field, give all enemies 3000 BP damages.", triggers: [1], asks: [0], types: [4], amounts: [3000], skills: [])),
      9: CardStruct(card_id: 9, name: "Sohei", bp: 2000, cost: 1, type: 1, category: 0, skill: Skill(description: "When this unit blocks, this unit's BP increases 2000.", triggers: [3], asks: [0], types: [2], amounts: [2000], skills: [])),
      10: CardStruct(card_id: 10, name: "LionDog", bp: 1000, cost: 0, type: 1, category: 0, skill: Skill(description: "No Skill", triggers: [0], asks: [0], types: [0], amounts: [0], skills: [])),
      11: CardStruct(card_id: 11, name: "Allie", bp: 2000, cost: 1, type: 1, category: 0, skill: Skill(description: "When this unit is put on the field, you choose an enemy unit, then remove the move right on the turn.", triggers: [1], asks: [1], types: [5], amounts: [0], skills: [])),
      12: CardStruct(card_id: 12, name: "Jumpu", bp: 4000, cost: 4, type: 1, category: 0, skill: Skill(description: "When this unit is put on the field, you choose an enemy unit, then it is reversed to enemy hands.", triggers: [1], asks: [1], types: [6], amounts: [0], skills: [])),
      13: CardStruct(card_id: 13, name: "Caim", bp: 5000, cost: 3, type: 1, category: 0, skill: Skill(description: "When this unit is put on the field, you draw one card.", triggers: [1], asks: [0], types: [7], amounts: [1], skills: [])),
      14: CardStruct(card_id: 14, name: "Limaru", bp: 6000, cost: 3, type: 1, category: 0, skill: Skill(description: "This unit can recover move right of this unit after turn changed to opponent.", triggers: [4], asks: [0], types: [8], amounts: [0], skills: [])),
      15: CardStruct(card_id: 15, name: "Roin", bp: 3000, cost: 2, type: 1, category: 0, skill: Skill(description: "When this unit blocks, this unit's BP increases 2000.", triggers: [3], asks: [0], types: [2], amounts: [2000], skills: [])),
      16: CardStruct(card_id: 16, name: "Rairyu", bp: 6000, cost: 5, type: 1, category: 0, skill: Skill(description: "When this unit is put on the field, you choose an enemy's move right lost unit, then give 7000 BP damage.", triggers: [1], asks: [3], types: [1], amounts: [7000], skills: [])),
      17: CardStruct(card_id: 17, name: "Drive", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "[🔹TRIGGER(AUTO)] When your unit attacks, this card increases its BP 2000 automatically.", triggers: [2], asks: [0], types: [2], amounts: [3000], skills: [])),
      18: CardStruct(card_id: 18, name: "Canon", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "[🔹TRIGGER(AUTO)] When your unit is put on the field, you choose an enemy unit, then give 1000 BP damage.", triggers: [1], asks: [1], types: [1], amounts: [3000], skills: [])),
      19: CardStruct(card_id: 19, name: "Merchant", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "[🔹TRIGGER(AUTO)] When your unit is put on the field, you draw one card.", triggers: [1], asks: [0], types: [7], amounts: [1], skills: [])),
      20: CardStruct(card_id: 20, name: "Breaker", bp: 0, cost: 1, type: 0, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the red type unit is on the field)] When your unit is put on the field, you choose an enemy unit, then give 3000 BP damage.", triggers: [1], asks: [1], types: [1], amounts: [3000], skills: [])),
      21: CardStruct(card_id: 21, name: "Imperiale", bp: 0, cost: 0, type: 0, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the red type unit is on the field)] When your unit is put on the field, enables the unit can attack on the turn.(except 1st turn's first)", triggers: [1], asks: [0], types: [11], amounts: [0], skills: [])),
      22: CardStruct(card_id: 22, name: "Dainsleif", bp: 0, cost: 1, type: 0, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the red type unit is on the field)] When your unit attacks, one of enemy't trigger card zone's card is lost.", triggers: [2], asks: [0], types: [3], amounts: [1], skills: [])),
      23: CardStruct(card_id: 23, name: "Photon", bp: 0, cost: 0, type: 1, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the yellow type unit is on the field)] When your unit is put on the field, you choose an enemy's move right lost unit, then give 3000 BP damage.", triggers: [1], asks: [3], types: [1], amounts: [3000], skills: [])),
      24: CardStruct(card_id: 24, name: "Titan's Lock", bp: 0, cost: 0, type: 1, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the yellow type unit is on the field)] When your unit attacks, you choose an enemy unit, remove the move right on the turn.", triggers: [2], asks: [1], types: [5], amounts: [1], skills: [])),
      25: CardStruct(card_id: 25, name: "Judge", bp: 0, cost: 6, type: 1, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the yellow type unit is on the field)] When your unit attacks, you remove all enemy units move right on the turn.", triggers: [2], asks: [0], types: [5], amounts: [5], skills: [])),
      26: CardStruct(card_id: 26, name: "Hero's Sword", bp: 0, cost: 0, type: 4, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD] When your unit battled, this card increases your unit BP 2000.", triggers: [5], asks: [0], types: [2], amounts: [2000], skills: []))
    }
    self.battleInfo = {}
    self.matchingLimits = []
    self.matchingPlayers = []
    self.playerList = {}
  }
}
