// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/ISocket.sol";
import "./utils/AccessControl.sol";

contract CommandCenter is AccessControl(msg.sender) {
	bytes32 public PAUSER = keccak256("PAUSER");

	// setup multiple pauser roles 
	// setup only one owner role

	event FailedToPause(uint routeId);

	// TODO add fallback/receive
    receive() external payable {}

    fallback() external payable {}

	ISocket immutable public socket;
	
	// maxing to 10k, we can deploy a new command center once/if we reach there
	uint256 public constant MAX_ROUTES=10000; 

	constructor(address _socketRegistry, address owner) {
		socket= ISocket(_socket);
		nominateOwner(owner);
		grantRole(PAUSER, owner);
	}

	// make it only pauser
	function pause() external onlyRole(PAUSER) {
		_pause();
	}

	// accept signature
	// make sure the message on which the signature is accepted has a nonce so people cannot pause again and again
	function pauseWithSig(bytes calldata signature) external {
		// TODO disburse reward
		// check signature and make sure it matches a pauser

		// call pause

		// send ETH
		// just send whatever balance(this) has
	}	

	// make it onlyOwner
	function makeAuthorisedCall(bytes calldata data) external onlyOwner {
		address(socket).call(data);
	}

	function _pause() internal {
		for(uint i = 0; i < MAX_ROUTES; i++) {
			ISocket.RouteData calldata route = ISocket.routes(i);
			if(route.address==address(0)) break;

			try	ISocket.disableRoute(i) {
				// do nothing
			}catch {
				emit FailedToPause(i)
			}
		}
	}
}
