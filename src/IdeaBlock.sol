// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC721} from "solady/tokens/ERC721.sol";

contract IdeaBlock is ERC721 {
    // the Idea Block is the block that the contract was deployed at
    uint256 public immutable ideaBlock;
    // num tokens minted
    uint256 public count;
    // hash of plaintext idea => tokenId
    mapping(bytes32 => uint256) public hashToTokenId;
    // tokenId => plaintext idea
    mapping(uint256 => string) public tokenIdToIdea;

    // thrown when `mint` is attempted outside the idea block
    error NotIdeaBlock();
    // thrown when `mint` is attempted for a duplicate idea
    error UnoriginalIdea();

    constructor() {
        // instantiate the ideaBlock at deploy time
        ideaBlock = block.number;
    }

    // convenience function to find the tokenId
    // for a given plaintext idea
    function getTokenId(string memory idea) external view returns (uint256 tokenId) {
        tokenId = hashToTokenId[getHash(idea)];
    }

    function name() public pure override returns (string memory) {
        return "IdeaBlock";
    }

    function symbol() public pure override returns (string memory) {
        return "IDBLK";
    }

    // yes this is just an alias for keccak256
    function getHash(string memory idea) public pure returns (bytes32 hash) {
        hash = keccak256(abi.encodePacked(idea));
    }

    // TODO: better svg lel
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return tokenIdToIdea[tokenId];
    }

    // @notice mint an idea NFT
    // @param idea - the idea in plaintext, e.g. "Big Bird OnlyFans"
    // @param v - the v component of the signature over getHash(idea)
    // @param r - the r component of the signature over getHash(idea)
    // @param s - the s component of the signature over getHash(idea)
    function mint(string memory idea, uint8 v, bytes32 r, bytes32 s) external returns (uint256 id) {
        // throw if not minting during the Idea Block
        if (block.number != ideaBlock) revert NotIdeaBlock();
        // throw if the idea has been submitted before
        bytes32 hash = getHash(idea);
        if (hashToTokenId[hash] != 0) revert UnoriginalIdea();
        // ecrecover the guy that signed the idea
        address ideaGuy = ecrecover(hash, v, r, s);
        // mint the idea to the guy
        id = ++count;
        _mint(ideaGuy, id);
        // store token info
        tokenIdToIdea[id] = idea;
        hashToTokenId[hash] = id;
    }
}
