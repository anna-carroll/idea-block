# IdeaBlock 💡🧊

IdeaBlock is an NFT contract which implements a single-block open mint for idea NFTs. `mint` is open during the block that the contract is deployed - the Idea Block. Only original ideas can be minted.
 
This idea is part of [Idea Guy Summer](https://twitter.com/john_c_palmer/status/1697649365299474806?s=20).

## Submitting Ideas 💡
to participate in the IdeaBlock open mint, idea guys must
- have an idea (hard part)
- hash the idea & sign it (convenience fn: `IdeaBlock.getHash(string idea)`
- submit the idea in plaintext + the r, s, v signature over its hash to Idea Guy DAO
- Idea Guy DAO will execute the Idea Block (see next section)
- one idea NFT per idea will be minted to the originating idea guy

## Executing the Idea Block 🧊
The Idea Block will be executed as a Flashbots bundle which
1. deploys the `IdeaBlock` contract
2. calls `mint` for each idea. Using a create2 deploy address, the `mint` transaction(s) can be constructed beforehand - see `script/DeployIdeaBlock.s.sol`.
3. burns any remaining gas in the block to ensure only ideas are contained in the Idea Block.

## Throughput

Gas benchmarking suggests deploy costs 892,975 gas and minting an idea of length 17 chars costs 131,949 gas. So, ((30,000,000 - 892,975) / 131,949) = approximately 220 ideas could fit in the Idea Block. As long as we use plaintext ideas, gas costs & throughput will depend on the length of ideas accepted.

## Potential Features
- implement a commit/reveal scheme so folks don't get their ideas stolen. minting with hashes instead of plaintext ideas would also save gas & increase throughput for the Idea Block
- implement a batched mint to simplify constructing the Idea Block

## Repo
### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Deploy

```shell
$ forge script DeployIdeaBlock --sig "run()" --rpc-url <your-rpc-url> --etherscan-api-key <your-etherscan-key> --private-key <your-deployer-key> --broadcast --verify
```
