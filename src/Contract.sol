// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {ERC721A, URIQueryForNonexistentToken, Strings} from "erc721a/contracts/ERC721A.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC2981} from "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract Collectors is ERC721A, Ownable, IERC2981 {
    using Strings for uint256;

    uint256 public immutable royaltyShare = 5e16; // 5%
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

    function royaltyInfo(uint256 /* tokenId */, uint256 salePrice) // TODO: check if ERC165 support is needed
        external
        view
        returns (address, uint256) {

        uint256 royaltyAmount = salePrice * royaltyShare / 1e18; // TODO: check for correctness
        return (owner(), royaltyAmount);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();
        return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
    }

}
