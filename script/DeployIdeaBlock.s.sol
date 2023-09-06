// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <=0.9.0;

import {IdeaBlock} from "../src/IdeaBlock.sol";
import {Script} from "forge-std/Script.sol";

bytes32 constant salt = keccak256("idea guy summer");

function deploy() returns (IdeaBlock ib) {
    ib = new IdeaBlock{salt: salt}();
}

contract DeployIdeaBlock is Script {
    // actual deploy
    // create2 deploy the IdeaBlock contract at a deterministic address :~)
    function run() public returns (IdeaBlock ib) {
        vm.startBroadcast();
        ib = deploy();
        vm.stopBroadcast();
    }
}
