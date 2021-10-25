// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

interface IStrategyVault {

    function getVaultBalance() external view returns (uint256);

    function getVaultTvl() external view returns (uint256);

    function getUnderlyingAssetAddress() external view returns(address);

    function getStrategyAddress() external view returns(address);

    function deposit(uint256 _amount) external;

    function withdraw(uint256 _amount) external;

    function farm() external;

    function pause() external;

    function panic() external;

    function unPause() external;

}
