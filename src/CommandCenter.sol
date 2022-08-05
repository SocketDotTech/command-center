pragma solidity ^0.8.4;

import "./interfaces/ISocket.sol";
import "./utils/AccessControl.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract CommandCenter is AccessControl(msg.sender) {
	bytes32 public PAUSER = keccak256("PAUSER");

	event FailedToPause(uint routeId);

	// maxing to 1k, we can deploy a new command center once/if we reach there
	uint256 public constant MAX_ROUTES=1000; 

	ISocket immutable public socket;
	uint256 immutable public chainId;

	mapping (address => uint256) public noncePerPauser;
	
	constructor(address _socketRegistry) {
		socket= ISocket(_socketRegistry);
		chainId = block.chainid;
	}

 
	//////////////////// GUARDED BY PAUSERS ////////////////////
	function pause() external onlyRole(PAUSER) {
		_pause();
	}

	function pauseWithSig(address pauser,bytes calldata signature) external {
		// get the signer and make sure its replay safe, both by chain and by nonce
		address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(getDigest(pauser)), signature);
		// make sure the signer is a pauser
		if(!_hasRole(PAUSER, signer)) revert NoPermit(PAUSER); 

		// pause Socket registry
		_pause();

		// reward caller, dont care about the return value
		(msg.sender).call{value: address(this).balance}("");
	}	
	

	//////////////////// GUARDED BY OWNER ////////////////////
	function makeAuthorisedCall(bytes calldata data) external onlyOwner {
		address(socket).call(data);
	}


	function _pause() internal {
		for(uint i = 0; i < MAX_ROUTES; i++) {
			ISocket.RouteData memory route = socket.routes(i);
			if(route.route==address(0)) break;

			try	socket.disableRoute(i) {
				// do nothing
			}catch {
				emit FailedToPause(i);
			}
		}
	}

	function getMessageToSign(address pauser) public view returns(bytes memory) {
		return abi.encodePacked(chainId, noncePerPauser[pauser]+1);
	}

	function getDigest(address pauser) public view returns(bytes32) {
		return keccak256(getMessageToSign(pauser));
	}

    receive() external payable {}
    fallback() external payable {}
}
