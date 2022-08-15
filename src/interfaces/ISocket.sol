pragma solidity ^0.8.4;

interface ISocket {
    function disableRoute(uint256 _routeId) external;

    struct RouteData {
        address route;
        bool isEnabled;
        bool isMiddleware;
    }

    function routes(uint256 _routeId) external returns (RouteData calldata);
    function owner() external returns(address);
    function transferOwnership(address newOwner) external;
}
