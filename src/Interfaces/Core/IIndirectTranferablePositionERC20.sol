// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

interface IIndirectTranferablePositionERC20 {

    function indirectPositionTransferAll(address recipient) external;

    function redeemPositionTransfer() external;

}
