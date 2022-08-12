// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

// Tests
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/Script.sol";

// Contracts
import "../src/CommandCenter.sol";
import "../src/utils/AccessControl.sol";
import "../src/utils/Ownable.sol";
import "../src/interfaces/ISocket.sol";
import {ISocket} from "../src/interfaces/ISocket.sol";

contract ContractTest is Test {
    // Utils internal utils;
    CommandCenter public cc;
    ISocket public registryContract;

    address internal PAUSER_1 = 0x75bbC04fA183dd0ac75857a0400F93f766748f01;
    address internal PAUSER_2 = 0xa5acBA07788f16B4790FCBb09cA3b7Fc8dd053A2;

    address internal owner = 0x5fD7D0d6b91CC4787Bcb86ca47e0Bd4ea0346d34;
    address internal socketRegistry =
        0xc30141B657f4216252dc59Af2e7CdB9D8792e1B0;
    address internal nominee;

    function setUp() public {
        cc = new CommandCenter(socketRegistry);
        registryContract = ISocket(socketRegistry);

        vm.prank(owner);
        registryContract.transferOwnership(address(cc));
    }

    function testGrantPauserRole() public {
        cc.grantRole(keccak256("PAUSER"), PAUSER_1);
        cc.grantRole(keccak256("PAUSER"), PAUSER_2);
        bool roleCheck = cc.hasRole(
            keccak256("PAUSER"),
            PAUSER_1 
        );
        assertTrue(roleCheck);
        roleCheck = cc.hasRole(
            keccak256("PAUSER"),
            PAUSER_2
        );
        assertTrue(roleCheck);

        vm.prank(PAUSER_1);
        cc.pause();
    }

    function testRevokeRole() public {
        cc.revokeRole(keccak256("PAUSER"), PAUSER_1);
        bool roleCheck = cc.hasRole(
            keccak256("PAUSER"),
           PAUSER_1 
        );
        assertFalse(roleCheck);
    }

    function testGrantOwnerPauser() public {
        cc.grantRole(keccak256("PAUSER"), owner);

        bool roleCheck = cc.hasRole(
            keccak256("PAUSER"),
            owner
        );

        assertTrue(roleCheck);
    }

    // function testRouteStatus() public {
    //     bool route0IsEnabled = registryContract.routes(0).isEnabled;
    //     bool route1IsNotMiddleware = registryContract.routes(1).isMiddleware;

    //     assertTrue(route0IsEnabled);
    //     assertFalse(route1IsNotMiddleware);
    // }

    // function testMakeAuthorisedCall() public {
    //     commandCenterContract.makeAuthorisedCall(
    //         "0x02a9c0510000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000100000000000000000000000014ac5b3580dd1e546cd7287cd1fadba9a873662800000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000"
    //     );

    //     bool route21IsEnabled = registryContract.routes(21).isEnabled;
    //     assertTrue(route21IsEnabled);
    // }

    // function testPause() public {
    //     vm.prank(pauser1);
    //     commandCenterContract.pause();

    //     for (uint256 i = 0; i < 22; i++) {
    //         bool routeStatus = registryContract.routes(i).isEnabled;
    //         assertFalse(routeStatus);
    //     }
    // }
}
