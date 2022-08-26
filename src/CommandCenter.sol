pragma solidity ^0.8.4;

import "./interfaces/ISocket.sol";
import "./utils/AccessControl.sol";

contract CommandCenter is AccessControl(msg.sender) {
    bytes32 public constant PAUSER = keccak256("PAUSER");

    event FailedToPause(uint256 idx);
    event AuthorisedCallSuccessful();

    // maxing to 1k, we can deploy a new command center once/if we reach there
    uint256 public constant MAX_ROUTES = 1000;

    ISocket public immutable socket;

    constructor(address _socketRegistry) {
        socket = ISocket(_socketRegistry);
    }

    //////////////////// GUARDED BY PAUSERS ////////////////////
    function pause() external onlyRole(PAUSER) {
        _pause(0);
    }

    function pauseStartingFrom(uint256 startIndex) external onlyRole(PAUSER) {
        _pause(startIndex);
    }

    //////////////////// GUARDED BY OWNER ////////////////////
    function makeAuthorisedCall(bytes calldata data) external onlyOwner {
        (bool success, ) = address(socket).call(data);
        require(success, "execution failed");

        emit AuthorisedCallSuccessful(); 
    }

    //////////////////// INTERNALS ////////////////////
    function _pause(uint256 startIdx) internal {
        for (uint256 i = startIdx; i < MAX_ROUTES; i++) {
            try socket.disableRoute(i) {
                // do nothing
            } catch {
                emit FailedToPause(i);
                break;
            }
        }
    }
}
