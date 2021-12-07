// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

// https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/BIFI/strategies/Sushi/StrategyPolygonSushiLP.sol
// https://github.com/beefyfinance/beefy-contracts/blob/master/contracts/BIFI/strategies/Sushi/StrategyArbSushiLP.sol

import "../../../../Libraries/@openzeppelin/v4.4/token/ERC20/IERC20.sol";
import "../../../../Libraries/@openzeppelin/v4.4/utils/math/SafeMath.sol";

import "../../../../Interfaces/External/IUniswapV2Pair.sol";
import "../../../../Interfaces/External/UniswapV2RouterEth.sol";
import "../../../../Interfaces/External/SushiSwap/IMiniChefV2.sol";

import "../../LockedStratBase.sol";

contract SushiSwapLpLockedStrat is LockedStratBase {
    using SafeMath for uint256;

    address private lpToken0;
    address private lpToken1;
    address[] private rewardToLp0Route;
    address[] private rewardToLp1Route;

    IUniswapV2Pair private uniswapV2Pair;
    IUniswapV2RouterEth private uniswapV2RouterEth;
    IMiniChefV2 private miniChefV2;
    uint256 private poolId;

    /// @param _poolId The index of the pool (inside IMiniChefV2's `.poolInfo`).
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
        rewardToLp0Route = [rewardAssetAddress, lpToken0];
        rewardToLp1Route = [rewardAssetAddress, lpToken1];

        uniswapV2RouterEth = IUniswapV2RouterEth(_unirouterAddress);
        miniChefV2 = IMiniChefV2(_chefAddress);
    }

    function getDeployedBalance() override external view onlyOwner returns (uint256) {
    }

    function deployUnderlying() override external {
    }

    function withdrawAll() override external {}

    function withdraw(uint256 _amount) override external onlyOwner {}

    function execute() override external {
        miniChefV2.harvest(poolId, address(this));
        addLiquidity();

        uint256 underlyingBalance = getUndeployedBalance();

        if (underlyingBalance > 0) {
            miniChefV2.deposit(poolId, underlyingBalance, address(this));
        }
    }

    function addLiquidity() internal {
        uint256 halfReward = IERC20(rewardAssetAddress).balanceOf(address(this)).div(2);

        if (lpToken0 != underlyingAssetAddress) {
            uniswapV2RouterEth.swapExactTokensForTokens(
                halfReward, 0, rewardToLp0Route, address(this), block.timestamp
            );
        }

        if (lpToken1 != underlyingAssetAddress) {
            uniswapV2RouterEth.swapExactTokensForTokens(
                halfReward, 0, rewardToLp1Route, address(this), block.timestamp
            );
        }

        uniswapV2RouterEth.addLiquidity(
            lpToken0, lpToken1,
            IERC20(lpToken0).balanceOf(address(this)), IERC20(lpToken1).balanceOf(address(this)),
            1, 1,
            address(this),
            block.timestamp
        );
    }

}
