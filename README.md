# Code Of Joker on the Blockchain!!!!

Can you believe it? My most favorite game is now live on the blockchain.<br>
Play fee is just 0.505FLOW (0.005FLOW is used for network usage), and surprisingly if you won on the game, you can get 1.0FLOW!<br>
Wow, you can become literally a pro-gamer! You can live with just gaming everyday!<br>
The one game is about 5~6 minutes. So if you won the game continually an hour, you can get about 5FLOW! WoHoo!<br>
This is the homage to the SEGA’s game, Code Of Joker which run 2013-7-11 - 2019-7-11.<br>
The game system is very similar to v1.0.0 of Code Of Joker. (But majority are not implemented, of course.)<br>
If you don’t know COJ, please take a look at well-played game’s YouTube 👇<br>
https://m.youtube.com/watch?v=tYioSA10Ckc<br>

# The game name is *CODE-Of-Flow*

This game is fully built on Flow Blockchain.

Proof(Smart Contract): https://github.com/temt-ceo/game-built-on-flow/blob/hackathon/cadence/contracts/CODEOfFlow.cdc<br>
Proof(Smart Contract Calling File): https://github.com/temt-ceo/game-built-on-flow/blob/hackathon/pages/index.vue

### You can play this CODE-Of-Flow Game in smartphone or Mac or PC.
URL is https://hackathon.d8gpbl0qw42np.amplifyapp.com/

<img width="210" alt="CODE-Of-Flow" src="https://user-images.githubusercontent.com/58613670/221454777-4163b675-e8ca-44db-9f93-21ff93c4393b.png">

### Tutorials
PC: <br>
SmartPhone(portrait): <br>
SmartPhone(landscape): <br>
### How it works
System Background is like below image.<br>
<img width="510" alt="system_arkitecture" src="https://user-images.githubusercontent.com/58613670/221802473-dd0572b7-54f3-41fd-8832-5267d59f8ec7.png">
<br>This is the idea I planed to create for whole game APIs. But AWS's Lambda has the cron job function which is only available for one minite or longer.<br>
If I need 3 seconds each GraphQL subscription API, I have to set AWS's Step Function. But unfortunately this is created while the hackathon period, so I wanted the system more simple.<br>
This GraphQL api is only used for the notifications to notify game users the useful informations using Blockchain Events.

# Extending the ecosystem
I am planning to share the informations how I implemented the source code written in Smart Contract Language Cadence n Linkedin.<br>
This includes:<br><br>
*matchingStart* transaction: Matching function fully implemented on the Smart Contract, How to create Pseudorandom Number on the Smart Contract<br>
*get_current_status* script: This is the core script of this game, which returns the battle information if the game is started or returns the last matching timestamp if the game not started.<br>
*game_start* Transaction<br>
*turn_change* Transaction<br>
*put_card_on_the_field* Transaction<br>
*start_your_turn_and_draw_two_cards* Transaction<br>
*claimWin* Transaction<br>
*surrendar* Transaction<br><br>
**So if you are interested, please read articles. URL is　👉 https://www.linkedin.com/in/tahara-takashi-em-technology/recent-activity/**

#### I have already shared the interesting develop informations while this Hackathon.
Day 1: Matching with opponents is done using blockchain<br>
LinkedIn article(EN): <br>
LinkedIn article(JP): <br><br>
Day 2: <br>
LinkedIn article(EN): <br>
LinkedIn article(JP): <br><br>
Day 3: <br>
LinkedIn article(EN): <br>
LinkedIn article(JP): <br><br>
Day 4: <br>
LinkedIn article(EN): <br>
LinkedIn article(JP): <br><br>
Day 5: <br>
LinkedIn article(EN): <br>
LinkedIn article(JP): <br><br>
Day 6: <br>
LinkedIn article(EN): <br>
LinkedIn article(JP): <br><br>
<br>
And .. new book titled "How to create a game on Flow Blockchain" will be published within months!<br>
