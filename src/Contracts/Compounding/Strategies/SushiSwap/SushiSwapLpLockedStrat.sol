// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

// https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/BIFI/strategies/Sushi/StrategyPolygonSushiLP.sol
// https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/BIFI/strategies/Sushi/StrategyArbSushiLP.sol

import "../../../../Libraries/@openzeppelin/v4.4/token/ERC20/IERC20.sol";

import "../../../../Interfaces/External/IUniswapV2Pair.sol";
import "../../../../Interfaces/External/UniswapV2RouterEth.sol";
import "../../../../Interfaces/External/SushiSwap/IMiniChefV2.sol";

import "../../LockedStratBase.sol";

contract SushiSwapLpLockedStrat is LockedStratBase {

    address private lpToken0;
    address private lpToken1;

    IUniswapV2Pair private uniswapV2Pair;
    IUniswapV2RouterEth private uniswapV2RouterEth;
    IMiniChefV2 private miniChefV2;
    uint256 private poolId;

    constructor(
        address _underlyingAssetAddress,
        address _rewardAssetAddress,
        uint256 _poolId,
        address _chefAddress,
        address _unirouterAddress
    ) LockedStratBase(
        _underlyingAssetAddress,
        _rewardAssetAddress
    )
    {
        poolId = _poolId;

        uniswapV2Pair = IUniswapV2Pair(underlyingAssetAddress);
        lpToken0 = uniswapV2Pair.token0();
        lpToken1 = uniswapV2Pair.token1();

        uniswapV2RouterEth = IUniswapV2RouterEth(_unirouterAddress);
        miniChefV2 = IMiniChefV2(_chefAddress);
    }

    function getDeployedBalance() override external view returns (uint256) {
    }

    function deployUnderlying() override external {
    }

    function withdrawAll() override external {}

    function withdraw(uint256 _amount) override external {}

    function execute() override external {
        miniChefV2.harvest(poolId, address(this));
    }

    function addLiquidity() private {
        // TODO: Swap reward token for /2 lpToken0 and /2 lpToken1.

        uniswapV2RouterEth.addLiquidity(
            lpToken0, lpToken1,
            IERC20(lpToken0).balanceOf(address(this)), IERC20(lpToken1).balanceOf(address(this)),
            1, 1,
            address(this),
            block.timestamp
        );
    }

}
