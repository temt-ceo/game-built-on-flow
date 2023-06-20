import FlowToken from 0x7e60df042a9c0868
import FungibleToken from 0x9a0766d93b6608b7

pub contract CodeOfFlowBeta4 {

  // Events
  pub event PlayerRegistered(player_id: UInt)
  pub event BattleSequence(sequence: UInt8, player_id: UInt, opponent: UInt)
  pub event GameStart(first: UInt, second: UInt)
  pub event GameResult(first: UInt, second: UInt, winner: UInt)

  // Paths
  pub let AdminStoragePath: StoragePath
  pub let PlayerStoragePath: StoragePath
  pub let PlayerPublicPath: PublicPath

  // Variants
  priv var totalPlayers: UInt

  pub let FlowTokenVault: Capability<&FlowToken.Vault{FungibleToken.Receiver}>
  pub let PlayerFlowTokenVault: {UInt: Capability<&FlowToken.Vault{FungibleToken.Receiver}>}

  // Objects
  priv let cardInfo: {UInt16: CardStruct}
  priv let battleInfo: {UInt: BattleStruct}
  priv var matchingLimits: [UFix64]
  priv var matchingPlayers: [UInt]
  priv let playerList: {UInt: CyberScoreStruct}
  priv let playerDeck: {UInt: [UInt16]}
  pub let starterDeck: [UInt16]

  // [Struct] CardStruct
  pub struct CardStruct {
    pub let card_id: UInt16
    pub let name: String
    pub let bp: UInt
    pub let cost: UInt8
    pub let type: UInt8
    pub let category: UInt8
    pub let skill: Skill
    init(card_id: UInt16, name: String, bp: UInt, cost: UInt8, type: UInt8, category: UInt8, skill: Skill) {
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
    pub let amount_1: UInt
    pub let amount_2: UInt
    pub let amount_3: UInt
    pub let amount_4: UInt
    pub let nestedSkill_1: Skill?
    pub let nestedSkill_2: Skill?
    pub let nestedSkill_3: Skill?
    pub let nestedSkill_4: Skill?
    init(description: String, triggers: [UInt8], asks: [UInt8], types: [UInt8], amounts: [UInt], skills: [Skill]) {
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
    pub let opponent: UInt
    pub let matched_time: UFix64
    pub(set) var game_started: Bool
    pub(set) var last_time_turnend: UFix64?
    pub(set) var opponent_life: UInt8
    pub(set) var opponent_cp: UInt8
    pub(set) var opponent_field_unit: {UInt8: UInt16}
    pub(set) var opponent_field_unit_length: Int
    pub(set) var opponent_field_unit_action: {UInt8: UInt8}
    pub(set) var opponent_field_unit_bp_amount_of_change: {UInt8: Int}
    pub(set) var opponent_trigger_cards: Int
    pub(set) var opponent_remain_deck: Int
    pub(set) var opponent_hand: Int
    pub(set) var your_life: UInt8
    pub(set) var your_cp: UInt8
    pub(set) var your_field_unit: {UInt8: UInt16}
    pub(set) var your_field_unit_length: Int
    pub(set) var your_field_unit_action: {UInt8: UInt8}
    pub(set) var your_field_unit_bp_amount_of_change: {UInt8: Int}
    pub(set) var your_trigger_cards: {UInt8: UInt16}
    pub(set) var your_remain_deck: [UInt16]
    pub(set) var your_hand: {UInt8: UInt16}
    pub(set) var card_draw_in_this_turn: Bool
    pub(set) var your_attacking_card: AttackStruct?
    pub(set) var enemy_attacking_card: AttackStruct?

    init(is_first: Bool, opponent: UInt, matched_time: UFix64) {
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
      self.opponent_field_unit_length = 0
      self.opponent_field_unit_action = {}
      self.opponent_field_unit_bp_amount_of_change = {}
      self.opponent_trigger_cards = 0
      self.opponent_remain_deck = 30
      self.opponent_hand = 0
      self.your_life = 7
      self.your_cp = 2
      self.your_field_unit = {}
      self.your_field_unit_length = 0
      self.your_field_unit_action = {}
      self.your_field_unit_bp_amount_of_change = {}
      self.your_trigger_cards = {}
      self.your_remain_deck = []
      self.your_hand = {}
      self.card_draw_in_this_turn = false
      self.your_attacking_card = nil
      self.enemy_attacking_card = nil
    }
  }

  // [Struct] AttackStruct
  pub struct AttackStruct {
    pub let card_id: UInt16
    pub let position: UInt8
    pub let bp: UInt
    pub let pump: UInt
    pub let field_position: UInt8
    pub let used_trigger_cards: [UInt16]
    pub let attacked_time: UFix64

    init(card_id: UInt16, position: UInt8, bp: UInt, pump: UInt, field_position: UInt8, used_trigger_cards: [UInt16], attacked_time: UFix64) {
      self.card_id = card_id
      self.position = position
      self.bp = bp
      self.pump = pump
      self.field_position = field_position
      self.used_trigger_cards = used_trigger_cards
      self.attacked_time = attacked_time
    }
  }

  // [Struct] CyberScoreStruct
  pub struct CyberScoreStruct {
    pub let player_name: String
    pub(set) var score: [{UFix64: UInt8}]
    pub(set) var cyber_energy: UInt8
    pub(set) var balance: UFix64

    init(player_name: String) {
      self.player_name = player_name
      self.score = []
      self.cyber_energy = 0
      self.balance = 0.0
    }
  }

  priv let playerMatchingInfo: {UInt: PlayerMatchingStruct}

  pub struct PlayerMatchingStruct {
    pub(set) var lastTimeMatching: UFix64?
    pub(set) var marigan_cards: [[UInt8]]
    init() {
      self.lastTimeMatching = nil
      self.marigan_cards = []
    }
  }

  /*
  ** [Resource] Admin
  */
  pub resource Admin {
    /*
    ** Save the Player's Card Deck
    */
    pub fun save_deck(player_id: UInt, user_deck: [UInt16]) {
      if user_deck.length == 30 {
        CodeOfFlowBeta4.playerDeck[player_id] = user_deck
      }
    }

    /*
    ** Player Matching Transaction
    */
    pub fun matching_start(player_id: UInt) {
      pre {
        // preの中の条件に合わない場合はエラーメッセージが返ります。 ここでは"Still matching."。
        CodeOfFlowBeta4.playerMatchingInfo[player_id] == nil ||
        CodeOfFlowBeta4.playerMatchingInfo[player_id]!.lastTimeMatching == nil ||
        CodeOfFlowBeta4.playerMatchingInfo[player_id]!.lastTimeMatching! + 60.0 <= getCurrentBlock().timestamp : "Still matching."
      }
      var counter = 0
      var outdated = -1
      let current_time = getCurrentBlock().timestamp
      if let obj = CodeOfFlowBeta4.playerMatchingInfo[player_id] {
        obj.lastTimeMatching = current_time
        CodeOfFlowBeta4.playerMatchingInfo[player_id] = obj // save
      } else {
        let newObj = PlayerMatchingStruct()
        newObj.lastTimeMatching = current_time
        CodeOfFlowBeta4.playerMatchingInfo[player_id] = newObj
      }

      // Search where matching times are already past 60 seconds
      for time in CodeOfFlowBeta4.matchingLimits {
        if outdated == -1 && current_time > time + 60.0 {
          outdated = counter
        }
        counter = counter + 1
      }

      // If there are some expired matching times
      if outdated > -1 {
        // Save only valid matchin times
        if (outdated == 0) {
          CodeOfFlowBeta4.matchingLimits = []
          CodeOfFlowBeta4.matchingPlayers = []
        } else {
          CodeOfFlowBeta4.matchingLimits = CodeOfFlowBeta4.matchingLimits.slice(from: 0, upTo: outdated)
          CodeOfFlowBeta4.matchingPlayers = CodeOfFlowBeta4.matchingPlayers.slice(from: 0, upTo: outdated)
        }
      }

      if CodeOfFlowBeta4.matchingLimits.length >= 1 {
        // Pick the opponent from still matching players.
        let time = CodeOfFlowBeta4.matchingLimits.removeLast()
        let opponent = CodeOfFlowBeta4.matchingPlayers.removeLast()

        var is_first = false
        // Decides which is first
        if (CodeOfFlowBeta4.matchingLimits.length % 2 == 1) {
          is_first = true
        }

        CodeOfFlowBeta4.playerMatchingInfo[player_id] = PlayerMatchingStruct() // マッチング成立したのでnilで初期化
        CodeOfFlowBeta4.battleInfo[player_id] = BattleStruct(is_first: is_first, opponent: opponent, matched_time: current_time)
        CodeOfFlowBeta4.battleInfo[opponent] = BattleStruct(is_first: !is_first, opponent: player_id, matched_time: current_time)

        // charge the play fee (料金徴収)
        if let cyberScore = CodeOfFlowBeta4.playerList[player_id] {
          cyberScore.cyber_energy = cyberScore.cyber_energy - 30
          CodeOfFlowBeta4.playerList[player_id] = cyberScore
        }

        // charge the play fee (料金徴収)
        if let cyberScore = CodeOfFlowBeta4.playerList[opponent] {
          cyberScore.cyber_energy = cyberScore.cyber_energy - 30
          CodeOfFlowBeta4.playerList[opponent] = cyberScore
        }
        emit BattleSequence(sequence: 1, player_id: player_id, opponent: opponent)
      } else {
        // Put player_id in the matching list.
        CodeOfFlowBeta4.matchingLimits.append(current_time)
        CodeOfFlowBeta4.matchingPlayers.append(player_id)
        emit BattleSequence(sequence: 0, player_id: player_id, opponent: 0)
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

      if let playerMatchingInfo = CodeOfFlowBeta4.playerMatchingInfo[player_id] {
        playerMatchingInfo.marigan_cards = [
          [withdrawPosition1, withdrawPosition2, withdrawPosition3, withdrawPosition4],
          [withdrawPosition5, withdrawPosition6, withdrawPosition7, withdrawPosition8],
          [withdrawPosition9, withdrawPosition10, withdrawPosition11, withdrawPosition12],
          [withdrawPosition13, withdrawPosition14, withdrawPosition15, withdrawPosition16],
          [withdrawPosition17, withdrawPosition18, withdrawPosition19, withdrawPosition20]
        ]
        CodeOfFlowBeta4.playerMatchingInfo[player_id] = playerMatchingInfo // save
      }
    }

    /* 
    ** Game Start Transaction
    */
    pub fun game_start(player_id: UInt, drawed_cards: [UInt16]) {
      pre {
        drawed_cards.length == 4 : "Invalid argument."
        CodeOfFlowBeta4.battleInfo[player_id] != nil && CodeOfFlowBeta4.battleInfo[player_id]!.game_started == false : "Game already started."
      }
      var drawed_pos: [UInt8] = []
      if let playerMatchingInfo = CodeOfFlowBeta4.playerMatchingInfo[player_id] {
        if let deck = CodeOfFlowBeta4.playerDeck[player_id] {
        } else {
        }
        for arr in playerMatchingInfo.marigan_cards {
          if let deck = CodeOfFlowBeta4.playerDeck[player_id] {
            var arrCopy = deck.slice(from: 0, upTo: deck.length)
            let card_id1 = arrCopy.remove(at: arr[0])
            let card_id2 = arrCopy.remove(at: arr[1])
            let card_id3 = arrCopy.remove(at: arr[2])
            let card_id4 = arrCopy.remove(at: arr[3])
            if (card_id1 == drawed_cards[0] && card_id2 == drawed_cards[1] && card_id3 == drawed_cards[2] && card_id4 == drawed_cards[3]) {
              drawed_pos = arr
            }
          } else {
            var arrCopy = CodeOfFlowBeta4.starterDeck.slice(from: 0, upTo: CodeOfFlowBeta4.starterDeck.length)
            let card_id1 = arrCopy.remove(at: arr[0])
            let card_id2 = arrCopy.remove(at: arr[1])
            let card_id3 = arrCopy.remove(at: arr[2])
            let card_id4 = arrCopy.remove(at: arr[3])
            if (card_id1 == drawed_cards[0] && card_id2 == drawed_cards[1] && card_id3 == drawed_cards[2] && card_id4 == drawed_cards[3]) {
              drawed_pos = arr
            }
          }
        }
        if (drawed_pos.length == 0) {
          // Maybe the player did marigan more than 5 times. Set first cards to avoid errors.
          drawed_pos = playerMatchingInfo.marigan_cards[0]
        }
      }


      if let info = CodeOfFlowBeta4.battleInfo[player_id] {
        info.game_started = true
        if let deck = CodeOfFlowBeta4.playerDeck[player_id] {
          info.your_remain_deck = deck
        } else {
          info.your_remain_deck = CodeOfFlowBeta4.starterDeck
        }
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
          emit GameStart(first: player_id, second: info.opponent)
        } else {
          info.your_cp = 3
          emit GameStart(first: info.opponent, second: player_id)
        }
        // Save
        CodeOfFlowBeta4.battleInfo[player_id] = info

        let opponent = info.opponent
        if let opponentInfo = CodeOfFlowBeta4.battleInfo[opponent] {
          // if opponentInfo.last_time_turnend != nil { // これだとハンドがセットされないのでコメントアウト.
            opponentInfo.last_time_turnend = info.last_time_turnend // set time same time
            // opponentInfo.game_started = true
            opponentInfo.opponent_remain_deck = info.your_remain_deck.length
            opponentInfo.opponent_hand = info.your_hand.keys.length
            opponentInfo.opponent_cp = info.your_cp
            // Save
            CodeOfFlowBeta4.battleInfo[opponent] = opponentInfo
            emit BattleSequence(sequence: 2, player_id: player_id, opponent: opponent)
          // }
        }
      }
    }

    pub fun put_card_on_the_field(player_id: UInt, unit_card: {UInt8: UInt16}, enemy_skill_target: UInt8?, trigger_cards: {UInt8: UInt16?}, used_intercept_positions: [UInt8]) {
      for position in unit_card.keys {
        if CodeOfFlowBeta4.battleInfo[player_id]!.your_field_unit[position] != nil {
          panic("You can't put unit in this position!")
        }
      }
      for position in trigger_cards.keys {
        if CodeOfFlowBeta4.battleInfo[player_id]!.your_trigger_cards[position] != nil && CodeOfFlowBeta4.battleInfo[player_id]!.your_trigger_cards[position] != trigger_cards[position] {
          panic("Your trigger card is Tampered!")
        }
      }

      var target:UInt8 = 0
      if enemy_skill_target != nil {
        target = enemy_skill_target!
      }

      var your_hand_count: Int = 0
      if let info = CodeOfFlowBeta4.battleInfo[player_id] {
        // Match the consistency of the hand (take from the hand the amount moved to the trigger zone) (ハンドの整合性を合わせる(トリガーゾーンに移動した分、ハンドから取る))
        var isRemoved = false
        for trigger_position in trigger_cards.keys {
          if info.your_trigger_cards[trigger_position] != trigger_cards[trigger_position] && trigger_cards[trigger_position] != 0 {
            let card_id = trigger_cards[trigger_position]
            for hand_position in info.your_hand.keys {
                if card_id == info.your_hand[hand_position] && isRemoved == false {
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
          let unit = CodeOfFlowBeta4.cardInfo[card_id]!
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
                  // assess is this damage enough to beat the unit.
                  if let opponent = info.opponent_field_unit[opponent_position] {
                    let card_id: UInt16 = info.opponent_field_unit[opponent_position]!
                    let unit = CodeOfFlowBeta4.cardInfo[card_id]!
                    if Int(unit.bp) < info.opponent_field_unit_bp_amount_of_change[opponent_position]! * -1 {
                      // beat the opponent
                      info.opponent_field_unit[opponent_position] = nil
                    }
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
                    // assess is this damage enough to beat the unit.
                    if let opponent = info.opponent_field_unit[target] {
                      let card_id: UInt16 = info.opponent_field_unit[target]!
                      let unit = CodeOfFlowBeta4.cardInfo[card_id]!
                      if Int(unit.bp) < info.opponent_field_unit_bp_amount_of_change[target]! * -1 {
                        // beat the opponent
                        info.opponent_field_unit[target] = nil
                      }
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
              let trigger = CodeOfFlowBeta4.cardInfo[trigger_card_id]!
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
                        // assess is this damage enough to beat the unit.
                        if let opponent = info.opponent_field_unit[target] {
                          let card_id: UInt16 = info.opponent_field_unit[target]!
                          let unit = CodeOfFlowBeta4.cardInfo[card_id]!
                          if Int(unit.bp) < info.opponent_field_unit_bp_amount_of_change[target]! * -1 {
                            // beat the opponent
                            info.opponent_field_unit[target] = nil
                          }
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
                //---- Draw card ----
                if (trigger.skill.type_1 == 7) {
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
          info.your_field_unit_length = info.your_field_unit.keys.length
          if (speed_move_flg == true && !(info.turn == 1 && info.is_first_turn == true)) {
            info.your_field_unit_action[field_position] = 2 // 2: can attack, 1: can defence only, 0: nothing can do.
          } else {
            info.your_field_unit_action[field_position] = 1
          }
          info.your_cp = info.your_cp - unit.cost

          // Match the consistency of the hand (take from the hand the amount moved to the trigger zone) (ハンドの整合性を合わせる(トリガーゾーンに移動した分、ハンドから取る))
          var isRemoved2 = false
          for hand_position in info.your_hand.keys {
              if card_id == info.your_hand[hand_position] && isRemoved2 == false {
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

        // For the loading time.
        info.last_time_turnend = info.last_time_turnend! + 5.0

        // Save
        CodeOfFlowBeta4.battleInfo[player_id] = info

        let opponent = info.opponent
        if target > 0 && CodeOfFlowBeta4.battleInfo[opponent]!.your_field_unit[target] == nil {
          panic("You can not use skill for the target of this position!")
        }
        if let infoOpponent = CodeOfFlowBeta4.battleInfo[opponent] {
          infoOpponent.last_time_turnend = info.last_time_turnend
          infoOpponent.opponent_remain_deck = info.your_remain_deck.length
          infoOpponent.opponent_hand = your_hand_count
          infoOpponent.opponent_trigger_cards = info.your_trigger_cards.keys.length
          infoOpponent.opponent_field_unit = info.your_field_unit
          infoOpponent.opponent_field_unit_length = info.your_field_unit_length
          infoOpponent.opponent_field_unit_action = info.your_field_unit_action
          infoOpponent.your_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change
          infoOpponent.your_field_unit = info.opponent_field_unit
          // Process Trigger Lost
          if (lost_card_flg == true) {
            let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
            let decodedArray = blockCreatedAt.decodeHex()
            let pseudorandomNumber1 = decodedArray[decodedArray.length - 1]
            let withdrawPosition1 = pseudorandomNumber1 % (UInt8(infoOpponent.your_trigger_cards.keys.length) - 1)
            infoOpponent.your_trigger_cards[withdrawPosition1] = info.your_trigger_cards.remove(key: withdrawPosition1)
          }
          // Save
          CodeOfFlowBeta4.battleInfo[opponent] = infoOpponent
        }
      }

      // judge the winner
      self.judgeTheWinner(player_id: player_id)
    }

    pub fun attack(player_id: UInt, attack_unit: UInt8, enemy_skill_target: UInt8?, trigger_cards: {UInt8: UInt16}, used_intercept_positions: [UInt8]) {
      if CodeOfFlowBeta4.battleInfo[player_id]!.your_field_unit[attack_unit] == nil {
        panic("You have not set unit card in this position!")
      }
      for trigger_position in trigger_cards.keys {
        if !(CodeOfFlowBeta4.battleInfo[player_id]!.your_trigger_cards[trigger_position] == trigger_cards[trigger_position] || CodeOfFlowBeta4.battleInfo[player_id]!.your_trigger_cards[trigger_position] == nil) {
          // panic("Your trigger card is Tampered!") To avoid transaction failure by the coincident accident.
        }
      }
      for card_position in used_intercept_positions {
        if CodeOfFlowBeta4.battleInfo[player_id]!.your_trigger_cards[card_position] == nil {
          // panic("You have not set trigger card in this position!") TODO FIXME trigger_cards must be counted before check your_trigger_cards
        }
      }

      var attacking_card_to_enemy: AttackStruct? = nil
      var your_trigger_cards_count: Int = 0

      if let info = CodeOfFlowBeta4.battleInfo[player_id] {

        // Match the consistency of the hand (take from the hand the amount moved to the trigger zone) (ハンドの整合性を合わせる(トリガーゾーンに移動した分、ハンドから取る))
        for position in trigger_cards.keys {
          var isRemoved = false
          if info.your_trigger_cards[position] != trigger_cards[position] && trigger_cards[position] != 0 {
            let card_id = trigger_cards[position]
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
          if (trigger_cards[position] != 0) {
            info.your_trigger_cards[position] = trigger_cards[position]
          }
        }

        //////////////////////////////////////////////////
        // Process Battle Action START
        //////////////////////////////////////////////////
        var lost_card_flg = false
        var speed_move_flg = false
        let used_trigger_cards: [UInt16] = []
        info.your_field_unit_action[attack_unit] = 0 // 2: can attack, 1: can defence only, 0: nothing can do.

        ///////////////attribute evaluation///////////////
        let card_id: UInt16 = info.your_field_unit[attack_unit]!
        let unit = CodeOfFlowBeta4.cardInfo[card_id]!
        // trigger when the unit is attacking
        if (unit.skill.trigger_1 == 2) {
          //---- BP Pump ----
          if (unit.skill.type_1 == 2) {
            if let your_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change[attack_unit] {
              info.your_field_unit_bp_amount_of_change[attack_unit] = your_field_unit_bp_amount_of_change + Int(unit.skill.amount_1)
            } else {
              info.your_field_unit_bp_amount_of_change[attack_unit] = Int(unit.skill.amount_1)
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
              if enemy_skill_target != nil {
                target = enemy_skill_target!
              }
              if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[target] {
                info.opponent_field_unit_bp_amount_of_change[target] = opponent_field_unit_bp_amount_of_change + (-1 * Int(unit.skill.amount_1))
              } else {
                info.opponent_field_unit_bp_amount_of_change[target] = -1 * Int(unit.skill.amount_1)
              }
            // Only target which has no action right
            } else if (unit.skill.ask_1 == 2) {
              var target: UInt8 = 1
              if enemy_skill_target != nil {
                target = enemy_skill_target!
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
            if enemy_skill_target != nil {
              target = enemy_skill_target!
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

        // Used Intercept Card
        for card_position in used_intercept_positions {
          let trigger_card_id = info.your_trigger_cards[card_position]!
          let trigger = CodeOfFlowBeta4.cardInfo[trigger_card_id]!
          info.your_trigger_cards[card_position] = nil
          // trigger when the unit is attacking
          if (trigger.skill.trigger_1 == 2 || trigger.skill.trigger_1 == 5) {
            //---- BP Pump ----
            if (trigger.skill.type_1 == 2) {
              if let your_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change[attack_unit] {
                info.your_field_unit_bp_amount_of_change[attack_unit] = your_field_unit_bp_amount_of_change + Int(trigger.skill.amount_1)
              } else {
                info.your_field_unit_bp_amount_of_change[attack_unit] = Int(trigger.skill.amount_1)
              }
            }
            // Enemy Unit Target
            var target: UInt8 = 1
            if (enemy_skill_target != nil) {
              target = enemy_skill_target!
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
        ///////////////↑↑attribute evaluation↑↑///////////

        var unit_pump: UInt = 0
        if (info.your_field_unit_bp_amount_of_change[attack_unit] != nil) {
          unit_pump = UInt(info.your_field_unit_bp_amount_of_change[attack_unit]!)
        }
        attacking_card_to_enemy = AttackStruct(card_id: unit.card_id, position: attack_unit, bp: unit.bp, pump: unit_pump, field_position: attack_unit, used_trigger_cards: used_trigger_cards, attacked_time: getCurrentBlock().timestamp)
        //////////////////////////////////////////////////
        // Process Battle Action END
        //////////////////////////////////////////////////

        // If there is not unit in opponent field, automatically give damage to enemy.
        var hasEnemyUnit = false
        for opponent_position in info.opponent_field_unit.keys {
          hasEnemyUnit = true
        }

        if hasEnemyUnit == true {
          info.last_time_turnend = info.last_time_turnend! + 10.0
        } else {
          info.opponent_life = info.opponent_life - 1
          // For the loading time.
          info.last_time_turnend = info.last_time_turnend! + 5.0
        }

        info.your_attacking_card = attacking_card_to_enemy
        // save
        CodeOfFlowBeta4.battleInfo[player_id] = info

        let opponent = info.opponent
        if (enemy_skill_target != nil) {
          if CodeOfFlowBeta4.battleInfo[opponent]!.your_field_unit[enemy_skill_target!] == nil {
            panic("You can not use skill for the target of this position!")
          }
        }

        if let infoOpponent = CodeOfFlowBeta4.battleInfo[opponent] {
          infoOpponent.last_time_turnend = info.last_time_turnend
          infoOpponent.enemy_attacking_card = attacking_card_to_enemy
          infoOpponent.opponent_life = info.opponent_life
          infoOpponent.opponent_remain_deck = info.your_remain_deck.length
          infoOpponent.opponent_trigger_cards = info.your_trigger_cards.keys.length
          infoOpponent.opponent_field_unit = info.your_field_unit
          infoOpponent.opponent_field_unit_length = info.your_field_unit_length
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
          CodeOfFlowBeta4.battleInfo[opponent] = infoOpponent
        }
      }
    }

    pub fun defence_action(player_id: UInt, opponent_defend_position: UInt8?, your_used_intercept_positions: [UInt8], opponent_used_intercept_positions: [UInt8]) {
      for card_position in your_used_intercept_positions {
        if CodeOfFlowBeta4.battleInfo[player_id]!.your_trigger_cards[card_position] == nil {
          // panic("You have not set trigger card in this position!") TODO FIXME trigger_cards must be counted before check your_trigger_cards
        }
      }

      if let info = CodeOfFlowBeta4.battleInfo[player_id] {
        if (info.is_first == info.is_first_turn && info.your_attacking_card != nil) ||
          (info.is_first != info.is_first_turn && info.your_attacking_card != nil) {
          //////////////////////////////////////////////////
          ///////////////attribute evaluation///////////////
          //////////////////////////////////////////////////
          if opponent_defend_position != nil {
            if info.opponent_field_unit[opponent_defend_position!] != nil {
              let card_id: UInt16 = info.opponent_field_unit[opponent_defend_position!]!
              let unit = CodeOfFlowBeta4.cardInfo[card_id]!

              // trigger when the unit is blocking
              if (unit.skill.trigger_1 == 3) {
                //---- BP Pump ----
                if (unit.skill.type_1 == 2) {
                  if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[opponent_defend_position!] {
                    info.opponent_field_unit_bp_amount_of_change[opponent_defend_position!] = opponent_field_unit_bp_amount_of_change + Int(unit.skill.amount_1)
                  } else {
                    info.opponent_field_unit_bp_amount_of_change[opponent_defend_position!] = Int(unit.skill.amount_1)
                  }
                }
              }

              // Used Intercept Card
              for card_position in opponent_used_intercept_positions {
                let trigger_card_id = info.your_trigger_cards[card_position]!
                let trigger = CodeOfFlowBeta4.cardInfo[trigger_card_id]!
                info.your_trigger_cards[card_position] = nil

                // trigger when the unit is blocking
                if (trigger.skill.trigger_1 == 3 || unit.skill.trigger_1 == 5) {
                  //---- BP Pump ----
                  if (trigger.skill.type_1 == 2) {
                    if let opponent_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change[opponent_defend_position!] {
                      info.opponent_field_unit_bp_amount_of_change[opponent_defend_position!] = opponent_field_unit_bp_amount_of_change + Int(trigger.skill.amount_1)
                    } else {
                      info.opponent_field_unit_bp_amount_of_change[opponent_defend_position!] = Int(trigger.skill.amount_1)
                    }
                  }
                }
              }
              // Used Intercept Card
              for card_position in your_used_intercept_positions {
                let trigger_card_id = info.your_trigger_cards[card_position]!
                let trigger = CodeOfFlowBeta4.cardInfo[trigger_card_id]!
                let attack_unit = info.your_attacking_card!.position

                info.your_trigger_cards[card_position] = nil
                // trigger when the unit is attacking
                if (trigger.skill.trigger_1 == 2 || trigger.skill.trigger_1 == 5) {
                  //---- BP Pump ----
                  if (trigger.skill.type_1 == 2) {
                    if let your_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change[attack_unit] {
                      info.your_field_unit_bp_amount_of_change[attack_unit] = your_field_unit_bp_amount_of_change + Int(trigger.skill.amount_1)
                    } else {
                      info.your_field_unit_bp_amount_of_change[attack_unit] = Int(trigger.skill.amount_1)
                    }
                  }
                }
              }
              //////////////////////////////////////////////////
              ///////////////↑↑attribute evaluation↑↑///////////
              //////////////////////////////////////////////////
            }

            //////////////// Battle Result ////////////////
            // when each unit's position is matched
            if info.opponent_field_unit[opponent_defend_position!] != nil && CodeOfFlowBeta4.cardInfo[info.opponent_field_unit[opponent_defend_position!]!] != nil {
              let unit = CodeOfFlowBeta4.cardInfo[info.opponent_field_unit[opponent_defend_position!]!]!
              var pump = 0
              if info.opponent_field_unit_bp_amount_of_change[opponent_defend_position!] != nil {
                pump = info.opponent_field_unit_bp_amount_of_change[opponent_defend_position!]!
              }
              if Int(unit.bp) + pump < Int(info.your_attacking_card!.bp + info.your_attacking_card!.pump) {
                info.opponent_field_unit[opponent_defend_position!] = nil
              } else if Int(unit.bp) + pump == Int(info.your_attacking_card!.bp + info.your_attacking_card!.pump) {
                info.your_field_unit[info.your_attacking_card!.field_position] = nil
                info.opponent_field_unit[opponent_defend_position!] = nil
              } else {
                info.your_field_unit[opponent_defend_position!] = nil
              }
              info.your_field_unit_length = info.your_field_unit.keys.length
            }
          } else {
            info.opponent_life = info.opponent_life - 1
          }
          info.last_time_turnend = info.last_time_turnend! + (info.your_attacking_card!.attacked_time - info.last_time_turnend!)
          info.your_attacking_card = nil

          // save
          CodeOfFlowBeta4.battleInfo[player_id] = info
          ////////////// ↑↑Battle Result↑↑ //////////////

          var handCnt = 0
          let handPositions: [UInt8] = [1, 2, 3, 4, 5 ,6, 7]
          for hand_position in handPositions {
            if info.your_hand[hand_position] != nil {
              handCnt = handCnt + 1
            }
          }

          let opponent = info.opponent
          if let infoOpponent = CodeOfFlowBeta4.battleInfo[opponent] {
            infoOpponent.last_time_turnend = info.last_time_turnend
            infoOpponent.enemy_attacking_card = nil
            infoOpponent.opponent_hand = handCnt
            infoOpponent.opponent_remain_deck = info.your_remain_deck.length
            infoOpponent.opponent_trigger_cards = info.your_trigger_cards.keys.length
            infoOpponent.opponent_field_unit = info.your_field_unit
            infoOpponent.opponent_field_unit_length = info.your_field_unit_length
            infoOpponent.opponent_field_unit_action = info.your_field_unit_action
            infoOpponent.opponent_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change
            infoOpponent.your_field_unit = info.opponent_field_unit
            infoOpponent.your_field_unit_action = info.opponent_field_unit_action
            infoOpponent.your_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change
            infoOpponent.opponent_cp = info.your_cp
            CodeOfFlowBeta4.battleInfo[opponent] = infoOpponent
          }
        }
      }

      // judge the winner
      self.judgeTheWinner(player_id: player_id)
    }

    pub fun turn_change(player_id: UInt, from_opponent: Bool) {
      if let info = CodeOfFlowBeta4.battleInfo[player_id] {
        // Check is turn already changed.
        if info.is_first != info.is_first_turn {
          return;
        }

        info.last_time_turnend = getCurrentBlock().timestamp

        // Set Field Unit Actions To Defence Only
        for position in info.your_field_unit.keys {
          info.your_field_unit_action[position] = 1 // 2: can attack, 1: can defence only, 0: nothing can do.
          if info.your_field_unit[position] != nil && info.your_field_unit[position] != 0 {
            let card_id: UInt16 = info.your_field_unit[position]!
            let unit = CodeOfFlowBeta4.cardInfo[card_id]!
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

        // Process Turn Change
        info.last_time_turnend = getCurrentBlock().timestamp
        info.is_first_turn = !info.is_first_turn
        if (info.is_first_turn) {
          info.turn = info.turn + 1
        }
        info.card_draw_in_this_turn = false

        let opponent = info.opponent
        if let infoOpponent = CodeOfFlowBeta4.battleInfo[opponent] {

          // Turn Change
          infoOpponent.last_time_turnend = info.last_time_turnend
          infoOpponent.is_first_turn = !infoOpponent.is_first_turn
          infoOpponent.turn = info.turn
          infoOpponent.opponent_remain_deck = info.your_remain_deck.length
          infoOpponent.opponent_trigger_cards = info.your_trigger_cards.keys.length
          infoOpponent.opponent_field_unit = info.your_field_unit
          infoOpponent.opponent_field_unit_length = info.your_field_unit_length
          infoOpponent.opponent_field_unit_action = info.your_field_unit_action
          infoOpponent.opponent_field_unit_bp_amount_of_change = info.your_field_unit_bp_amount_of_change
          infoOpponent.your_field_unit_bp_amount_of_change = info.opponent_field_unit_bp_amount_of_change

          // if defence action is not done..
          if infoOpponent.enemy_attacking_card != nil {
            infoOpponent.your_life = infoOpponent.your_life - 1
            infoOpponent.enemy_attacking_card = nil
          }

          // draw card
          let blockCreatedAt = getCurrentBlock().timestamp.toString().slice(from: 0, upTo: 10)
          let decodedArray = blockCreatedAt.decodeHex()

          let pseudorandomNumber1 = decodedArray[decodedArray.length - 1] // as! Int
          let pseudorandomNumber2 = decodedArray[decodedArray.length - 2] // as! Int

          let cardRemainCounts = infoOpponent.your_remain_deck.length
          let withdrawPosition1 = Int(pseudorandomNumber1) % (cardRemainCounts - 1)
          let withdrawPosition2 = Int(pseudorandomNumber2) % (cardRemainCounts - 2)
          var isSetCard1 = false
          var isSetCard2 = false
          var handCnt = 0
          let handPositions: [UInt8] = [1, 2, 3, 4, 5 ,6, 7]
          for hand_position in handPositions {
            // To prevent double transaction
            if infoOpponent.card_draw_in_this_turn == false {
              if infoOpponent.your_hand[hand_position] == nil && isSetCard1 == false {
                infoOpponent.your_hand[hand_position] = infoOpponent.your_remain_deck.remove(at: withdrawPosition1)
                isSetCard1 = true
              }
              if infoOpponent.your_hand[hand_position] == nil && isSetCard2 == false {
                infoOpponent.your_hand[hand_position] = infoOpponent.your_remain_deck.remove(at: withdrawPosition2)
                isSetCard2 = true
              }
            }

            if infoOpponent.your_hand[hand_position] != nil {
              handCnt = handCnt + 1
            }
          }
          infoOpponent.card_draw_in_this_turn = true
          infoOpponent.your_field_unit_bp_amount_of_change = {} // Damage are reset
          infoOpponent.opponent_field_unit_bp_amount_of_change = {}

          // Recover Field Unit Actions
          for position in infoOpponent.your_field_unit_action.keys {
            infoOpponent.your_field_unit_action[position] = 2 // 2: can attack, 1: can defence only, 0: nothing can do.
          }
          // Recover CP
          if infoOpponent.turn <= 6 {
            infoOpponent.your_cp = infoOpponent.turn + 1
          } else {
            infoOpponent.your_cp = 7
          }
          if (infoOpponent.turn == 1 && !infoOpponent.is_first) {
            infoOpponent.your_cp = 3
          }
          info.last_time_turnend = infoOpponent.last_time_turnend // set time same time
          info.opponent_hand = handCnt
          info.opponent_remain_deck = infoOpponent.your_remain_deck.length
          info.opponent_trigger_cards = infoOpponent.your_trigger_cards.keys.length
          info.opponent_field_unit = infoOpponent.your_field_unit
          info.opponent_field_unit_length = infoOpponent.your_field_unit_length
          info.opponent_field_unit_action = infoOpponent.your_field_unit_action
          info.opponent_field_unit_bp_amount_of_change = infoOpponent.your_field_unit_bp_amount_of_change
          info.opponent_cp = infoOpponent.your_cp

          CodeOfFlowBeta4.battleInfo[opponent] = infoOpponent
        }
        // save
        CodeOfFlowBeta4.battleInfo[player_id] = info
      }

      // judge the winner
      self.judgeTheWinner(player_id: player_id)
    }

    pub fun surrender(player_id: UInt) {
      if CodeOfFlowBeta4.battleInfo[player_id] != nil {
        let opponent = CodeOfFlowBeta4.battleInfo[player_id]!.opponent
        CodeOfFlowBeta4.battleInfo.remove(key: player_id)
        CodeOfFlowBeta4.playerList[player_id]!.score.append({getCurrentBlock().timestamp: 0})
        if (CodeOfFlowBeta4.battleInfo[opponent] != nil) {
          CodeOfFlowBeta4.battleInfo.remove(key: opponent)
          CodeOfFlowBeta4.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 1})
        }
        CodeOfFlowBeta4.playerMatchingInfo[player_id] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
        CodeOfFlowBeta4.playerMatchingInfo[opponent] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
        emit BattleSequence(sequence: 3, player_id: opponent, opponent: player_id)
        // Game Reward
        let reward <- CodeOfFlowBeta4.account.borrow<&{FungibleToken.Provider}>(from: /storage/flowTokenVault)!.withdraw(amount: 0.5) as! @FlowToken.Vault
        CodeOfFlowBeta4.PlayerFlowTokenVault[opponent]!.borrow()!.deposit(from: <- reward)
      }
    }

    pub fun judgeTheWinner(player_id: UInt) :Bool {
      pre {
        CodeOfFlowBeta4.battleInfo[player_id] != nil : "This guy doesn't do match."
      }

      if let info = CodeOfFlowBeta4.battleInfo[player_id] {
        if (info.turn > 10) {
          if (info.your_life > info.opponent_life || (info.your_life == info.opponent_life && !info.is_first_turn)) {
            let opponent = info.opponent
            CodeOfFlowBeta4.battleInfo.remove(key: player_id)
            CodeOfFlowBeta4.battleInfo.remove(key: opponent)
            CodeOfFlowBeta4.playerList[player_id]!.score.append({getCurrentBlock().timestamp: 1})
            CodeOfFlowBeta4.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 0})
            CodeOfFlowBeta4.playerMatchingInfo[player_id] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
            CodeOfFlowBeta4.playerMatchingInfo[opponent] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
            emit BattleSequence(sequence: 3, player_id: player_id, opponent: opponent)
            // Game Reward
            let reward <- CodeOfFlowBeta4.account.borrow<&{FungibleToken.Provider}>(from: /storage/flowTokenVault)!.withdraw(amount: 0.5) as! @FlowToken.Vault
            CodeOfFlowBeta4.PlayerFlowTokenVault[player_id]!.borrow()!.deposit(from: <- reward)
            return true
          } else {
            let opponent = info.opponent
            CodeOfFlowBeta4.battleInfo.remove(key: player_id)
            CodeOfFlowBeta4.battleInfo.remove(key: opponent)
            CodeOfFlowBeta4.playerList[player_id]!.score.append({getCurrentBlock().timestamp: 0})
            CodeOfFlowBeta4.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 1})
            CodeOfFlowBeta4.playerMatchingInfo[player_id] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
            CodeOfFlowBeta4.playerMatchingInfo[opponent] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
            emit BattleSequence(sequence: 3, player_id: opponent, opponent: player_id)
            // Game Reward
            let reward <- CodeOfFlowBeta4.account.borrow<&{FungibleToken.Provider}>(from: /storage/flowTokenVault)!.withdraw(amount: 0.5) as! @FlowToken.Vault
            CodeOfFlowBeta4.PlayerFlowTokenVault[opponent]!.borrow()!.deposit(from: <- reward)
            return true
          }
        }
        if (info.your_life == 0) {
          let opponent = info.opponent
          CodeOfFlowBeta4.battleInfo.remove(key: player_id)
          CodeOfFlowBeta4.battleInfo.remove(key: opponent)
          CodeOfFlowBeta4.playerList[player_id]!.score.append({getCurrentBlock().timestamp: 1})
          CodeOfFlowBeta4.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 0})
          CodeOfFlowBeta4.playerMatchingInfo[player_id] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
          CodeOfFlowBeta4.playerMatchingInfo[opponent] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
          emit BattleSequence(sequence: 3, player_id: player_id, opponent: opponent)
          // Game Reward
          let reward <- CodeOfFlowBeta4.account.borrow<&{FungibleToken.Provider}>(from: /storage/flowTokenVault)!.withdraw(amount: 0.5) as! @FlowToken.Vault
          CodeOfFlowBeta4.PlayerFlowTokenVault[player_id]!.borrow()!.deposit(from: <- reward)
          return true
        } else if (info.opponent_life == 0) {
          let opponent = info.opponent
          CodeOfFlowBeta4.battleInfo.remove(key: player_id)
          CodeOfFlowBeta4.battleInfo.remove(key: opponent)
          CodeOfFlowBeta4.playerList[player_id]!.score.append({getCurrentBlock().timestamp: 0})
          CodeOfFlowBeta4.playerList[opponent]!.score.append({getCurrentBlock().timestamp: 1})
          CodeOfFlowBeta4.playerMatchingInfo[player_id] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
          CodeOfFlowBeta4.playerMatchingInfo[opponent] = PlayerMatchingStruct() // ゲームが終了したのでnilで初期化
          emit BattleSequence(sequence: 3, player_id: opponent, opponent: player_id)
          // Game Reward
          let reward <- CodeOfFlowBeta4.account.borrow<&{FungibleToken.Provider}>(from: /storage/flowTokenVault)!.withdraw(amount: 0.5) as! @FlowToken.Vault

          CodeOfFlowBeta4.PlayerFlowTokenVault[opponent]!.borrow()!.deposit(from: <- reward)
          return true
        }
      }
      return false
    }

    init() {
    }
  }

  // [Interface] IPlayerPublic
  pub resource interface IPlayerPublic {
    pub fun get_current_status(): AnyStruct
    pub fun get_marigan_cards(player_id: UInt): [[UInt16]]
    pub fun get_player_deck(player_id: UInt): [UInt16]
    pub fun get_players_score(): [CyberScoreStruct]
    pub fun buy_en(payment: @FlowToken.Vault)
  }

  // [Interface] IPlayerPrivate
  pub resource interface IPlayerPrivate {
  }

  // [Resource] Player
  pub resource Player: IPlayerPublic, IPlayerPrivate {
    pub let player_id: UInt
    pub let nickname: String

    pub fun get_marigan_cards(player_id: UInt): [[UInt16]] {
      if let playerMatchingInfo = CodeOfFlowBeta4.playerMatchingInfo[player_id] {
        var ret_arr: [[UInt16]] = []
        for i in [0, 1, 2, 3, 4] {
          if let deck = CodeOfFlowBeta4.playerDeck[player_id] {
            var tmp = deck.slice(from: 0, upTo: deck.length)
            ret_arr.append([tmp.remove(at: playerMatchingInfo.marigan_cards[i][0]), tmp.remove(at: playerMatchingInfo.marigan_cards[i][1]), tmp.remove(at: playerMatchingInfo.marigan_cards[i][2]), tmp.remove(at: playerMatchingInfo.marigan_cards[i][3])])
          } else {
            var tmp = CodeOfFlowBeta4.starterDeck.slice(from: 0, upTo: CodeOfFlowBeta4.starterDeck.length)
            ret_arr.append([tmp.remove(at: playerMatchingInfo.marigan_cards[i][0]), tmp.remove(at: playerMatchingInfo.marigan_cards[i][1]), tmp.remove(at: playerMatchingInfo.marigan_cards[i][2]), tmp.remove(at: playerMatchingInfo.marigan_cards[i][3])])
          }
        }

        return ret_arr
      }
      return []
    }

    pub fun get_player_deck(player_id: UInt): [UInt16] {
      if let deck = CodeOfFlowBeta4.playerDeck[player_id] {
        return deck
      } else {
        return CodeOfFlowBeta4.starterDeck;
      }
    }

    pub fun get_players_score(): [CyberScoreStruct] {
      let retArr: [CyberScoreStruct] = []
      retArr.append(CodeOfFlowBeta4.playerList[self.player_id]!)
      if let info = CodeOfFlowBeta4.battleInfo[self.player_id] {
        let opponent = info.opponent
        retArr.append(CodeOfFlowBeta4.playerList[opponent]!)
      }
      return retArr
    }

    pub fun get_current_status(): AnyStruct {
      if let info = CodeOfFlowBeta4.battleInfo[self.player_id] {
        return info
      }
      if let obj = CodeOfFlowBeta4.playerMatchingInfo[self.player_id] {
        return obj.lastTimeMatching
      }
      return nil
    }

    pub fun buy_en(payment: @FlowToken.Vault) {
      pre {
        payment.balance == 1.0: "payment is not 1FLOW coin."
        CodeOfFlowBeta4.playerList[self.player_id] != nil: "CyberScoreStruct not found."
      }
      CodeOfFlowBeta4.FlowTokenVault.borrow()!.deposit(from: <- payment)
      if let cyberScore = CodeOfFlowBeta4.playerList[self.player_id] {
        cyberScore.cyber_energy = cyberScore.cyber_energy + 100
        CodeOfFlowBeta4.playerList[self.player_id] = cyberScore
      }
    }

    init(nickname: String) {
      CodeOfFlowBeta4.totalPlayers = CodeOfFlowBeta4.totalPlayers + 1
      self.player_id = CodeOfFlowBeta4.totalPlayers
      self.nickname = nickname

      CodeOfFlowBeta4.playerList[self.player_id] = CyberScoreStruct(player_name: nickname)
      emit PlayerRegistered(player_id: self.player_id)
    }
  }

  pub fun createPlayer(nickname: String, flow_vault_receiver: Capability<&FlowToken.Vault{FungibleToken.Receiver}>): @CodeOfFlowBeta4.Player {
    let player <- create Player(nickname: nickname)

    if (CodeOfFlowBeta4.PlayerFlowTokenVault[player.player_id] == nil) {
      CodeOfFlowBeta4.PlayerFlowTokenVault[player.player_id] = flow_vault_receiver
    }
    return <- player
  }

  pub fun getCardInfo(): {UInt16: CardStruct} {
    return self.cardInfo
  }

  pub fun getMatchingLimits(): [UFix64] {
    return self.matchingLimits
  }

  pub fun getStarterDeck(): [UInt16] {
    return self.starterDeck
  }

  init () {
    self.FlowTokenVault = self.account.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
    self.PlayerFlowTokenVault = {}

    self.AdminStoragePath = /storage/CodeOfFlowBeta4Admin
    self.account.save( <- create Admin(), to: self.AdminStoragePath) // grant admin resource
    self.PlayerStoragePath = /storage/CodeOfFlowBeta4Player
    self.PlayerPublicPath = /public/CodeOfFlowBeta4Player
    self.totalPlayers = 0
    self.cardInfo = {
      1: CardStruct(card_id: 1, name: "Hound", bp: 1000, cost: 0, type: 0, category: 0, skill: Skill(description: "No Skill", triggers: [0], asks: [0], types: [0], amounts: [0], skills: [])),
      2: CardStruct(card_id: 2, name: "Fighter", bp: 3000, cost: 1, type: 0, category: 0, skill: Skill(description: "When this unit attacks, this unit's BP is +2000 until end of turn.", triggers: [2], asks: [0], types: [2], amounts: [2000], skills: [])),
      3: CardStruct(card_id: 3, name: "Lancer", bp: 5000, cost: 2, type: 0, category: 0, skill: Skill(description: "When this unit attacks, choose an opponent's unit. Deal 1000 damage to it.", triggers: [2], asks: [1], types: [1], amounts: [1000], skills: [])),
      4: CardStruct(card_id: 4, name: "HellDog", bp: 6000, cost: 3, type: 0, category: 0, skill: Skill(description: "When this unit enters the field, a card in the opponent's trigger zone is randomly destroyed.", triggers: [1], asks: [0], types: [3], amounts: [1], skills: [])),
      5: CardStruct(card_id: 5, name: "Arty", bp: 2000, cost: 2, type: 0, category: 0, skill: Skill(description: "This unit is not affected by action restrictions for the turn it enters the field.", triggers: [1], asks: [0], types: [11], amounts: [0], skills: [])),
      6: CardStruct(card_id: 6, name: "Valkyrie", bp: 3000, cost: 3, type: 0, category: 0, skill: Skill(description: "This unit is not blocked.", triggers: [4], asks: [0], types: [12], amounts: [0], skills: [])),
      7: CardStruct(card_id: 7, name: "Lilim", bp: 4000, cost: 4, type: 0, category: 0, skill: Skill(description: "When this unit enters the field, choose one of your opponent's units. Deal 4000 damage to it. \nWhen this unit attacks, destroy a card in your opponent's Trigger Zone at random.", triggers: [1,2], asks: [1,0], types: [1,3], amounts: [4000,1], skills: [])),
      8: CardStruct(card_id: 8, name: "Belial", bp: 7000, cost: 7, type: 0, category: 0, skill: Skill(description: "When this unit enters the field, it deals 3000 damage to all of your opponent's units.", triggers: [1], asks: [0], types: [4], amounts: [3000], skills: [])),
      9: CardStruct(card_id: 9, name: "Sohei", bp: 2000, cost: 1, type: 1, category: 0, skill: Skill(description: "When this unit blocks, this unit's BP is +2000 until end of turn.", triggers: [3], asks: [0], types: [2], amounts: [2000], skills: [])),
      10: CardStruct(card_id: 10, name: "LionDog", bp: 1000, cost: 0, type: 1, category: 0, skill: Skill(description: "No Skill", triggers: [0], asks: [0], types: [0], amounts: [0], skills: [])),
      11: CardStruct(card_id: 11, name: "Allie", bp: 2000, cost: 1, type: 1, category: 0, skill: Skill(description: "When this unit enters the field, choose one of your opponent's units. Consume it's right of action.", triggers: [1], asks: [1], types: [5], amounts: [0], skills: [])),
      13: CardStruct(card_id: 13, name: "Caim", bp: 5000, cost: 3, type: 1, category: 0, skill: Skill(description: "When this unit enters the field, you draw a card.", triggers: [1], asks: [0], types: [7], amounts: [1], skills: [])),
      14: CardStruct(card_id: 14, name: "Limaru", bp: 6000, cost: 3, type: 1, category: 0, skill: Skill(description: "At the end of your turn, restore this unit's right of action.", triggers: [4], asks: [0], types: [8], amounts: [0], skills: [])),
      15: CardStruct(card_id: 15, name: "Roin", bp: 3000, cost: 2, type: 1, category: 0, skill: Skill(description: "When this unit blocks, this unit's BP is +2000 until end of turn.", triggers: [3], asks: [0], types: [2], amounts: [2000], skills: [])),
      16: CardStruct(card_id: 16, name: "Rairyu", bp: 6000, cost: 5, type: 1, category: 0, skill: Skill(description: "When this unit enters the field, choose one of your opponent's acted-up units. Deal 7000 damage to it.", triggers: [1], asks: [2], types: [1], amounts: [7000], skills: [])),
      17: CardStruct(card_id: 17, name: "Drive", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "When your unit attacks, its BP is +2000 until end of turn.", triggers: [2], asks: [0], types: [2], amounts: [3000], skills: [])),
      18: CardStruct(card_id: 18, name: "Canon", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "When your unit enters the field, choose one of your opponent's units. Deal 1000 damage to it.", triggers: [1], asks: [1], types: [1], amounts: [1000], skills: [])),
      19: CardStruct(card_id: 19, name: "Merchant", bp: 0, cost: 0, type: 4, category: 1, skill: Skill(description: "When your unit enters the field, you draw a card.", triggers: [1], asks: [0], types: [7], amounts: [1], skills: [])),
      20: CardStruct(card_id: 20, name: "Breaker", bp: 0, cost: 1, type: 0, category: 2, skill: Skill(description: "When your unit enters the field, choose one of your opponent's acted-up units. Deal 3000 damage to it.", triggers: [1], asks: [1], types: [1], amounts: [3000], skills: [])),
      21: CardStruct(card_id: 21, name: "Imperiale", bp: 0, cost: 0, type: 0, category: 2, skill: Skill(description: "When your unit enters the field, grant that unit the ability to be unaffected by action restrictions for the turn it enters the field.(unless it's first turn)", triggers: [1], asks: [0], types: [11], amounts: [0], skills: [])),
      22: CardStruct(card_id: 22, name: "Dainsleif", bp: 0, cost: 1, type: 0, category: 2, skill: Skill(description: "When your unit attacks, destroy a card in your opponent's trigger zone at random.", triggers: [2], asks: [0], types: [3], amounts: [1], skills: [])),
      23: CardStruct(card_id: 23, name: "Photon", bp: 0, cost: 0, type: 1, category: 2, skill: Skill(description: "When your unit enters the field, choose one of your opponent's acted-up units. Deal 3000 damage to it.", triggers: [1], asks: [2], types: [1], amounts: [3000], skills: [])),
      24: CardStruct(card_id: 24, name: "Titan's Lock", bp: 0, cost: 0, type: 1, category: 2, skill: Skill(description: "When your unit attacks, choose one of your opponent's units. Consume it's right of action.", triggers: [2], asks: [1], types: [5], amounts: [1], skills: [])),
      25: CardStruct(card_id: 25, name: "Judge", bp: 0, cost: 6, type: 1, category: 2, skill: Skill(description: "Consumes the right of action of all opposing units.", triggers: [2], asks: [0], types: [5], amounts: [5], skills: [])),
      26: CardStruct(card_id: 26, name: "Hero's Sword", bp: 0, cost: 0, type: 4, category: 2, skill: Skill(description: "When your unit fights, it gets +2000 BP until end of turn.", triggers: [5], asks: [0], types: [2], amounts: [2000], skills: []))
    }
    self.starterDeck = [1, 1, 2, 2, 3, 3, 4, 4, 5, 6, 7, 8, 9, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26]
    self.battleInfo = {}
    self.matchingLimits = []
    self.matchingPlayers = []
    self.playerList = {}
    self.playerDeck = {}
    self.playerMatchingInfo = {}
  }
}