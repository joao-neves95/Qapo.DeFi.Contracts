// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

struct UserDeposit {
    uint blockNumber;
    uint amount;
}

contract StrategyVault {

    mapping (address => UserDeposit) userDeposits;
    mapping (uint => uint) rewardsByBlockNumber;

    bool isStopped = false;

    function getUserRewards() external view returns (uint) {
    }

    function deposit() external {}

    mapping (address => uint) withdrawalRequests;
    // Only by the user.
    // Add request to the withdrawal request list.
    function requestWithdrawal(uint _withdrawalAmount) external {
        withdrawalRequests[msg.sender] += _withdrawalAmount;
    }

    // Only by the owner.
    // Get amount from the requested withdrawal list.
    function withdrawalTransfer(address payable _destination) external {
        uint amount = withdrawalRequests[_destination];
        withdrawalRequests[_destination] = 0;

        // TODO: Review
        address(this).call{value: amount};
    }

    function panic() external {
    }
}
