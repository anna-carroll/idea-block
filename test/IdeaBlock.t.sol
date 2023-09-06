// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {Test} from "forge-std/Test.sol";

import {IdeaBlock} from "../src/IdeaBlock.sol";
import {deploy} from "../script/DeployIdeaBlock.s.sol";

contract IdeasTest is Test {
    IdeaBlock test;

    uint256 pk = 1;
    address ideaGuy;
    string idea;
    bytes32 hash;
    uint8 v;
    bytes32 r;
    bytes32 s;

    /// @dev Emitted when token `id` is transferred from `from` to `to`.
    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    function setUp() public {
        test = deploy();

        idea = "Big Bird OnlyFans";
        hash = test.getHash(idea);
        (v, r, s) = vm.sign(pk, hash);
        ideaGuy = vm.addr(pk);
    }

    // util for accurate gas snapshot
    function test_gas_mint() public {
        test.mint(idea, v, r, s);
    }

    // should emit Transfer event to the idea guy
    function test_mint_emitsTransfer() public {
        // should emit mint to the correct idea guy
        vm.expectEmit();
        emit Transfer(address(0), ideaGuy, 1);
        // mint
        test.mint(idea, v, r, s);
    }

    // should increment counter
    function test_mint_incrementsCount() public {
        // count should start at 0
        assertEq(test.count(), 0);
        // mint
        test.mint(idea, v, r, s);
        // mint should increment count
        assertEq(test.count(), 1);
    }

    // should return correct tokenId
    function test_mint_returnsCorrectTokenId() public {
        // mint
        uint256 id = test.mint(idea, v, r, s);
        // should start mint at tokenId 1
        assertEq(id, 1);
    }

    // should store hash => tokenId
    function test_mint_storesHashToTokenId() public {
        // mint
        uint256 id = test.mint(idea, v, r, s);
        // should set the tokenId within hashToTokenId
        assertEq(test.hashToTokenId(hash), id);
    }

    // should store tokenId => idea
    function test_mint_storesTokenIdToIdea() public {
        // mint
        uint256 id = test.mint(idea, v, r, s);
        // should set idea within tokenIdToIdea
        assertEq(test.getHash(test.tokenIdToIdea(id)), hash);
    }

    // should update tokenURI with idea
    function test_mint_tokenURI() public {
        // mint
        uint256 id = test.mint(idea, v, r, s);
        // should set tokenURI
        assertEq(test.getHash(test.tokenURI(id)), hash);
    }

    // should be able to find tokenId by querying with raw idea
    function test_mint_getTokenId() public {
        // mint
        uint256 id = test.mint(idea, v, r, s);
        // should set getTokenId
        assertEq(test.getTokenId(idea), id);
    }

    // should revert if unoriginal idea
    function test_unoriginalIdea() public {
        // mint once
        test.mint(idea, v, r, s);
        // another mint should fail
        vm.expectRevert(IdeaBlock.UnoriginalIdea.selector);
        test.mint(idea, v, r, s);
    }

    // should revert if not during idea block
    function test_notIdeaBlock() public {
        vm.roll(test.ideaBlock() + 1);
        // diff block should fail
        vm.expectRevert(IdeaBlock.NotIdeaBlock.selector);
        test.mint(idea, v, r, s);
    }
}

contract DeployIdeaBlockTest is Test {
    // util for accurate gas snapshot
    function test_gas_deploy() public {
        deploy();
    }
}
