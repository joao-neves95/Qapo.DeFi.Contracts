// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

interface ITranferableERC20Position {

    function directPositionTransferAll(address recipient) external;

    function indirectPositionTransferAll(address recipient) external;

    function redeemPositionTransfer() external;

}
