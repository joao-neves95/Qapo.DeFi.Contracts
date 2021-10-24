// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

interface IStrategyVault {

    function getVaultTVL() external view returns (uint);

    function deposit() external;

    function withdraw() external;

    function pause() external;

    function panic() external;

    function unPause() external;

}
