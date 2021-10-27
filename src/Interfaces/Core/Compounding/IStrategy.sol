// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

interface IStrategy {

    function getTvl() external view returns (uint256);

    function getNotInvestedBalance() external view returns (uint256);

    function getInvestedBalance() external view returns (uint256);

    function getUnclaimedRewardBalance() external view returns (uint256);

    function withdrawAllToVault() external;

    function withdrawToVault(uint256 _amount) external;

    function panic() external;

    function retire() external;

    function beforeDeposit() external;

    function afterDeposit() external;

    function farm() external;

}
