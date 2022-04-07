// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "ds-test/test.sol";
import {Collectors, URIQueryForNonexistentToken} from  "../Contract.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

interface CheatCodes {
    function prank(address) external;
    function startPrank(address) external;
    function stopPrank() external;
    function expectRevert(bytes calldata) external;
    function warp(uint256) external;
}

contract ContractTest is DSTest {
    CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);

    using Strings for uint256;
    Collectors coll;
    string _baseURI = "ipfs://QmPwu1Z6WVckrCiRcAoXr4AL5SVMivJVUfHw7qqSNUtYR";

    function generateAddress(bytes memory str) internal pure returns (address) {
        return address(bytes20(keccak256(str)));
    }

    function setUp() public {
        coll = new Collectors();
    }

    function testNameAndSymbol() public {
        assertEq(coll.name(), "Collectooors");
        assertEq(coll.symbol(), "COLLECTOOORS");
        assertEq(coll.owner(), address(this));
        assertEq(coll.totalSupply(), 0);
    }

    function testMint() public {
        coll.mintBatch(1);
        assertEq(coll.tokenURI(0), "");
        assertEq(coll.totalSupply(), 1);

        coll.setBaseURI(_baseURI);
        assertEq(coll.tokenURI(0), "ipfs://QmPwu1Z6WVckrCiRcAoXr4AL5SVMivJVUfHw7qqSNUtYR/0.json");

        cheats.expectRevert(abi.encodeWithSelector(URIQueryForNonexistentToken.selector));
        coll.tokenURI(1);

        coll.mintBatch(50);
        assertEq(coll.totalSupply(), 51);

        assertEq(coll.tokenURI(50), "ipfs://QmPwu1Z6WVckrCiRcAoXr4AL5SVMivJVUfHw7qqSNUtYR/50.json");

        cheats.expectRevert(abi.encodeWithSelector(URIQueryForNonexistentToken.selector));
        coll.tokenURI(51);
    }

    function testTransferOwnership() public {
        assertEq(coll.owner(), address(this));
        address newOwner = generateAddress("newOwner");
        coll.transferOwnership(newOwner);

        assertEq(coll.owner(), newOwner);

        cheats.expectRevert("Ownable: caller is not the owner");
        coll.mintBatch(1);
        cheats.expectRevert("Ownable: caller is not the owner");
        coll.setBaseURI("base");
        cheats.expectRevert("Ownable: caller is not the owner");
        coll.transferOwnership(address(this));

        cheats.startPrank(newOwner);
        testMint();
        cheats.stopPrank();
    }

    function testTransfer() public {
        coll.mintBatch(1);

        address receiver = generateAddress("receiver");
        coll.transferFrom(address(this), receiver, 0);

        assertEq(coll.ownerOf(0), receiver);
    }

    function testRoyalty() public {
        (address owner, uint256 cut) = coll.royaltyInfo(0, 100);
        assertEq(coll.owner(), owner);
        assertEq(5, cut);

        (, cut) = coll.royaltyInfo(0, 101);
        assertEq(5, cut);

        (, cut) = coll.royaltyInfo(0, 1e18);
        assertEq(5e16, cut);
    }
}
