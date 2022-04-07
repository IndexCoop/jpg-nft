// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {ERC721A} from "erc721a/contracts/ERC721A.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Collectors is ERC721A, Ownable {

    string private _baseTokenURI;
    constructor() ERC721A("Collectooors", "COLLECTOOORS") {}


    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }


    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    // @notice no `safeMint` allowed implying it doesn't call `onERC721Received` on the minter.
    function mintBatch(uint256 quantity) external onlyOwner {
        _mint(msg.sender, quantity, "", false);
    }


}
