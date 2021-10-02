// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

import "../../Interfaces/Core/Compounding/IStrategy.sol";
import "./StrategyVault.sol";

contract StrategyLP is IStrategy, StrategyVault {

    function compound() override external {
    }

}
