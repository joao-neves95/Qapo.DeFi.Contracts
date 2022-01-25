// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.11;

import "../IMasterChef.sol";

interface IFrogMasterChef is IMasterChef {

    function pendingFrog(uint256 _pid, address _user) external view returns (uint256);

}