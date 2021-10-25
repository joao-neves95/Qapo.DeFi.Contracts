// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

interface IStrategy {

    function getUnderlyingInvestedBalance() external view returns (uint256);

    function farm() external;

    function panic() external;

}
