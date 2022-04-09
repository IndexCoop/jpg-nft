# Collectooors Assemble

NFT contract for incentivizing $JPG liquiduity.

## For Devs
Contract is based on ERC721A which makes batch minting cheaper than the standard ERC721 implmentation.

## Setup
- Set up foundry: https://github.com/gakonst/foundry
- Clone the repository
- In the repo, run `forge install`
- Then run `forge test`

## Some notable features
- Support for [EIP-2981](https://eips.ethereum.org/EIPS/eip-2981) - NFT royalty standard
    - 5% royalty on secondary sales.
- `mintBatch(uint)` function to mint multiple NFTs to owners.
- `transferToMultiple()` function to transfer muliple NFTs to different addresses; can be called by anyone.