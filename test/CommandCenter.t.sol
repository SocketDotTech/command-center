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
    ISocket public rc;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER");

    address internal PAUSER_1 = 0x75bbC04fA183dd0ac75857a0400F93f766748f01;
    address internal DUMMY_PAUSER_1 = 0xbdca5aa542b488fF476776e11799fDaE41584392;
    address internal PAUSER_2 = 0xa5acBA07788f16B4790FCBb09cA3b7Fc8dd053A2;

    address internal owner = 0x5fD7D0d6b91CC4787Bcb86ca47e0Bd4ea0346d34;

    address internal socketRegistry = 0xc30141B657f4216252dc59Af2e7CdB9D8792e1B0;
    address internal nominee;

    function setUp() public {
        cc = new CommandCenter(socketRegistry);
        rc = ISocket(socketRegistry);

        vm.prank(owner);
        rc.transferOwnership(address(cc));
    }

    function testGrantPauserRole() public {
        cc.grantRole(PAUSER_ROLE, PAUSER_1);
        cc.grantRole(PAUSER_ROLE, PAUSER_2);
        assertTrue(cc.hasRole(PAUSER_ROLE, PAUSER_1));
        assertTrue(cc.hasRole(PAUSER_ROLE, PAUSER_2));
        assertFalse(cc.hasRole(PAUSER_ROLE, DUMMY_PAUSER_1));
    }

    function testRevokeRole() public {
        cc.revokeRole(PAUSER_ROLE, PAUSER_1);
        bool roleCheck = cc.hasRole(PAUSER_ROLE, PAUSER_1);
        assertFalse(roleCheck);
    }

	// in this one we try to transfer the ownership from the current owner
    // of command center to new owner
    function testOwnershipTransfer() public {
        assertTrue(cc.owner() == address(this));
        cc.nominateOwner(PAUSER_1);
        assertTrue(cc.nominee() == PAUSER_1);
        vm.prank(PAUSER_1);
        cc.claimOwner();
        assertTrue(cc.owner() == PAUSER_1);
    }

    function testAuthorisedCall() public {
        // calls addRoutes on registry
        cc.makeAuthorisedCall("0x02a9c05100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000001000000000000000000000000b6fb3062405985f700fa23758a3053162ddbefb900000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000");
        // ISocket.RouteData memory routeData = rc.routes(21);
        // console.logAddress(routeData.route);
    }
}