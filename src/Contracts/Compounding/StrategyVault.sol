// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

import "../../Interfaces/Core/Compounding/IStrategyVault.sol";

struct UserDeposit {
    uint blockNumber;
    uint amount;
}

contract StrategyVault is IStrategyVault {

    address private underlyingAssetAddress;

    mapping (address => UserDeposit) private userDeposits;
    mapping (uint => uint) private rewardsByBlockNumber;

    uint withdrawFee;
    uint withdrawFeeDuration = 5 days;

    bool isStopped = false;

    function getVaultTVL() override external view returns (uint) {
    }

    function getUserRewards() external view returns (uint) {
    }

    function deposit() external {
    }

    mapping (address => uint) withdrawRequests;
    // Only by the user.
    // Add request to the withdraw request list.
    function requestwithdraw(uint _withdrawAmount) external {
        withdrawRequests[msg.sender] += _withdrawAmount;
    }

    // Only by the owner.
    // Get amount from the requested withdraw list.
    function withdrawTransfer(address payable _destination) external {
        uint amount = withdrawRequests[_destination];
        withdrawRequests[_destination] = 0;

        // TODO: Review
        address(this).call{value: amount};
    }

    function panic() external {
    }
}
