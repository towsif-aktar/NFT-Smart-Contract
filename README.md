# NFT Smart Contract With Royalty Support
This repository contains the Solidity code for the  NFT smart contract, an ERC-721 non-fungible token (NFT) with royalty support. 
he contract utilizes OpenZeppelin's libraries for security and follows the ERC721Enumerable and ERC2981 standards.

```bash
  git clone https://github.com/towsif-aktar/NFT-Smart-Contract.git
```

## Key features of the contract include:
+  **Token Minting:** Users can mint NFTs by paying a set fee (modifiable by the owner).
+  **Royalties:** Integrated support for ERC2981 royalties, allowing the creator to receive a percentage of sales.
+ **Revealing Mechanism:** NFTs can initially be hidden (using a not-revealed URI), and the contract owner can reveal them later.
+ **Max Supply & Mint Limits:** Configurable maximum supply and minting limits per transaction.
+ **Custom Base URI:** NFTs are hosted with a custom base URI, set to ipfs://your-ipfs/.

## Key Variables
+  Name: 
+  Symbol: NFT
+  Max Supply: 10 NFTs
+  Mint Cost: 0.001 Ether per NFT
+  Royalty Percentage: 10% (modifiable)
+  Base URI: `ipfs://your-ipfs/`

## Features
+  **Ownership Control:** The contract owner can set the minting price, maximum mint amount, and URI-related settings.
+ **Pause Functionality:** Contract minting can be paused by the owner.
+ **Wallet Tracking:** The contract tracks and displays token ownership details for each user.

## How to Use
+  **Minting:** Send Ether to mint tokens, with each token priced at 0.001 Ether (unless you're the owner).
+ **Revealing NFTs:** The contract owner can reveal the metadata for all NFTs at once.
+ **Royalties:** Automatic royalty distribution (10%) on every sale.


## Technology Stack
+  Solidity 0.8.20
+  OpenZeppelin Contracts (ERC721, ERC2981, Ownable)

# Contributing:
  This project is licensed under the MIT License - see the [LICENSE](https://github.com/towsif-aktar/NFT-Smart-Contract?tab=MIT-1-ov-file) file for details.
