pragma solidity ^0.8.4;

import "./interfaces/ISocket.sol";
import "./utils/AccessControl.sol";

contract CommandCenter is AccessControl(msg.sender) {
    bytes32 public PAUSER = keccak256("PAUSER");

    event FailedToPause(uint256 routeId);

    // maxing to 1k, we can deploy a new command center once/if we reach there
    uint256 public constant MAX_ROUTES = 1000;

    ISocket public immutable socket;
    uint256 public immutable chainId;

    constructor(address _socketRegistry) {
        socket = ISocket(_socketRegistry);
        chainId = block.chainid;
    }

    //////////////////// GUARDED BY PAUSERS ////////////////////
    function pause() external onlyRole(PAUSER) {
        _pause(0);
    }

    function pauseStartingFrom(uint startIndex) external onlyRole(PAUSER) {
        _pause(startIndex);
    }

    //////////////////// GUARDED BY OWNER ////////////////////
    function makeAuthorisedCall(bytes calldata data) external onlyOwner {
        address(socket).call(data);
    }


    //////////////////// INTERNALS ////////////////////
    function _pause(uint startIdx) internal {
        for (uint256 i = startIdx; i < MAX_ROUTES; i++) {
           try socket.disableRoute(i) {
                // do nothing
            } catch {
                emit FailedToPause(i);
                break;
            }
        }
    }

    receive() external payable {}

    fallback() external payable {}
}
