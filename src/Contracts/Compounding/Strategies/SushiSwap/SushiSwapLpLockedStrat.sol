// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

// https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/BIFI/strategies/Sushi/StrategyPolygonSushiLP.sol
// https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/BIFI/strategies/Sushi/StrategyArbSushiLP.sol

import "../../LockedStratBase.sol";

contract SushiSwapLpLockedStrat is LockedStratBase {

    address internal lpToken0;
    address internal lpToken1;

    constructor(
        address _underlyingAssetAddress,
        address _rewardAssetAddress
    ) LockedStratBase(
        _underlyingAssetAddress,
        _rewardAssetAddress
    )
    {
        // lpToken0 = _lpToken0;
        // lpToken1 = _lpToken1;
    }

    function getDeployedBalance() override external view returns (uint256) {
    }

    function deployUnderlying() override external {
    }

    function withdrawAll() override external {}

    function withdraw(uint256 _amount) override external {}

    function execute() override external {
    }

    function addLiquidity() internal {
    }

}
