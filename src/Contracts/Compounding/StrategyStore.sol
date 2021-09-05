// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

struct Strategy {
    string name;
    string description;
    uint8 platform;
    address contractAddress;
}

contract StrategyStore {

    Strategy[] private strategies;

    // TODO: Owner only.
    function addStrategy(string calldata name, address contractAddress) external {
    }

    function getAllStrategies() external view returns (Strategy[] memory) {
        return strategies;
    }

}
