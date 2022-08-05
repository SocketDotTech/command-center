# Socket Command Center

This is the command center for Socket registry on all chains, the owner on the Socket contract would be directed to this contract

It allows us to seperate out the roles for Owner and Pauser, such that Pauser could be given out more freely while owner could be just the team.
Pauser will only have the ability to pause the system while the owner will have the ability to add new routes.

Pausers can be assigned the `PAUSER` role and once they have that they can either call
- `pauseWithSig` where they send their address along with a signature on the message keccak256(abi.encodePacked(chainId+noncePerPauser+1)), this function would also reward whatever `value` is present on the contract to the `msg.sender` incentivising bots to get this included in the chain asap. This method also allows you to generate a signature and assign the duty of sending the tx to relayers like defender  
- `pause` can only be called by the EOA which has be assigned the PAUSER role, no reward

There is only one `owner` to the system:
- can make authorised calls to socket via `makeAuthorisedCall` to add new routes etc
- can assign and revoke the `PAUSER` roles