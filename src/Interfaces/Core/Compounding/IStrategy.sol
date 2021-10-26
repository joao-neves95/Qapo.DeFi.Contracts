// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

interface IStrategy {

    function getNotInvestedBalance() external view returns (uint256);

    function getInvestedBalance() external view returns (uint256);

    function getUnclaimedRewardBalance() external view returns (uint256);

    function beforeDeposit() external;

    function farm() external;

    function withdrawAllToVault() external;

}
