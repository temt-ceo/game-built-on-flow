export default {
  book_title1: "You can build a blockchain app in a day! You'll learn practical Cadence programming! The definitive Cadence reference !",
  book_title2: 'With Nuxt3 and Amplify a thorough and detailed explanation, let building a Blockchain Game begin!',
  book_title3: 'Flow Dapp Complete Creation Manual',
  book_title4: 'Get a detailed reference on the smart contract language Cadence!!',
  book_title5: "Let's make the blockchain game development easier than ever with AppSync! 🎮",
  page1_1: `Preface

  What does blockchain app development look like?
  
  Flow Blockchain has a wallet called Blocto, which makes it very easy to transfer Crypto Currency and create NFT wallets.

  The ease of transferring money and the instant creation of wallets means that money and goods can be exchanged with people all over the world in no time. When I published this book, I can easily say, "I want to pay you an honorarium, so give me your Blocto wallet address," and the transaction actually takes about 5 seconds and is completely stress-free.

  It's hard to find anything to stress about because Flow is an extremely secure, accident-free, and transparent blockchain.

  The Flow Blockchain website says it is developer friendly. This is true, and when you develop on Play Ground, you can share your source code with anyone, and if you share it on Flow's Discord, someone will respond to you right away. This is because Play Ground and the Flow Client Library (FCL) are developed with developers in mind, and this developer support system is one of Flow's strengths.

  Since it is the CTO of Dapper, the creator of Flow Blockchain, who submitted ERC721, Ethereum's NFT, the new features of the NFT will almost certainly become Flow's strength. NFT development using Flow Blockchain will likely accelerate in the future.

  However, building an NFT with Flow Blockchain is difficult for newcomers to understand how to implement, and the lack of books means that there is little information available for reference.

  In particular, after Stable Cadence was released in June 2022, contracts before and after the Breaking Change are mixed up, and information income for them is easy to understand for those who have already developed them, but for those who want to learn Cadence for the first time, the hurdle is quite high.

  This book describes how to write smart contracts using Cadence and the steps to actually release a game. Flow Blockchain around the game is a very attractive platform. The ability to exchange NFTs of any value with anyone in the world, or to pay in Crypto Currency, and the very high speed of the process itself, allows developers to build any Blockchain system they want on top of their own ideas. We will explain in an easy-to-understand manner where beginners are likely to get stuck, and we will work with you to get past the initial obstacle of creating an NFT, so we hope you will pick up this book, discover the joy of creating a blockchain application called Dapp, and build a new system in this world. I hope you will take this book and discover the joy of creating a blockchain app called Dapp and build a new system in this world.  
  
  I will explain in an easy-to-understand manner where beginners are likely to get stuck, and we will work with you to get past the initial obstacle of creating an NFT, so I hope you will pick up this book, discover the joy of creating a blockchain application called Dapp, and build a new system in this world.
  `,
  page1_2: `  I would like to thank Chris, Dapper Asia Gaming Division Strategy Officer, for the opportunity to publish this book.
  I would also like to thank Layne, Community Manager and Product Manager, for her end-to-end support in the execution of this book project.
  Thanks to Vishal, Flow Core Developer, for supervising the writing in the Flow Blockchain and Cadence references. I would like to take this opportunity to thank them.

  Takashi Tahara`,
  page1_3: ``,
  page1_4: ``,
  page1_5: `Getting Started with Cadence`,
  page2_1: '1 . 1 Getting Started with Cadence',
  page2_2: `Cadence is the smart contract language used in Flow Blockchain.
  Where to use the Cadence are as follows:

  * Smart Contract
  * Transaction
  * Script

  There are various blockchains such as Ethereum and Polygon, but do you know how the smart contract language is used in these blockchains?

  (1) Smart contract itself inside the blockchain
  (2) Transaction part that makes changes to the smart contract
  (3) The part that obtains or changes  information inside the smart contract from a library in JavaScript

  Flow Blockchain uses Cadence as its smart contract language, while Ethereum and Polygon use Solidity. And this is where these smart contract languages work and how they work.`,
  page2_3: `In the case of Cadence, the Smart Contract Language of Flow, the library used in (3) is a JavaScript library called FCL (Flow Client Library).

  In the case of Solidity, the library used in (3) is a JavaScript library such as web3.js.
  
  Then, each of them passes a transaction to the blockchain, which writes the blockchain modification process. This process is the movement of (2).
  
  In the case of Cadence, the transaction calls the methods of the smart contract, and passes arguments to indicate how it should be changed. However, the calling process can be changed flexibly.
  
  In the case of Solidity, the transaction calls the methods of the smart contract, and passes arguments to indicate how it should be changed.
  
  In this way, you can see that Cadence and Solidity work in exactly the same way, just in different languages. However, Cadence is easier.
  
  In Cadence, the process (2) can be written later in Cadence, but in Solidity, the process (2) cannot be changed flexibly because it means only calling a method in a smart contract.
  
  Therefore, designing in the Solidity world takes time.
  
  In Solidity, all of (2) is built into the smart contract. Changes require deployment, which takes time and sometimes costs money.
  Cadence allows you to write code in Cadence to handle (2) inside the call, so you don't have to be nervous about creating a design that can handle the changes.
  
  That said, Cadence also does not reduce security, since a transaction cannot be executed without calling a smart contract method.  
  `,
  page2_4: ``,
  page2_5: ``,
  page3_1: `1 . 2 What is a blockchain, after all?

  A blockchain can store values in it. And smart contracts can determine its movement.
  Until smart contracts came along, it was not possible to program them to determine their movement.
  
  A smart contract is an arrangement that you make programmatically. This gives weight to the term decentralization. Because once the smart contract is placed on the blockchain (called "deploy"), there is no longer any way for the creator of that smart contract to go against its contents.`,
  page3_2: `1 . 3 What kind of programs can I program with smart contracts ?

  Anything is fine.
  
  Once a value is captured in the blockchain, it cannot be changed by others, so you can create a program that can easily make effective use of it.
  
  For example, you may want to develop software to properly track traceability, but write a smart contract on the blockchain to prevent the information from being tampered with.
  
  For example, to prevent global warming, you want to apply rules that cannot be changed by any national authority and are equal for everyone in the world as a smart contract, and impose fines on vehicular vessels that cannot be moved efficiently by ship or train.
  
  If I write it this way, you will understand that I can write anything.`,
  page3_3: ``,
  page3_4: ``,
  page3_5: ``,
  page4_1: `1 . 4 What industries are suited for businesses using Flow Blockchain ?

  This is my opinion, but I think the gaming industry is a good fit. As mentioned above, anything can be written in a smart contract, but Blockchain is a new technology and not everyone in the world knows how to use it.
  
  In contrast, games are enjoyed all over the world, and in the case of blockchain games, the value of the tokens used in the blockchain is universal, so revenue can be brought to a world-class revenue stream at once.
  
  Also, since blockchain games are basically possible as long as you have the Internet, as soon as the game is created, it can be released worldwide. Revenue also does not have to exclude people who do not have credit cards or other forms of payment.
  
  When you look at these features of blockchain games, do you notice something? Yes, it is easy to reach out to the world, even in countries where the business environment is less favorable.
  `,
  page4_2: ``,
  page4_3: ``,
  page4_4: ``,
  page4_5: ``,
  page5_1: `  The blockchain game is

  *No credit card companies are needed.
  *No banks needed.
  *No private network companies are needed as long as there is internet access. (This is on the condition that private information is not handled.)
  
    Yes, people all over the world can create games under equal conditions. Until now, it has been difficult to develop games for worldwide distribution in countries where these restrictions existed. (Although there are more restrictions now, such as anti-money laundering measures, etc.)
  
    Did you know that blockchain is attracting attention in Africa?
  Africa has the potential to get the most advanced technology in the world at once with blockchain technology. Not only South Africa, but also large countries near the equator such as Nigeria and Kenya have English as their official language, so it is easy to acquire information on cutting-edge technology, and blockchain has the potential to create the phenomenon of leapfrog, skipping the development stages along the way and catching up with the world's most advanced technology at once.
  
    Right now, this book is published as an e-book on Kindle, and if you could pay for it with crypto assets, you wouldn't even need a bank or credit card, it would be so convenient. 
  
    This is a long digression, but from the next page, I will start the technical explanation of the system development using Cadence.`,
  page5_2: ``,
  page5_3: ``,
  page5_4: ``,
  page5_5: ``,
  page6_1: `Features of Cadence - Smart Contract Language`,
  page6_2: `2 . 1 Features of Cadence smart contract language`,
  page6_3: `Cadence focuses on the shortcomings of Solidity, which make it easy for developers to commit fatal bugs, and focuses on creating a language from the developer's side.

  The following web page describes the five pillars of Cadence. Each of them is described there as follows
  
  https://developers.flow.com/cadence
  
  Safety and Security… This is the most important feature of Cadence and the most characteristic of Cadence. The language specification is so developer-oriented that it is difficult to create a vulnerable program. It is also meant to ensure security for the users who receive NFT assets.
  
  Clarity… Readability of code, clarity of purpose, and lack of ambiguity in the source code. In particular, there is a language specification (resource oriented programming) that states that resources must always be moved somewhere, and has a strict specification that the program is not done until the resource is saved or destroyed.
  
  Approachability… Provide approachability with the programming language for smart contract developers.
  
  Developer Experience… In addition to the above, the specification and tools provide a development support that does not undermine motivation during development.
  
  Intuiting Ownership with Resources… Cadence is designed to retain the resources represented by the NFT and to make the best use of them.`,
  page6_4: ``,
  page6_5: ``,
  page7_1: `Differences between Solidity and Cadence`,
  page7_2: `The main difference is the wallet, which is the software used to store personal account information. The wallet must have a security feature to ensure that only the user can handle it. Solidity uses a metamask for the wallet, while Cadence does not.
  If an individual wants to manage his/her own security, he/she can use Blocto's Non Custodial wallet, for example.`,
  page7_3: ``,
  page7_4: `Why Flow Blockchain does not use metamasks`,
  page7_5: `  This is because, first of all, it is difficult for the general public to use the system. Some people may say that they need to manage their own wallet keys, but if that is the case, they will not play the game.
  The developers of Flow Blockchain were the developers of a game called Crypto Kitties, so they wanted to make a blockchain that was easy to use for the general public.

  The second reason is security. To make security strong, a metamask that is independent of any blockchain is not a good idea because Flow Blockchain users might lose their assets in a wallet.

  In order for the blockchain to be secure for users, the core development team of Flow chose not to use metamasks, and  also formulated a wallet with secure specifications.`,
  page8_1: `Wallet on the Flow blockchain`,
  page8_2: `  The de facto standard wallet for Flow Blockchain is Blocto. This wallet has the keys managed by the wallet company when the app is downloaded to Android or iOS. However, you can later change the key to manage it yourself.

  Blocto also allows you to create an account within a web browser without downloading the app. Therefore, to start the game, you only need a web browser. However, if you want to view NFTs or exchange crypto assets, it is much more convenient to download the app.`,
  page8_3: `Other differences`,
  page8_4: `  It is difficult to convey this without being misleading, but as I wrote in 1.1, they are basically the same.

    It is not the case that Flow Blockchain is so focused on security that it is getting in the way of the decentralized nature of the blockchain itself. On the contrary, Flow's core development team has always had a development roadmap that puts the decentralized nature of the blockchain first, and has been implemented and announced accordingly.
  
    The exact same thing is true for retrieving blockchain information through JavaScript libraries and changing values held within smart contracts.
  
    Flow Blockchain's Cadence came out much later than Solidity, so it has the distinction of having its shortcomings addressed.
  
    Solidity is well-known and many blockchains use EVM (Ethereum Virtual Machine) which handles Solidity, but there are security concerns.
    Perhaps because Solidity was not suitable for implementing the secure transfer of NFT assets, and perhaps because it was the CTO of Flow Blockchaion who proposed NFT, Flow Blockchain has developed an original smart contract language, the Cadence.`,
  page8_5: ``,
  page9_1: `What only Cadence can do`,
  page9_2: `There are many. As I said in 1.1, Solidity basically embeds the transactional code in the smart contract, so there is a complete division of labor between Javascript and Solidity. This can be a bit cumbersome during development. If you are usually a web developer, it is more efficient to develop the front-end while developing the back-end. In fact, with AWS's Amplify and GoogleCloud's Firebase, you can write the source code for the cloud server while writing the front-end source code.

  Amplify and Firebase are growing rapidly because of this convenience.
  
  Cadence allows you to pass Cadence code to JavaScript libraries, allowing you to develop in tandem with your front-end code. Once you get involved in Cadence development, Solidity development can feel a bit sluggish.
  
  I wrote at the beginning that because we can deploy in a fraction of the time and spare no time, we can use it to develop systems in a variety of fields. Also, there are many cases where an audit is not necessary: Solidity has many traps and audits are necessary to code safely, but with Cadence, the developers can check the code themselves.`,
  page9_3: ``,
  page9_4: ``,
  page9_5: ``,
  page10_1: `Let's do development in Cadence!`,
  page10_2: `To write Cadence`,
  page10_3: `Prepare a personal computer.
  You will also need software called an editor that allows you to write programs and software that allows you to execute commands such as downloading software via the Internet.
  For the former, we will use software called VSCode in this manual.
  For the latter, on a Mac, software called Terminal is installed by default.
  For Windows, VSCode has a function that performs the same role as Terminal.
  
  Anyone with an Internet environment can write smart contracts and deploy them on the blockchain.`,
  page10_4: ``,
  page10_5: ``,
  page11_1: `Prepare your development environment`,
  page11_2: `The instructions for launching each of these software programs are as follows.

  Download and install VSCode from the following URL according to the OS of your computer.
  URL: https://code.visualstudio.com/download`,
  page11_3: `The Terminal can be found by opening the Applications folder and then the Utilities folder.`,
  page11_4: `If your OS is Windows, use the Terminal that exists in the VSCode application.
  Open VSCode and press the following toggle in the upper right corner`,
  page11_5: `You will see Terminal in the lower pane of the screen.
  You can change the shell by clicking the "+" button in the upper right corner of the pane with Terminal.`,
  page12_1: `Next, install Node.js.

  Download and install Node.js from the following URL according to your computer's operating system.
  
  URL: https://nodejs.org/en/download/
  `,
  page12_2: ``,
  page12_3: ``,
  page12_4: ``,
  page12_5: ``,
  page13_1: `Next, install the Flow CLI.

  On a Mac, execute the following command on the Terminal.
  
  *For Mac.`,
  page13_2: `If brew is not installed, try running the command /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" to install it.`,
  page13_3: `In case of Windows, please execute the following commands on Terminal.

  *For Windows.`,
  page13_4: `This completes the preparation of the computer environment.`,
  page13_5: ``,
  page14_1: `Let's write Hello, World in Cadence!`,
  page14_2: `The Cadence Playground web page will appear. Select the 0x01 link on the far left.`,
  page14_3: `0x01 refers to 0x01's account.

  This screen shows the smart contract deployed by 0x01.
  
  The location where this smart contract is stored is essentially the same as the storage where resources such as FLOW tokens or NFTs are stored.
  
  In fact, there is a web page where you can check this smart contract code, and the number of FLOW tokens you hold is also shown on that screen. You can think of your account as having a place to store resources such as tokens and a place to hold deployed smart contracts.
  
  *Deploy: placing on the blockchain`,
  page14_4: ``,
  page14_5: ``,
  page15_1: `After clicking 0x01, your web browser should display the following screen.`,
  page15_2: `Indicated by the red box is the contract deployed by 0x01. By referring to this contract, other accounts can obtain information on this contract. (Play Ground allows only one deployment, but it is possible to deploy multiple contracts with a single account.)

  Seeing is believing, so let's write a Hello World contract.`,
  page15_3: `Let's change self.greeting = "Hello, World!" as follows`,
  page15_4: `Then press the Deploy button in the upper right corner.`,
  page15_5: ``,
  page16_1: `You will see the following at the bottom of the screen.`,
  page16_2: `You will see this display when you deploy a smart contract on the blockchain. This blockchain is the blockchain on the emulator.`,
  page16_3: `You can now refer to this address to see the information about this smart contract from anywhere.

  Click on "General Script" in the lower left corner of the screen under "SCRIPT TEMPLATES".`,
  page16_4: `You will see the following on the screen.`,
  page16_5: ``,
  page17_1: `Let's write the code here as follows`,
  page17_2: `The hello method of the HelloWorld smart contract for the 0x01 account is called.`,
  page17_3: `Click the Execute button in the upper right corner of the screen.`,
  page17_4: `Then you will see the following in the area circled in blue.`,
  page17_5: `You now have your first blockchain app, HelloWorld.

  Next, let's change the information in your smart contract.`,
  page18_1: `Let's go back to account 0x01 and add the code as shown in red below. Also, change pub let in line 3 to pub var.`,
  page18_2: `Variables cannot be changed if let is attached, but var can be changed.
  When you have finished making changes, press the Deploy button in the upper right corner.`,
  page18_3: `Click on "Simple Transaction" which can be seen under "TRANSACTION TEMPLATES" in the lower left corner of the screen.`,
  page18_4: ``,
  page18_5: ``,
  page19_1: `You will see the following on the screen.`,
  page19_2: `Let's write the code here as follows. The part in red is the part to be added.`,
  page19_3: `In this state, try pressing the Send button in the upper right corner. If the message "Goodbye, My Smart Contract!" appears at the bottom of the screen, you have succeeded.`,
  page19_4: `Now we have made changes to the smart contract on the blockchain.

  Next, let's get into more serious development.`,
  page19_5: ``,
  page20_1: `To create software in Cadence`,
  page20_2: `The Transaction of blockchain is carried out with the approval of the account. In the previous transaction, this is the following part. This prepare method has an argument of type AuthAccount, which is the object of the account passed as an argument when it is authorized in the wallet.`,
  page20_3: `This AuthAccount object is used to perform changes to the smart contract information. Otherwise, anyone can modify the smart contract.`,
  page20_4: ``,
  page20_5: ``,
  page21_1: `prepare method using AuthAccount`,
  page21_2: `In most cases, the actual transaction is executed using an AuthAccount, as shown below. In the following, the AuthAccount, i.e., the authorizer of the transaction, has obtained a reference to the Collection resource from the MyNFTCollection smart contract in its own storage.`,
  page21_3: `Naturally, this process can only be performed by the account that owns the storage itself.
  Therefore, the AuthAccount, which is the object authorized by the storage owner, plays the most important role in the transaction.
  
  There is another role, "Capability," which can be used to perform other actions, such as depositing NFTs into storage for other accounts." Capability" is defined using the resource interface. See 6 Resource Interface for more information on resource interfaces. This book is explained in the development flow, so please refer to the reference in Chapter 8 for more details.`,
  page21_4: ``,
  page21_5: ``,
  page22_1: `NFT Standard`,
  page22_2: `Next, let's create an NFT contract.
  When the Cadence Playground web page appears, click the 0x01 on the left side of the screen.
  
  (If you find it difficult during the process, please refer to the reference at the end of this document as appropriate. )
  `,
  page22_3: `After clicking 0x01, your web browser should display the following screen.`,
  page22_4: ``,
  page22_5: ``,
  page23_1: `Change this to the Non Fungible Token Standard.

  The Non Fungible Token Standard can be found on the Flow core team's Github.
  
  URL: https://github.com/onflow/flow-nft/blob/master/contracts/NonFungibleToken.cdc
  
  (Here, choose the branch standard-v2 or stable-cadence, not master.)
  
  Copy and paste the contents here into the contract space of the 0x01 account.`,
  page23_2: `As of 2022/12/21, the following getViews and resolveViews exist in the master branch, although Play Ground will error if this is present. At this time, I am commenting out it to avoid the error. In the future, Play Ground will support this. Even if there are no new methods, it is not a problem, just a different version of NFT.`,
  page23_3: `As of 2022/12/21, an error occurs if the following method is present in Play Ground, but the following borrowNFTSafe method is present in the master branch. At this time, the following borrowNFTSafe is commented out to avoid the error. In the future, Play Ground will support this. Even if there are no new methods, it is not a problem, just a different version of NFT.`,
  page23_4: `Comments have been removed to prevent the page from getting too long.`,
  page23_5: ``,
  page24_1: `This is called an interface and lists the methods and states that the contract must implement.

  There are two types of interfaces: contract interfaces and resource interfaces.`,
  page24_2: `The contract interface lists items that the smart contract must conform to, while the resource interface lists items that the resource must conform to. For resource interfaces, see also 6 Resource Interface.

  This interface is the NFT standard that the Flow core team has come up with, and it is considered to be the interface that a resource must conform to in order to be implemented as an NFT.
  
  Once compliant, it will be considered and displayed as an NFT in wallets and marketplaces around the world.
  
  Since Flow Blockchain is still a new blockchain, specifications will be added in the future, but no disruptive changes are expected at this time.
  (Now according to the core developer's talking on Discord, "Stable Cadence" is considered the last disruptive change.)
  
  This makes it seem like there are surprisingly few implementations needed for NFTs, don't you think?`,
  page24_3: ``,
  page24_4: ``,
  page24_5: ``,
  page25_1: `The one state (variable): totalSupply

  In the Flow blockchain, the variable that is placed directly under the contract is called the State. This value represents the state of the smart contract, and this value means the current information of the smart contract. The methods directly under the contract are called logic. The logic defines how the information in the smart contract is changed.`,
  page25_2: `There are three events: ContractInitialized、Withdraw、Deposit

  The event is for when you want to be notified when something changes on the blockchain. For more information, see section 9. Query for Events (How to get event notifications).`,
  page25_3: `Four resource interfaces ： INFT, Provider, Receiver, CollectionPublic`,
  page25_4: `Two resources ： NFT, Collection
  `,
  page25_5: `If we prepare a contract that implements only these features, we can call it an NFT.
  The NFT resource is the body that contains the NFT-specific information, and the Collection is the object that stores these resources. Thanks to this object, it is possible to have multiple NFTs with one path to the account's storage. (See section 3 How to Create an NFT for more information.`,
  page26_1: `The resource interface INFT defines the methods and other information that an NFT resource must comply with.

  The Provider, Receiver, and CollectionPublic resource interfaces define methods for Collection resources to comply with.
  
  The Receiver has a \`deposit\` method, which is the one that makes the deposit. Generally, it is the same as a bank or other transfer deposit, and the incoming side should not require approval.
  
  Of course, it is possible to make Smart Contract to require approval, but in the case of NFT, it is not necessary.
  
  The Provider has a \`withdraw\` method, which is used to retrieve the NFT from the collection. Therefore, this interface is set to a Capability only for who owns NFTs.
  
  CollectionPublic has "Public" in the interface name, so it is safe to assume that it defines a method that is set to a Public Capability that does not require authorization.
  
  "Collection" resources are structured in such a way that Provider, Receiver, and CollectionPublic interfaces should be compliant.
  
  Since the Collection is the outermost part of the resources held by an account when viewed on the blockchain, it is possible to securely hold resources by preparing Public Capability and Private Capability, so it is recommended to prepare interfaces corresponding to these two types. Therefore, it is important to prepare the corresponding interfaces.
  
  Incidentally, resource holders are usually granted full execution rights to resources. (Resource holders do not need Capability when transferring their Resources. See 7 Private Capabilities for more information.)`,
  page26_2: ``,
  page26_3: ``,
  page26_4: ``,
  page26_5: ``,
  page27_1: `Finally, a method named createEmptyCollection is defined in the contract interface.


  Since resources can only be created within a contract, this method is not limited to NFT contracts, but is required for almost all contracts.
  
  Deploy this NFT contract interface to the 0x01 account.
  
  Click the Deploy button in the upper right corner to deploy.
  `,
  page27_2: ``,
  page27_3: ``,
  page27_4: ``,
  page27_5: ``,
  page28_1: `5 . 4 NFT Contracts

  On Play Ground, only one contract can be deployed per account. Therefore, let's deploy our NFT smart contract to account 0x02.
  
  Click on 0x02 and type the following code on the screen.`,
  page28_2: `Next, make this contract compliant with the interface. Please add the code as shown in red below.`,
  page28_3: `At this time, an error should appear on Play Ground. This is because the interface contains items that must be implemented by the Smart Contract, and these items have not been implemented.`,
  page28_4: ``,
  page28_5: ``,
  page29_1: `Implement the items that should be implemented in the smart contract. First, add the code for the event as shown in red below.`,
  page29_2: `This defines the Events. Events are methods, but just define them in pub event and you are good to go. When you want to generate an event, call this method.
  You will then be able to receive notifications from the blockchain.`,
  page29_3: `Next, add the States as shown in red below.`,
  page29_4: `The States must always be initialized in init, and the Init process is required not only in the Contract, but also in the Resource and in the Struct.`,
  page29_5: ``,
  page30_1: `Next, add the code for the NFT resource as shown in red below.`,
  page30_2: `This NFT is the body of the resource you wish to store in the account storage. You will add the necessary methods and states to this method. In this document, however, we will only implement id.`,
  page30_3: `Next, we want this resource to be compliant with the NFT standard, so we add the interface as shown in red below.`,
  page30_4: ``,
  page30_5: ``,
  page31_1: `Next, add a collection resource to store the NFT as shown in red below.`,
  page31_2: `When creating a resource, '<-' is required.`,
  page31_3: `(Omitted)`,
  page31_4: `Now make this Collection compliant with the NFT Contract interface. Add the following.`,
  page31_5: ``,
  page32_1: `Next, the necessary logic is added to the collection resource to comply with the resource interface. Add the following in red below.`,
  page32_2: `All of its methods must be implemented to comply with the three interfaces.

  "deposit" method：Downcasting with "as!" allows access to the states and methods defined in this smart contract. For details on downcasting, see "3. How to Create an NFT".
  
  "withdraw" method：This removes one NFT from the collection and returns it.
  An error occurs during the transaction until it can be confirmed that it will be stored in other storage or destroyed. Therefore, it is said that Flow is designed to be safe in the sense that resources are never lost.
  
  "borrowNFT" method：Returns a reference to a resource. Since it is a reference, the resource is not moved and the code can be written safely.
  In the Optional Reference implementation, a Breaking Change occurred here, as shown below.
   
   &self.ownedNFTs[id] as &NonFungibleToken.NFT
  
  was fine, but now it is
  
   (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
  
  For more information on Optional References, please refer to the 17 Optional References section.
  
  "getIDs" method：Returns a list of NFT IDs.`,
  page32_3: ``,
  page32_4: ``,
  page32_5: ``,
  page33_1: `Implement the createEmptyCollection method.`,
  page33_2: `This contract is now compliant with the NonFungibleToken contract interface. Deploy it by clicking the "Deploy" button in the upper right corner.
  If you get a message that you cannot deploy, reload your browser and try clicking the "Deploy" button again starting from 0x01.`,
  page33_3: `Finally, we implement a method to generate this NFT, the createToken method. Since the "create" directive can only be written in a contract, this method must be implemented in the contract.`,
  page33_4: `Deploy this by clicking the "Deploy" button in the upper right corner.`,
  page33_5: ``,
  page34_1: `Finally, the entire NFT Smart Contract is as follows`,
  page34_2: `The following GitHub URL has the full source code for the app that joined the Flowverse and Flow Ecosystem Network in July 2022. (Collection is used under the name Vault.)
  This app did not use NFT, so there is no Contract Interface, but the resource interface is included because it is used heavily in access restrictions.
  
  URL: https://github.com/temt-ceo/tickets-on-flow/blob/main/cadence/Tickets.cdc
  
  I think Cadence is very friendly to game engineers because it looks surprisingly like C language.`,
  page34_3: ``,
  page34_4: ``,
  page34_5: ``,
  page35_1: `Let's give NFT to other accounts.`,
  page35_2: `Now let's give the created NFT to the user.`,
  page35_3: `Click on the + to the right of "TRANSACTION TEMPLATES" in the red box, click on "New Transaction" that appears, and write the following source code in the space on the right.`,
  page35_4: `Let's execute it from the "Send" button in the upper right corner. The Transaction Signer displayed in the upper right corner can be anyone, so let's execute it with the default value of 0x01 set.`,
  page35_5: ``,
  page36_1: `This transaction saves the resources of the NFT collection to the storage of the account. The path to the storage where this resource is stored is /storage/, which can only be accessed by the account itself. Therefore, we have created Public Capability so that anyone can access this information.
  Public Capability is specified by the link method with a resource interface.
  
  AuthAccount.link<& resource name {resource interface}>(destination, target: resource location)
  
  The following example shows how to do this. Since a resource interface only allows access to the methods defined in the resource interface, here Capability, which only allows access to the methods defined in NonFungibleToken.CollectionPublic, is stored in the /public/ path of the storage.
  
  
  The next step is to perform a Transaction to insert an NFT into the collection created in this account.`,
  page36_2: ``,
  page36_3: ``,
  page36_4: ``,
  page36_5: ``,
  page37_1: `Let's execute it from the "Send" button in the upper right corner. Set 0x01, which has Collection, to the Transaction Signer displayed in the upper right corner.`,
  page37_2: `This Transaction is getting a reference to a resource in the NFT collection.

  This Transaction is authorized and executed by the owner of the collection, so we can go directly to the /storage/ path to see the resource.
  
  The next line takes the NFT created with the <- directive and stores it in the collection's resources in the next line.
  
  It's a little, lonely in terms of content, but we have now saved the NFT in the Collection. Next, let's create a system for a more practical game.`,
  page37_3: ``,
  page37_4: ``,
  page37_5: ``,
  page38_1: `Let's make a real Dapps!`,
  page38_2: `DApps to be created`,
  page38_3: `We will create a system to notify users of blockchain updates in real time.
  The technologies to be used are Flow Blockchain for the blockchain, AWS DynamoDB and AppSync for the cloud server, and AWS Amplify, which supports GraphQL, will be used to build the system. We will create a system with the following configuration diagram.`,
  page38_4: `Specifically, the exchange of trading cards is stored on the blockchain. When the exchange occurs, an event is generated on the blockchain.
  The event will be stored in DynamoDB and the user's application will be notified in real time.
  
  As mentioned in section 3.5, Amplify allows you to write the source code for the cloud server while writing the source code for the front-end, making development much more efficient.
  Amplify of AWS and Firebase of GoogleCloud can combine back-end and front-end source code in one repository.
  
  We will use this Amplify mechanism to build a full-fledged application that can be built in less than an hour.`,
  page38_5: ``,
  page39_1: `Building Amplify and Nuxt.js environment`,
  page39_2: `First, build the part in the red box below in the configuration diagram.`,
  page39_3: `I will proceed under the assumption that Node.js and AWS Amplify CLI are already installed.`,
  page39_4: `For information on how to install Amplify CLI, please refer to the official AWS website.`,
  page39_5: `If you wish to delete the Amplify system you have built, you can do so by executing the following command.`,
  page40_1: `Create an IAM User to build Amplify. Execute the following command.`,
  page40_2: `1. Web Blowser will start up, and sign in to AWS on the screen displayed.
  After signing in is complete, return to the Terminal screen and press Enter.
2. Select AWS Region on the Terminal screen (see image below).`,
  page40_3: `3. Enter the name of the IAM user to be newly created. (flowEvents)`,
  page40_4: ``,
  page40_5: ``,
  page41_1: ``,
  page41_2: ``,
  page41_3: ``,
  page41_4: ``,
  page41_5: ``,
  page42_1: ``,
  page42_2: ``,
  page42_3: ``,
  page42_4: ``,
  page42_5: ``,
  page43_1: ``,
  page43_2: ``,
  page43_3: ``,
  page43_4: ``,
  page43_5: ``,
  page44_1: ``,
  page44_2: ``,
  page44_3: ``,
  page44_4: ``,
  page44_5: ``,
  page45_1: ``,
  page45_2: ``,
  page45_3: ``,
  page45_4: ``,
  page45_5: ``,
  page46_1: ``,
  page46_2: ``,
  page46_3: ``,
  page46_4: ``,
  page46_5: ``,
  page47_1: ``,
  page47_2: ``,
  page47_3: ``,
  page47_4: ``,
  page47_5: ``,
  page48_1: ``,
  page48_2: ``,
  page48_3: ``,
  page48_4: ``,
  page48_5: ``,
  page49_1: ``,
  page49_2: ``,
  page49_3: ``,
  page49_4: ``,
  page49_5: ``,
  page50_1: ``,
  page50_2: ``,
  page50_3: ``,
  page50_4: ``,
  page50_5: ``,
  page51_1: ``,
  page51_2: ``,
  page51_3: ``,
  page51_4: ``,
  page51_5: ``,
  page52_1: ``,
  page52_2: ``,
  page52_3: ``,
  page52_4: ``,
  page52_5: ``,
  page53_1: ``,
  page53_2: ``,
  page53_3: ``,
  page53_4: ``,
  page53_5: ``,
  page54_1: ``,
  page54_2: ``,
  page54_3: ``,
  page54_4: ``,
  page54_5: ``,
  page55_1: ``,
  page55_2: ``,
  page55_3: ``,
  page55_4: ``,
  page55_5: ``,
  page56_1: ``,
  page56_2: ``,
  page56_3: ``,
  page56_4: ``,
  page56_5: ``,
  page57_1: ``,
  page57_2: ``,
  page57_3: ``,
  page57_4: ``,
  page57_5: ``,
  page58_1: ``,
  page58_2: ``,
  page58_3: ``,
  page58_4: ``,
  page58_5: ``,
  page59_1: ``,
  page59_2: ``,
  page59_3: ``,
  page59_4: ``,
  page59_5: ``,
  page60_1: ``,
  page60_2: ``,
  page60_3: ``,
  page60_4: ``,
  page60_5: ``,
  page61_1: ``,
  page61_2: ``,
  page61_3: ``,
  page61_4: ``,
  page61_5: ``,
  page62_1: ``,
  page62_2: ``,
  page62_3: ``,
  page62_4: ``,
  page62_5: ``,
  page63_1: ``,
  page63_2: ``,
  page63_3: ``,
  page63_4: ``,
  page63_5: ``,
  page64_1: ``,
  page64_2: ``,
  page64_3: ``,
  page64_4: ``,
  page64_5: ``,
  page65_1: ``,
  page65_2: ``,
  page65_3: ``,
  page65_4: ``,
  page65_5: ``,
  page66_1: ``,
  page66_2: ``,
  page66_3: ``,
  page66_4: ``,
  page66_5: ``,
  page67_1: ``,
  page67_2: ``,
  page67_3: ``,
  page67_4: ``,
  page67_5: ``,
  page68_1: ``,
  page68_2: ``,
  page68_3: ``,
  page68_4: ``,
  page68_5: ``,
  page69_1: ``,
  page69_2: ``,
  page69_3: ``,
  page69_4: ``,
  page69_5: ``,
  page70_1: ``,
  page70_2: ``,
  page70_3: ``,
  page70_4: ``,
  page70_5: ``,
  page71_1: ``,
  page71_2: ``,
  page71_3: ``,
  page71_4: ``,
  page71_5: ``,
  page72_1: ``,
  page72_2: ``,
  page72_3: ``,
  page72_4: ``,
  page72_5: ``,
  page73_1: ``,
  page73_2: ``,
  page73_3: ``,
  page73_4: ``,
  page73_5: ``,
  page74_1: ``,
  page74_2: ``,
  page74_3: ``,
  page74_4: ``,
  page74_5: ``,
  page75_1: ``,
  page75_2: ``,
  page75_3: ``,
  page75_4: ``,
  page75_5: ``,
  page76_1: ``,
  page76_2: ``,
  page76_3: ``,
  page76_4: ``,
  page76_5: ``,
  page77_1: ``,
  page77_2: ``,
  page77_3: ``,
  page77_4: ``,
  page77_5: ``,
  page78_1: ``,
  page78_2: ``,
  page78_3: ``,
  page78_4: ``,
  page78_5: ``,
  page79_1: ``,
  page79_2: ``,
  page79_3: ``,
  page79_4: ``,
  page79_5: ``,
  page80_1: ``,
  page80_2: ``,
  page80_3: ``,
  page80_4: ``,
  page80_5: ``,
  page81_1: ``,
  page81_2: ``,
  page81_3: ``,
  page81_4: ``,
  page81_5: ``,
  page82_1: ``,
  page82_2: ``,
  page82_3: ``,
  page82_4: ``,
  page82_5: ``,
  page83_1: ``,
  page83_2: ``,
  page83_3: ``,
  page83_4: ``,
  page83_5: ``,
  page84_1: ``,
  page84_2: ``,
  page84_3: ``,
  page84_4: ``,
  page84_5: ``,
  page85_1: ``,
  page85_2: ``,
  page85_3: ``,
  page85_4: ``,
  page85_5: ``,
  page86_1: ``,
  page86_2: ``,
  page86_3: ``,
  page86_4: ``,
  page86_5: ``,
  page87_1: ``,
  page87_2: ``,
  page87_3: ``,
  page87_4: ``,
  page87_5: ``,
  page88_1: ``,
  page88_2: ``,
  page88_3: ``,
  page88_4: ``,
  page88_5: ``,
  page89_1: ``,
  page89_2: ``,
  page89_3: ``,
  page89_4: ``,
  page89_5: ``,
  page90_1: ``,
  page90_2: ``,
  page90_3: ``,
  page90_4: ``,
  page90_5: ``,
  page91_1: ``,
  page91_2: ``,
  page91_3: ``,
  page91_4: ``,
  page91_5: ``,
  page92_1: ``,
  page92_2: ``,
  page92_3: ``,
  page92_4: ``,
  page92_5: ``,
  page93_1: ``,
  page93_2: ``,
  page93_3: ``,
  page93_4: ``,
  page93_5: ``,
  page94_1: ``,
  page94_2: ``,
  page94_3: ``,
  page94_4: ``,
  page94_5: ``,
  page95_1: ``,
  page95_2: ``,
  page95_3: ``,
  page95_4: ``,
  page95_5: ``,
  page96_1: ``,
  page96_2: ``,
  page96_3: ``,
  page96_4: ``,
  page96_5: ``,
  page97_1: ``,
  page97_2: ``,
  page97_3: ``,
  page97_4: ``,
  page97_5: ``,
  page98_1: ``,
  page98_2: ``,
  page98_3: ``,
  page98_4: ``,
  page98_5: ``,
  page99_1: ``,
  page99_2: ``,
  page99_3: ``,
  page99_4: ``,
  page99_5: ``,
  page101_1: ``,
  page101_2: ``,
  page101_3: ``,
  page101_4: ``,
  page101_5: ``,
  page102_1: ``,
  page102_2: ``,
  page102_3: ``,
  page102_4: ``,
  page102_5: ``,
  page103_1: ``,
  page103_2: ``,
  page103_3: ``,
  page103_4: ``,
  page103_5: ``,
  page104_1: ``,
  page104_2: ``,
  page104_3: ``,
  page104_4: ``,
  page104_5: ``,
  page105_1: ``,
  page105_2: ``,
  page105_3: ``,
  page105_4: ``,
  page105_5: ``,
  page106_1: ``,
  page106_2: ``,
  page106_3: ``,
  page106_4: ``,
  page106_5: ``,
  page107_1: ``,
  page107_2: ``,
  page107_3: ``,
  page107_4: ``,
  page107_5: ``,
  page108_1: ``,
  page108_2: ``,
  page108_3: ``,
  page108_4: ``,
  page108_5: ``,
  page109_1: ``,
  page109_2: ``,
  page109_3: ``,
  page109_4: ``,
  page109_5: ``,
  page110_1: ``,
  page110_2: ``,
  page110_3: ``,
  page110_4: ``,
  page110_5: ``,
  page111_1: ``,
  page111_2: ``,
  page111_3: ``,
  page111_4: ``,
  page111_5: ``,
  page112_1: ``,
  page112_2: ``,
  page112_3: ``,
  page112_4: ``,
  page112_5: ``,
  page113_1: ``,
  page113_2: ``,
  page113_3: ``,
  page113_4: ``,
  page113_5: ``,
  page114_1: ``,
  page114_2: ``,
  page114_3: ``,
  page114_4: ``,
  page114_5: ``,
  page115_1: ``,
  page115_2: ``,
  page115_3: ``,
  page115_4: ``,
  page115_5: ``,
  page116_1: ``,
  page116_2: ``,
  page116_3: ``,
  page116_4: ``,
  page116_5: ``,
  page117_1: ``,
  page117_2: ``,
  page117_3: ``,
  page117_4: ``,
  page117_5: ``,
  page118_1: ``,
  page118_2: ``,
  page118_3: ``,
  page118_4: ``,
  page118_5: ``,
  page119_1: ``,
  page119_2: ``,
  page119_3: ``,
  page119_4: ``,
  page119_5: ``,
  page120_1: ``,
  page120_2: ``,
  page120_3: ``,
  page120_4: ``,
  page120_5: ``,
  page121_1: ``,
  page121_2: ``,
  page121_3: ``,
  page121_4: ``,
  page121_5: ``,
  page122_1: ``,
  page122_2: ``,
  page122_3: ``,
  page122_4: ``,
  page122_5: ``,
  page123_1: ``,
  page123_2: ``,
  page123_3: ``,
  page123_4: ``,
  page123_5: ``,
  page124_1: ``,
  page124_2: ``,
  page124_3: ``,
  page124_4: ``,
  page124_5: ``,
  page125_1: ``,
  page125_2: ``,
  page125_3: ``,
  page125_4: ``,
  page125_5: ``,
  page126_1: ``,
  page126_2: ``,
  page126_3: ``,
  page126_4: ``,
  page126_5: ``,
  page127_1: ``,
  page127_2: ``,
  page127_3: ``,
  page127_4: ``,
  page127_5: ``,
  page128_1: ``,
  page128_2: ``,
  page128_3: ``,
  page128_4: ``,
  page128_5: ``,
  page129_1: ``,
  page129_2: ``,
  page129_3: ``,
  page129_4: ``,
  page129_5: ``,
  page130_1: ``,
  page130_2: ``,
  page130_3: ``,
  page130_4: ``,
  page130_5: ``,
  page131_1: ``,
  page131_2: ``,
  page131_3: ``,
  page131_4: ``,
  page131_5: ``,
  page132_1: ``,
  page132_2: ``,
  page132_3: ``,
  page132_4: ``,
  page132_5: ``,
  page133_1: ``,
  page133_2: ``,
  page133_3: ``,
  page133_4: ``,
  page133_5: ``,
  page134_1: ``,
  page134_2: ``,
  page134_3: ``,
  page134_4: ``,
  page134_5: ``,
  page135_1: ``,
  page135_2: ``,
  page135_3: ``,
  page135_4: ``,
  page135_5: ``,
  page136_1: ``,
  page136_2: ``,
  page136_3: ``,
  page136_4: ``,
  page136_5: ``,
  page137_1: ``,
  page137_2: ``,
  page137_3: ``,
  page137_4: ``,
  page137_5: ``,
  page138_1: ``,
  page138_2: ``,
  page138_3: ``,
  page138_4: ``,
  page138_5: ``,
  page139_1: ``,
  page139_2: ``,
  page139_3: ``,
  page139_4: ``,
  page139_5: ``,
  page140_1: ``,
  page140_2: ``,
  page140_3: ``,
  page140_4: ``,
  page140_5: ``,
  page141_1: ``,
  page141_2: ``,
  page141_3: ``,
  page141_4: ``,
  page141_5: ``,
  page142_1: ``,
  page142_2: ``,
  page142_3: ``,
  page142_4: ``,
  page142_5: ``,
  page143_1: ``,
  page143_2: ``,
  page143_3: ``,
  page143_4: ``,
  page143_5: ``,
  page144_1: ``,
  page144_2: ``,
  page144_3: ``,
  page144_4: ``,
  page144_5: ``,
  page145_1: ``,
  page145_2: ``,
  page145_3: ``,
  page145_4: ``,
  page145_5: ``,
  page146_1: ``,
  page146_2: ``,
  page146_3: ``,
  page146_4: ``,
  page146_5: ``,
  page147_1: ``,
  page147_2: ``,
  page147_3: ``,
  page147_4: ``,
  page147_5: ``,
  page148_1: ``,
  page148_2: ``,
  page148_3: ``,
  page148_4: ``,
  page148_5: ``,
  page149_1: ``,
  page149_2: ``,
  page149_3: ``,
  page149_4: ``,
  page149_5: ``,
  page150_1: ``,
  page150_2: ``,
  page150_3: ``,
  page150_4: ``,
  page150_5: ``,
  page151_1: ``,
  page151_2: ``,
  page151_3: ``,
  page151_4: ``,
  page151_5: ``,
  page152_1: ``,
  page152_2: ``,
  page152_3: ``,
  page152_4: ``,
  page152_5: ``,
  page153_1: ``,
  page153_2: ``,
  page153_3: ``,
  page153_4: ``,
  page153_5: ``,
  page154_1: ``,
  page154_2: ``,
  page154_3: ``,
  page154_4: ``,
  page154_5: ``,
  page155_1: ``,
  page155_2: ``,
  page155_3: ``,
  page155_4: ``,
  page155_5: ``,
  page156_1: ``,
  page156_2: ``,
  page156_3: ``,
  page156_4: ``,
  page156_5: ``,
  page157_1: ``,
  page157_2: ``,
  page157_3: ``,
  page157_4: ``,
  page157_5: ``,
  page158_1: ``,
  page158_2: ``,
  page158_3: ``,
  page158_4: ``,
  page158_5: ``,
  page159_1: ``,
  page159_2: ``,
  page159_3: ``,
  page159_4: ``,
  page159_5: ``,
  page160_1: ``,
  page160_2: ``,
  page160_3: ``,
  page160_4: ``,
  page160_5: ``,
  page161_1: ``,
  page161_2: ``,
  page161_3: ``,
  page161_4: ``,
  page161_5: ``,
  page162_1: ``,
  page162_2: ``,
  page162_3: ``,
  page162_4: ``,
  page162_5: ``,
  page163_1: ``,
  page163_2: ``,
  page163_3: ``,
  page163_4: ``,
  page163_5: ``,
  page164_1: ``,
  page164_2: ``,
  page164_3: ``,
  page164_4: ``,
  page164_5: ``,
  page165_1: ``,
  page165_2: ``,
  page165_3: ``,
  page165_4: ``,
  page165_5: ``,
  page166_1: ``,
  page166_2: ``,
  page166_3: ``,
  page166_4: ``,
  page166_5: ``,
  page167_1: ``,
  page167_2: ``,
  page167_3: ``,
  page167_4: ``,
  page167_5: ``,
  page168_1: ``,
  page168_2: ``,
  page168_3: ``,
  page168_4: ``,
  page168_5: ``,
  page169_1: ``,
  page169_2: ``,
  page169_3: ``,
  page169_4: ``,
  page169_5: ``,
  page170_1: ``,
  page170_2: ``,
  page170_3: ``,
  page170_4: ``,
  page170_5: ``,
  page171_1: ``,
  page171_2: ``,
  page171_3: ``,
  page171_4: ``,
  page171_5: ``,
  page172_1: ``,
  page172_2: ``,
  page172_3: ``,
  page172_4: ``,
  page172_5: ``,
  page173_1: ``,
  page173_2: ``,
  page173_3: ``,
  page173_4: ``,
  page173_5: ``,
  page174_1: ``,
  page174_2: ``,
  page174_3: ``,
  page174_4: ``,
  page174_5: ``,
  page175_1: ``,
  page175_2: ``,
  page175_3: ``,
  page175_4: ``,
  page175_5: ``,
  page176_1: ``,
  page176_2: ``,
  page176_3: ``,
  page176_4: ``,
  page176_5: ``,
  page177_1: ``,
  page177_2: ``,
  page177_3: ``,
  page177_4: ``,
  page177_5: ``,
  page178_1: ``,
  page178_2: ``,
  page178_3: ``,
  page178_4: ``,
  page178_5: ``,
  page179_1: ``,
  page179_2: ``,
  page179_3: ``,
  page179_4: ``,
  page179_5: ``,
  page180_1: ``,
  page180_2: ``,
  page180_3: ``,
  page180_4: ``,
  page180_5: ``,
  page181_1: ``,
  page181_2: ``,
  page181_3: ``,
  page181_4: ``,
  page181_5: ``,
  page182_1: ``,
  page182_2: ``,
  page182_3: ``,
  page182_4: ``,
  page182_5: ``,
  page183_1: ``,
  page183_2: ``,
  page183_3: ``,
  page183_4: ``,
  page183_5: ``,
  page184_1: ``,
  page184_2: ``,
  page184_3: ``,
  page184_4: ``,
  page184_5: ``,
  page185_1: ``,
  page185_2: ``,
  page185_3: ``,
  page185_4: ``,
  page185_5: ``,
  page186_1: ``,
  page186_2: ``,
  page186_3: ``,
  page186_4: ``,
  page186_5: ``,
  page187_1: ``,
  page187_2: ``,
  page187_3: ``,
  page187_4: ``,
  page187_5: ``,
  page188_1: ``,
  page188_2: ``,
  page188_3: ``,
  page188_4: ``,
  page188_5: ``,
  page189_1: ``,
  page189_2: ``,
  page189_3: ``,
  page189_4: ``,
  page189_5: ``,
  page190_1: ``,
  page190_2: ``,
  page190_3: ``,
  page190_4: ``,
  page190_5: ``,
  page191_1: ``,
  page191_2: ``,
  page191_3: ``,
  page191_4: ``,
  page191_5: ``,
  page192_1: ``,
  page192_2: ``,
  page192_3: ``,
  page192_4: ``,
  page192_5: ``,
  page193_1: ``,
  page193_2: ``,
  page193_3: ``,
  page193_4: ``,
  page193_5: ``,
  page194_1: ``,
  page194_2: ``,
  page194_3: ``,
  page194_4: ``,
  page194_5: ``,
  page195_1: ``,
  page195_2: ``,
  page195_3: ``,
  page195_4: ``,
  page195_5: ``,
  page196_1: ``,
  page196_2: ``,
  page196_3: ``,
  page196_4: ``,
  page196_5: ``,
  page197_1: ``,
  page197_2: ``,
  page197_3: ``,
  page197_4: ``,
  page197_5: ``,
  page198_1: ``,
  page198_2: ``,
  page198_3: ``,
  page198_4: ``,
  page198_5: ``,
  page199_1: ``,
  page199_2: ``,
  page199_3: ``,
  page199_4: ``,
  page199_5: ``,
}