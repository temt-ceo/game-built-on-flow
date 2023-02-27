pub contract CodeOfFlowDayAlpha1 {

  // Events
  pub event PlayerRegistered(player_id: UInt32)
  pub event BattleSequence(sequence: UInt8, player_id: UInt32, opponent: UInt32)
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
    pub(set) var opponent_field_unit_bp_amount_of_change: {UInt8: Int}
    pub(set) var opponent_trigger_cards: Int
    pub(set) var opponent_remain_deck: Int
    pub(set) var opponent_hand: Int
    pub(set) var your_life: UInt8
    pub(set) var your_cp: UInt8
    pub(set) var your_field_unit: {UInt8: UInt16}
    pub(set) var your_field_unit_action: {UInt8: UInt8}
    pub(set) var your_field_unit_bp_amount_of_change: {UInt8: Int}
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
      self.opponent_field_unit_bp_amount_of_change = {}
      self.opponent_trigger_cards = 0
      self.opponent_remain_deck = 30
      self.opponent_hand = 0
      self.your_life = 7
      self.your_cp = 2
      self.your_field_unit = {}
      self.your_field_unit_action = {}
      self.your_field_unit_bp_amount_of_change = {}
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
    pub let pump: UInt32
    pub let field_position: UInt8
    pub let used_trigger_cards: [UInt16]

    init(card_id: UInt16, bp: UInt32, pump: UInt32, field_position: UInt8, used_trigger_cards: [UInt16]) {
      self.card_id = card_id
      self.bp = bp
      self.pump = pump
      self.field_position = field_position
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
      retArr.append(CodeOfFlowDayAlpha1.playerList[self.player_id]!)
      if let info = CodeOfFlowDayAlpha1.battleInfo[self.player_id] {
        let opponent = info.opponent
        retArr.append(CodeOfFlowDayAlpha1.playerList[opponent]!)
      }
      return retArr
    }

    pub fun get_current_status(): AnyStruct {
      if let info = CodeOfFlowDayAlpha1.battleInfo[self.player_id] {
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
      for time in CodeOfFlowDayAlpha1.matchingLimits {
        if outdated == -1 && current_time > time + 60.0 {
          outdated = counter
        }
        counter = counter + 1
      }

      // If there are some expired matching times
      if outdated > -1 {
        // Save only valid matchin times
        if (outdated == 0) {
          CodeOfFlowDayAlpha1.matchingLimits = []
          CodeOfFlowDayAlpha1.matchingPlayers = []
        } else {
          CodeOfFlowDayAlpha1.matchingLimits = CodeOfFlowDayAlpha1.matchingLimits.slice(from: 0, upTo: outdated)
          CodeOfFlowDayAlpha1.matchingPlayers = CodeOfFlowDayAlpha1.matchingPlayers.slice(from: 0, upTo: outdated)
        }
      }

      if CodeOfFlowDayAlpha1.matchingLimits.length >= 1 {
        // Pick the opponent from still matching players.
        let time = CodeOfFlowDayAlpha1.matchingLimits.removeLast()
        let opponent = CodeOfFlowDayAlpha1.matchingPlayers.removeLast()

        var is_first = false
        // Decides which is first
        if (CodeOfFlowDayAlpha1.matchingLimits.length % 2 == 1) {
          is_first = true
        }

        self.lastTimeMatching = nil
        CodeOfFlowDayAlpha1.battleInfo[self.player_id] = BattleStruct(is_first: is_first, opponent: opponent, matched_time: current_time)
        CodeOfFlowDayAlpha1.battleInfo[opponent] = BattleStruct(is_first: !is_first, opponent: self.player_id, matched_time: current_time)
        emit BattleSequence(sequence: 1, player_id: self.player_id, opponent: opponent)
      } else {
        // Put player_id in the matching list.
        CodeOfFlowDayAlpha1.matchingLimits.append(current_time)
        CodeOfFlowDayAlpha1.matchingPlayers.append(self.player_id)
        emit BattleSequence(sequence: 0, player_id: self.player_id, opponent: 0)
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
        CodeOfFlowDayAlpha1.battleInfo[self.player_id] != nil && CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.game_started == false : "Game already started."
      }
      var drawed_pos: [UInt8] = []
      for arr in self.marigan_cards {
        if (self.deck[arr[0]] == drawed_cards[0] && self.deck[arr[1]] == drawed_cards[1] && self.deck[arr[2]] == drawed_cards[2] && self.deck[arr[3]] == drawed_cards[3]) {
          drawed_pos = arr
        }
      }
      if (drawed_pos.length == 0) {
        // Maybe the player did marigan more than 5 times. Set first cards to avoid errors.
        drawed_pos = self.marigan_cards[0]
      }


      if let info = CodeOfFlowDayAlpha1.battleInfo[self.player_id] {
        info.game_started = true
        info.your_remain_deck = self.deck
        info.last_time_turnend = getCurrentBlock().timestamp
        // Set hand
        var key: UInt8 = 1
        for pos in drawed_pos {
          let card_id = info.your_remain_deck.remove(at: pos)
          info.your_hand[key] = card_id
          key = key + 1
        }
        if (info.is_first == true) {
          info.card_draw_in_this_turn = true
        }
        if (info.is_first == true) {
          info.your_cp = 2
          emit GameStart(first: self.player_id, second: info.opponent)
        } else {
          info.your_cp = 3
          emit GameStart(first: info.opponent, second: self.player_id)
        }
        // Save
        CodeOfFlowDayAlpha1.battleInfo[self.player_id] = info

        let opponent = info.opponent
        if let opponentInfo = CodeOfFlowDayAlpha1.battleInfo[opponent] {
          if opponentInfo.last_time_turnend != nil { // If both people pushed Game Start button..
            opponentInfo.last_time_turnend = info.last_time_turnend // set time same time
            opponentInfo.game_started = true
            opponentInfo.opponent_remain_deck = info.your_remain_deck.length
            opponentInfo.opponent_hand = info.your_hand.keys.length
            opponentInfo.opponent_cp = info.your_cp
            // Save
            CodeOfFlowDayAlpha1.battleInfo[opponent] = opponentInfo
            emit BattleSequence(sequence: 2, player_id: self.player_id, opponent: opponent)
          }
        }
      }
    }

    pub fun put_card_on_the_field(unit_card: {UInt8: UInt16}, enemy_skill_target: UInt8?, trigger_cards: {UInt8: UInt16?}, used_intercept_positions: [UInt8]) {
      for position in unit_card.keys {
        if CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.your_field_unit[position] != nil {
          panic("You can't put unit in this position!")
        }
      }
      for position in trigger_cards.keys {
        if CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.your_trigger_cards[position] != nil && CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.your_trigger_cards[position] != trigger_cards[position] {
          panic("Your trigger card is Tampered!")
        }
      }
      for position in used_intercept_positions {
        if CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.your_trigger_cards[position] == nil {
          // panic("You have not set trigger card in this position!") TODO FIXME trigger_cards must be counted before check your_trigger_cards
        }
      }

      var target:UInt8 = 0
      if enemy_skill_target != nil {
        target = enemy_skill_target!
      }

      var your_hand_count: Int = 0
      if let info = CodeOfFlowDayAlpha1.battleInfo[self.player_id] {
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
            info.your_trigger_cards[trigger_position] = trigger_cards[trigger_position]!!
          }
        }
        var lost_card_flg = false
        var speed_move_flg = false
        // Process Card Skills
        for field_position in unit_card.keys { // Usually this is only one card
          let card_id: UInt16 = unit_card[field_position]!
          let unit = CodeOfFlowDayAlpha1.cardInfo[card_id]!
          if (unit.category != 0) {
            panic("The card you put on the field is not a Unit Card!")
          }
          //////////////////////////////////////////////////
          ///////////////attribute evaluation///////////////
          //////////////////////////////////////////////////
          // trigger when the card is put on the field
          if (unit.skill.trigger_1 == 1) {
            //---- Damage ----
            if (unit.skill.type_1 == 1) {
              // Damage to all unit
              if (unit.skill.ask_1 == 0 && unit.skill.type_1 == 4) {
                for opponent_position in info.opponent_field_unit.keys {
                  if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[opponent_position] {
                    info.opponent_field_unit_bp_amount_of_change[opponent_position] = opponent_field_unit_bp_amount_of_change + (-1 * Int(unit.skill.amount_1))
                  } else {
                    info.opponent_field_unit_bp_amount_of_change[opponent_position] = -1 * Int(unit.skill.amount_1)
                  }
                }
              // Damage to one target unit
              } else if (unit.skill.ask_1 == 1) {
                if target > 0 {
                  if (info.opponent_field_unit[target] != nil && info.opponent_field_unit[target]! > 0) {
                    if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                      info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(unit.skill.amount_1))
                    } else {
                      info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(unit.skill.amount_1)
                    }
                  }
                }
              // Omly target which has no action right
              } else if (unit.skill.ask_1 == 2) {
                if target > 0 {
                  if (info.opponent_field_unit[target] != nil && info.opponent_field_unit[target]! > 0) {
                    if (info.opponent_field_unit_action[target] == 3) { // // 2: can attack, 1: can defence only, 0: nothing can do.
                      if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                        info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(unit.skill.amount_1))
                      } else {
                        info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(unit.skill.amount_1)
                      }
                    }
                  }
                }
              }
            }
            //---- Trigger lost ----
            if (unit.skill.type_1 == 3) {
              lost_card_flg = true
            }
            //---- Remove action right ----
            if (unit.skill.type_1 == 5) {
              if target > 0 {
                if (info.opponent_field_unit[target] != nil && info.opponent_field_unit[target]! > 0) {
                  info.opponent_field_unit_action[target] = 0 // // 2: can attack, 1: can defence only, 0: nothing can do.
                }
              }
            }
            //---- Draw card ----
            if (unit.skill.type_1 == 7) {
              let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
              let decodedArray = blockCreatedAt.decodeHex()
              let pseudorandomNumber1 = Int(decodedArray[decodedArray.length - 1])
              let withdrawPosition1 = pseudorandomNumber1 % (info.your_remain_deck.length - 1)
              var isSetCard1 = false
              var handCnt = 0
              let handPositions: [UInt8] = [1, 2, 3, 4, 5 ,6, 7]
              for hand_position in handPositions {
                if info.your_hand[hand_position] == nil && isSetCard1 == false {
                  info.your_hand[hand_position] = info.your_remain_deck.remove(at: withdrawPosition1)
                  isSetCard1 = true
                }
              }
            }
            //---- Speed Move ----
            if (unit.skill.type_1 == 11) {
              speed_move_flg = true
            }
          }
          if (unit.skill.trigger_2 == 1) { // currently there is no card which has trigger_3 and trigger_4
            if (unit.skill.trigger_2 == 1) {}
          }
          // Used Trigger or Intercept Card
          for card_position in used_intercept_positions {
            if (info.your_trigger_cards[card_position] != nil) { // To avoid transaction error which interrupt the game.
              let trigger_card_id = info.your_trigger_cards[card_position]!
              let trigger = CodeOfFlowDayAlpha1.cardInfo[trigger_card_id]!
              info.your_trigger_cards[card_position] = nil

              if (trigger.skill.trigger_1 == 1) {
                //---- Damage ----
                if (trigger.skill.type_1 == 1 || trigger.skill.type_1 == 4) {
                  // Damage Target
                  var target: UInt8 = 1
                  if target > 0 {
                    if (info.opponent_field_unit[target] != nil && info.opponent_field_unit[target]! > 0) {
                      // Damage to one target unit
                      if (trigger.skill.ask_1 == 1) {
                        if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                          info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(trigger.skill.amount_1))
                        } else {
                          info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(trigger.skill.amount_1)
                        }
                      // Omly target which has no action right
                      } else if (trigger.skill.ask_1 == 2) {
                        if (info.opponent_field_unit_action[target] == 3) { // // 2: can attack, 1: can defence only, 0: nothing can do.
                          if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                            info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(trigger.skill.amount_1))
                          } else {
                            info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(trigger.skill.amount_1)
                          }
                        }
                      }
                    }
                  }
                }
                //---- Trigger lost ----
                if (trigger.skill.type_1 == 3) {
                  lost_card_flg = true
                }
                //---- Speed Move ----
                if (trigger.skill.type_1 == 11) {
                  speed_move_flg = true
                }
              }
            }
          }
          //////////////////////////////////////////////////
          ///////////////↑↑attribute evaluation↑↑///////////
          //////////////////////////////////////////////////

          info.your_field_unit[field_position] = card_id
          if (speed_move_flg == true && !(info.turn == 1 && info.is_first_turn == true)) {
            info.your_field_unit_action[field_position] = 2 // 2: can attack, 1: can defence only, 0: nothing can do.
          } else {
            info.your_field_unit_action[field_position] = 1
          }
          info.your_cp = info.your_cp - unit.cost

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
            panic("You set the card on the Field which is not exist in your hand")
          }
        }

        // Save
        CodeOfFlowDayAlpha1.battleInfo[self.player_id] = info

        let opponent = info.opponent
        if target > 0 && CodeOfFlowDayAlpha1.battleInfo[opponent]!.your_field_unit[target] == nil {
          panic("You can not use skill for the target of this position!")
        }
        if let infoOpponent = CodeOfFlowDayAlpha1.battleInfo[opponent] {
          infoOpponent.opponent_remain_deck = info.your_remain_deck.length
          infoOpponent.opponent_hand = your_hand_count
          infoOpponent.opponent_trigger_cards = info.your_trigger_cards.keys.length
          infoOpponent.opponent_field_unit = info.your_field_unit
          infoOpponent.opponent_field_unit_action = info.your_field_unit_action
          infoOpponent.your_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change
          // Process Trigger Lost
          if (lost_card_flg == true) {
            let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
            let decodedArray = blockCreatedAt.decodeHex()
            let pseudorandomNumber1 = decodedArray[decodedArray.length - 1]
            let withdrawPosition1 = pseudorandomNumber1 % (UInt8(infoOpponent.your_trigger_cards.keys.length) - 1)
            infoOpponent.your_trigger_cards[withdrawPosition1] = info.your_trigger_cards.remove(key: withdrawPosition1)
          }
          // Save
          CodeOfFlowDayAlpha1.battleInfo[opponent] = infoOpponent
        }
      }
    }

    pub fun turn_change(attacking_cards: [UInt8], enemy_skill_target: {UInt8: UInt8}, trigger_cards: {UInt8: UInt16}, used_intercept_position: {UInt8: [UInt8]}) {
      for position in attacking_cards {
        if CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.your_field_unit[position] == nil {
          panic("You have not set unit card in this position!")
        }
      }
      for position in trigger_cards.keys {
        if !(CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.your_trigger_cards[position] == trigger_cards[position] || CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.your_trigger_cards[position] == nil) {
          // panic("Your trigger card is Tampered!") To avoid transaction failure by the coincident accident.
        }
      }
      for position in used_intercept_position.keys {
        if used_intercept_position[position]!.length > 0 && CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.your_trigger_cards[position] == nil {
          // panic("You have not set trigger card in this position!") TODO FIXME trigger_cards must be counted before check your_trigger_cards
        }
      }
      var enemy_attacking_cards: [AttackStruct] = []
      var your_trigger_cards_count: Int = 0
      if let info = CodeOfFlowDayAlpha1.battleInfo[self.player_id] {
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
          if info.your_field_unit[position] != nil && info.your_field_unit[position] != 0 {
            let card_id: UInt16 = info.your_field_unit[position]!
            let unit = CodeOfFlowDayAlpha1.cardInfo[card_id]!
            ///////////////attribute evaluation///////////////
            // trigger when the turn is changing
            if (unit.skill.trigger_1 == 4) {
                //---- indomitable spirit ----
              if (unit.skill.type_1 == 8) {
                  info.your_field_unit_action[position] = 1
              }
            }
          }
          ///////////////attribute evaluation///////////////
        }

        // Process Battle Action
        var lost_card_flg = false
        var speed_move_flg = false
        let used_trigger_cards: [UInt16] = []
        for position in attacking_cards {
          info.your_field_unit_action[position] = 0 // 2: can attack, 1: can defence only, 0: nothing can do.

          //////////////////////////////////////////////////
          ///////////////attribute evaluation///////////////
          //////////////////////////////////////////////////
          let card_id: UInt16 = info.your_field_unit[position]!
          let unit = CodeOfFlowDayAlpha1.cardInfo[card_id]!
          // trigger when the unit is attacking
          if (unit.skill.trigger_1 == 2) {
            //---- BP Pump ----
            if (unit.skill.type_1 == 2) {
              if let your_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change[position] {
                info.your_field_unit_bp_amount_of_change[position] = your_field_unit_bp_amount_of_change + Int(unit.skill.amount_1)
              } else {
                info.your_field_unit_bp_amount_of_change[position] = Int(unit.skill.amount_1)
              }
            }

            //---- Damage ----
            if (unit.skill.type_1 == 1 || unit.skill.type_1 == 4) {
              // Damage to all unit
              if (unit.skill.ask_1 == 0 && unit.skill.type_1 == 4) {
                for opponent_position in info.opponent_field_unit.keys {
                  if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[opponent_position] {
                    info.opponent_field_unit_bp_amount_of_change[opponent_position] = opponent_field_unit_bp_amount_of_change + (-1 * Int(unit.skill.amount_1))
                  } else {
                    info.opponent_field_unit_bp_amount_of_change[opponent_position] = -1 * Int(unit.skill.amount_1)
                  }
                }
              // Damage to one target unit
              } else if (unit.skill.ask_1 == 1) {
                var target: UInt8 = 1
                if enemy_skill_target[position] != nil {
                  target = enemy_skill_target[position]!
                }
                if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                  info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(unit.skill.amount_1))
                } else {
                  info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(unit.skill.amount_1)
                }
              // Omly target which has no action right
              } else if (unit.skill.ask_1 == 2) {
                var target: UInt8 = 1
                if enemy_skill_target[position] != nil {
                  target = enemy_skill_target[position]!
                }
                if (info.opponent_field_unit_action[target] == 3) { // // 2: can attack, 1: can defence only, 0: nothing can do.
                  if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                    info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(unit.skill.amount_1))
                  } else {
                    info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(unit.skill.amount_1)
                  }
                }
              }
            }
            //---- Trigger lost ----
            if (unit.skill.type_1 == 3) {
              lost_card_flg = true
            }
            //---- Remove action right ----
            if (unit.skill.type_1 == 5) {
              var target: UInt8 = 1
              if enemy_skill_target[position] != nil {
                target = enemy_skill_target[position]!
              }
              info.opponent_field_unit_action[target] = 0 // // 2: can attack, 1: can defence only, 0: nothing can do.
            }
            //---- Draw card ----
            if (unit.skill.type_1 == 7) {
              let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
              let decodedArray = blockCreatedAt.decodeHex()
              let pseudorandomNumber1 = Int(decodedArray[decodedArray.length - 1])
              let withdrawPosition1 = pseudorandomNumber1 % (info.your_remain_deck.length - 1)
              var isSetCard1 = false
              var handCnt = 0
              let handPositions: [UInt8] = [1, 2, 3, 4, 5 ,6, 7]
              for hand_position in handPositions {
                if info.your_hand[hand_position] == nil && isSetCard1 == false {
                  info.your_hand[hand_position] = info.your_remain_deck.remove(at: withdrawPosition1)
                  isSetCard1 = true
                }
              }
            }
            //---- Speed Move ----
            if (unit.skill.type_1 == 11) {
              speed_move_flg = true
            }
          }
          // trigger when the unit is attacking
          if (unit.skill.trigger_2 == 2) { // currently there is no card which has trigger_3 and trigger_4
            if (unit.skill.type_2 == 3) {
              lost_card_flg = true
            }
          }
          if (used_intercept_position[position] != nil) {
            // Used Trigger or Intercept Card
            for card_position in used_intercept_position[position]! {
              let trigger_card_id = info.your_trigger_cards[card_position]!
              let trigger = CodeOfFlowDayAlpha1.cardInfo[trigger_card_id]!
              info.your_trigger_cards[card_position] = nil
              // trigger when the unit is attacking
              if (trigger.skill.trigger_1 == 2 || trigger.skill.trigger_1 == 5) {
                //---- BP Pump ----
                if (trigger.skill.type_1 == 2) {
                  if let your_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change[position] {
                    info.your_field_unit_bp_amount_of_change[position] = your_field_unit_bp_amount_of_change + Int(trigger.skill.amount_1)
                  } else {
                    info.your_field_unit_bp_amount_of_change[position] = Int(trigger.skill.amount_1)
                  }
                }
                // Enemy Unit Target
                var target: UInt8 = 1
                if (enemy_skill_target[position] != nil) {
                  target = enemy_skill_target[position]!
                }
                //---- Damage ----
                if (trigger.skill.type_1 == 1 || trigger.skill.type_1 == 4) {
                  // Damage to one target unit
                  if (trigger.skill.ask_1 == 1) {
                    if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                      info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(trigger.skill.amount_1))
                    } else {
                      info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(trigger.skill.amount_1)
                    }
                  // Omly target which has no action right
                  } else if (trigger.skill.ask_1 == 2) {
                    if (info.opponent_field_unit_action[target] == 3) { // // 2: can attack, 1: can defence only, 0: nothing can do.
                      if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                        info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(trigger.skill.amount_1))
                      } else {
                        info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(trigger.skill.amount_1)
                      }
                    }
                  }
                }
                //---- Trigger lost ----
                if (trigger.skill.type_1 == 3) {
                  lost_card_flg = true
                }
                //---- Remove action right ----
                if (trigger.skill.type_1 == 5) {
                  if trigger.skill.amount_1 == 1 {
                    info.opponent_field_unit_action[target] = 0 // // 2: can attack, 1: can defence only, 0: nothing can do.
                  } else if (trigger.skill.amount_1 == 5) {
                    for enemy_position in info.opponent_field_unit_action.keys {
                      info.opponent_field_unit_action[enemy_position] = 0
                    }
                  }
                }
              }
              used_trigger_cards.append(trigger_card_id)
            }
          }
          //////////////////////////////////////////////////
          ///////////////↑↑attribute evaluation↑↑///////////
          //////////////////////////////////////////////////
          var unit_pump: UInt32 = 0
          if (info.your_field_unit_bp_amount_of_change[position] != nil) {
            unit_pump = UInt32(info.your_field_unit_bp_amount_of_change[position]!)
          }
          enemy_attacking_cards.append(AttackStruct(card_id: unit.card_id, bp: unit.bp, pump: unit_pump, field_position: position, used_trigger_cards: used_trigger_cards))
        }

        // Process Turn Change
        info.last_time_turnend = getCurrentBlock().timestamp
        info.is_first_turn = !info.is_first_turn
        if (info.is_first_turn) {
          info.turn = info.turn + 1
        }
        info.card_draw_in_this_turn = false
        // save
        CodeOfFlowDayAlpha1.battleInfo[self.player_id] = info

        let opponent = info.opponent
        for position in enemy_skill_target.values {
          if (position != 0) {
            if CodeOfFlowDayAlpha1.battleInfo[opponent]!.your_field_unit[position] == nil {
              panic("You can not use skill for the target of this position!")
            }
          }
        }
        if let infoOpponent = CodeOfFlowDayAlpha1.battleInfo[opponent] {
          // Turn Change
          infoOpponent.last_time_turnend = info.last_time_turnend
          infoOpponent.is_first_turn = !infoOpponent.is_first_turn
          infoOpponent.turn = info.turn
          infoOpponent.enemy_attacking_cards = enemy_attacking_cards
          infoOpponent.opponent_remain_deck = info.your_remain_deck.length
          infoOpponent.opponent_trigger_cards = info.your_trigger_cards.keys.length
          infoOpponent.opponent_field_unit = info.your_field_unit
          infoOpponent.opponent_field_unit_action = info.your_field_unit_action
          infoOpponent.opponent_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change
          infoOpponent.your_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change
          // Process Trigger Lost
          if (lost_card_flg == true) {
            let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
            let decodedArray = blockCreatedAt.decodeHex()
            let pseudorandomNumber1 = decodedArray[decodedArray.length - 1]
            let withdrawPosition1 = pseudorandomNumber1 % (UInt8(infoOpponent.your_trigger_cards.keys.length) - 1)
            infoOpponent.your_trigger_cards[withdrawPosition1] = info.your_trigger_cards.remove(key: withdrawPosition1)
          }
          CodeOfFlowDayAlpha1.battleInfo[opponent] = infoOpponent
        }
      }
    }

    pub fun start_your_turn_and_draw_two_cards(blocked_unit: {UInt8: UInt8}, used_intercept_position: {UInt8: UInt8}) {

      if let info = CodeOfFlowDayAlpha1.battleInfo[self.player_id] {
        for position in blocked_unit.keys {
          //////////////////////////////////////////////////
          ///////////////attribute evaluation///////////////
          //////////////////////////////////////////////////
          if position != 0  && info.your_field_unit[position] != nil {
            let card_id: UInt16 = info.your_field_unit[position]!
            let unit = CodeOfFlowDayAlpha1.cardInfo[card_id]!
            // trigger when the unit is blocking
            if (unit.skill.trigger_1 == 3) {
              //---- BP Pump ----
              if (unit.skill.type_1 == 2) {
                if let your_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change[position] {
                  info.your_field_unit_bp_amount_of_change[position] = your_field_unit_bp_amount_of_change + Int(unit.skill.amount_1)
                } else {
                  info.your_field_unit_bp_amount_of_change[position] = Int(unit.skill.amount_1)
                }
              }
            }
            if (used_intercept_position[position] != nil && used_intercept_position[position] != 0) {
              // Used Trigger or Intercept Card
              let card_position = used_intercept_position[position]!
              let trigger_card_id = info.your_trigger_cards[card_position]!
              let trigger = CodeOfFlowDayAlpha1.cardInfo[trigger_card_id]!
              info.your_trigger_cards[card_position] = nil

              // trigger when the unit is blocking
              if (trigger.skill.trigger_1 == 3 || unit.skill.trigger_1 == 5) {
                //---- BP Pump ----
                if (trigger.skill.type_1 == 2) {
                  if let your_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change[position] {
                    info.your_field_unit_bp_amount_of_change[position] = your_field_unit_bp_amount_of_change + Int(trigger.skill.amount_1)
                  } else {
                    info.your_field_unit_bp_amount_of_change[position] = Int(trigger.skill.amount_1)
                  }
                }
              }
            }
            //////////////////////////////////////////////////
            ///////////////↑↑attribute evaluation↑↑///////////
            //////////////////////////////////////////////////
          }
        }

        //////////////// Battle Result ////////////////
        for enemy_attacking_card in info.enemy_attacking_cards {
          var battleFlg = false
          var winFlg = false
          for b_position in blocked_unit.keys {
            // when each unit's position is matched
            if blocked_unit[b_position] == enemy_attacking_card.field_position {
              battleFlg = true
              if info.your_field_unit[b_position] != nil && CodeOfFlowDayAlpha1.cardInfo[info.your_field_unit[b_position]!] != nil {
                let unit = CodeOfFlowDayAlpha1.cardInfo[info.your_field_unit[b_position]!]!
                var pump = 0
                if info.your_field_unit_bp_amount_of_change[b_position] != nil {
                  pump = info.your_field_unit_bp_amount_of_change[b_position]!
                }
                if Int(unit.bp) + pump > Int(enemy_attacking_card.bp + enemy_attacking_card.pump) {
                  winFlg = true
                }
              }
              if (winFlg) {
                info.opponent_field_unit[enemy_attacking_card.field_position] = nil
              } else {
                info.your_field_unit[b_position] = nil
              }
            }
          }
          // Haven't defence = Life 1 Lost
          if (battleFlg == false) {
            info.your_life = info.your_life - 1
          }
        }
        ////////////// ↑↑Battle Result↑↑ //////////////

        info.last_time_turnend = getCurrentBlock().timestamp

        // draw card
        let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
        let decodedArray = blockCreatedAt.decodeHex()

        let pseudorandomNumber1 = decodedArray[decodedArray.length - 1] // as! Int
        let pseudorandomNumber2 = decodedArray[decodedArray.length - 2] // as! Int

        let cardRemainCounts = info.your_remain_deck.length
        let withdrawPosition1 = Int(pseudorandomNumber1) % (cardRemainCounts - 1)
        let withdrawPosition2 = Int(pseudorandomNumber2) % (cardRemainCounts - 2)
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
        info.enemy_attacking_cards = []
        info.your_field_unit_bp_amount_of_change = {} // Damage are reset
        info.opponent_field_unit_bp_amount_of_change = {}

        // Recover Field Unit Actions
        for position in info.your_field_unit_action.keys {
          info.your_field_unit_action[position] = 2 // 2: can attack, 1: can defence only, 0: nothing can do.
        }
        // Recover CP
        info.your_cp = info.turn + 1
        if (info.turn == 1 && !info.is_first) {
          info.your_cp = 3
        }

        // save
        CodeOfFlowDayAlpha1.battleInfo[self.player_id] = info

        let opponent = info.opponent
        if let infoOpponent = CodeOfFlowDayAlpha1.battleInfo[opponent] {
          infoOpponent.last_time_turnend = info.last_time_turnend // set time same time
          infoOpponent.enemy_attacking_cards = info.enemy_attacking_cards
          infoOpponent.opponent_hand = handCnt
          infoOpponent.opponent_remain_deck = info.your_remain_deck.length
          infoOpponent.opponent_trigger_cards = info.your_trigger_cards.keys.length
          infoOpponent.opponent_field_unit = info.your_field_unit
          infoOpponent.opponent_field_unit_action = info.your_field_unit_action
          infoOpponent.opponent_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change
          infoOpponent.opponent_cp = info.your_cp
          CodeOfFlowDayAlpha1.battleInfo[opponent] = infoOpponent
        }
      }
    }

    pub fun claimWin() {
      pre {
        CodeOfFlowDayAlpha1.battleInfo[self.player_id] != nil : "This guy doesn't do match."
      }

      if let info = CodeOfFlowDayAlpha1.battleInfo[self.player_id] {
        if (info.last_time_turnend! + 60.0 < getCurrentBlock().timestamp && info.is_first != info.is_first_turn) {
          let opponent = info.opponent
          CodeOfFlowDayAlpha1.battleInfo.remove(key: self.player_id)
          CodeOfFlowDayAlpha1.battleInfo.remove(key: opponent)
          CodeOfFlowDayAlpha1.playerList[self.player_id]!.score.append({getCurrentBlock().timestamp: 1})
          CodeOfFlowDayAlpha1.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 0})
          self.lastTimeMatching = nil
          emit BattleSequence(sequence: 3, player_id: self.player_id, opponent: opponent)
        }
      }
    }

    pub fun surrendar() {
      if CodeOfFlowDayAlpha1.battleInfo[self.player_id] != nil {
        let opponent = CodeOfFlowDayAlpha1.battleInfo[self.player_id]!.opponent
        CodeOfFlowDayAlpha1.battleInfo.remove(key: self.player_id)
        CodeOfFlowDayAlpha1.playerList[self.player_id]!.score.append({getCurrentBlock().timestamp: 0})
        if (CodeOfFlowDayAlpha1.battleInfo[opponent] != nil) {
          CodeOfFlowDayAlpha1.battleInfo.remove(key: opponent)
          CodeOfFlowDayAlpha1.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 1})
        }
        self.lastTimeMatching = nil
        emit BattleSequence(sequence: 3, player_id: opponent, opponent: self.player_id)
      }
    }

    init(nickname: String) {
      CodeOfFlowDayAlpha1.totalPlayers = CodeOfFlowDayAlpha1.totalPlayers + 1
      self.player_id = CodeOfFlowDayAlpha1.totalPlayers + 1
      self.nickname = nickname
      self.deck = [14, 15, 16, 17, 18, 19, 20, 21, 1, 1, 26, 2, 2, 25, 3, 3, 24, 4, 4, 23, 5, 10, 6, 11, 7, 13, 8, 22, 9, 9]
      self.lastTimeMatching = nil

      self.marigan_cards = []
      CodeOfFlowDayAlpha1.playerList[self.player_id] = ScoreStruct(player_name: nickname)
      emit PlayerRegistered(player_id: self.player_id)
    }
  }

  pub fun createPlayer(nickname: String): @CodeOfFlowDayAlpha1.Player {
    return <- create Player(nickname: nickname)
  }

  pub fun getCardInfo(): {UInt16: CardStruct} {
    return self.cardInfo
  }

  pub fun getMatchingLimits(): [UFix64] {
    return self.matchingLimits
  }

  init () {
    self.AdminStoragePath = /storage/CodeOfFlowDayAlpha1Admin
    self.PlayerStoragePath = /storage/CodeOfFlowDayAlpha1Player
    self.PlayerPublicPath = /public/CodeOfFlowDayAlpha1Player
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
      13: CardStruct(card_id: 13, name: "Caim", bp: 5000, cost: 3, type: 1, category: 0, skill: Skill(description: "When this unit is put on the field, you draw one card.", triggers: [1], asks: [0], types: [7], amounts: [1], skills: [])),
      14: CardStruct(card_id: 14, name: "Limaru", bp: 6000, cost: 3, type: 1, category: 0, skill: Skill(description: "This unit can recover move right of this unit after turn changed to opponent.", triggers: [4], asks: [0], types: [8], amounts: [0], skills: [])),
      15: CardStruct(card_id: 15, name: "Roin", bp: 3000, cost: 2, type: 1, category: 0, skill: Skill(description: "When this unit blocks, this unit's BP increases 2000.", triggers: [3], asks: [0], types: [2], amounts: [2000], skills: [])),
      16: CardStruct(card_id: 16, name: "Rairyu", bp: 6000, cost: 5, type: 1, category: 0, skill: Skill(description: "When this unit is put on the field, you choose an enemy's move right lost unit, then give 7000 BP damage.", triggers: [1], asks: [2], types: [1], amounts: [7000], skills: [])),
      17: CardStruct(card_id: 17, name: "Drive", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "[🔹TRIGGER(AUTO)] When your unit attacks, this card increases its BP 2000 automatically.", triggers: [2], asks: [0], types: [2], amounts: [3000], skills: [])),
      18: CardStruct(card_id: 18, name: "Canon", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "[🔹TRIGGER(AUTO)] When your unit is put on the field, you choose an enemy unit, then give 1000 BP damage.", triggers: [1], asks: [1], types: [1], amounts: [3000], skills: [])),
      19: CardStruct(card_id: 19, name: "Merchant", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "[🔹TRIGGER(AUTO)] When your unit is put on the field, you draw one card.", triggers: [1], asks: [0], types: [7], amounts: [1], skills: [])),
      20: CardStruct(card_id: 20, name: "Breaker", bp: 0, cost: 1, type: 0, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the red type unit is on the field)] When your unit is put on the field, you choose an enemy unit, then give 3000 BP damage.", triggers: [1], asks: [1], types: [1], amounts: [3000], skills: [])),
      21: CardStruct(card_id: 21, name: "Imperiale", bp: 0, cost: 0, type: 0, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the red type unit is on the field)] When your unit is put on the field, enables the unit can attack on the turn.(except 1st turn's first)", triggers: [1], asks: [0], types: [11], amounts: [0], skills: [])),
      22: CardStruct(card_id: 22, name: "Dainsleif", bp: 0, cost: 1, type: 0, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the red type unit is on the field)] When your unit attacks, one of enemy't trigger card zone's card is lost.", triggers: [2], asks: [0], types: [3], amounts: [1], skills: [])),
      23: CardStruct(card_id: 23, name: "Photon", bp: 0, cost: 0, type: 1, category: 2, skill: Skill(description: "[🔸INTERCEPT CARD(only avalable when the yellow type unit is on the field)] When your unit is put on the field, you choose an enemy's move right lost unit, then give 3000 BP damage.", triggers: [1], asks: [2], types: [1], amounts: [3000], skills: [])),
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
