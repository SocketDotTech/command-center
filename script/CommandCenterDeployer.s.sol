// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "../src/CommandCenter.sol";

contract CommandCenterDeployer is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        CommandCenter cc = new CommandCenter(0xc30141B657f4216252dc59Af2e7CdB9D8792e1B0);
        vm.stopBroadcast();
    }
}
