// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

interface ILockedStrat {

    function getRewardAssetAddress() external view returns(address);

    function getTvl() external view returns (uint256);

    function getDeployedBalance() external view returns (uint256);

    function retire() external;

    function withdrawAll() external;

    function withdraw(uint256 _amount) external;

    function execute() external;

}