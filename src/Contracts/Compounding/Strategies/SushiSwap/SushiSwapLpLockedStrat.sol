// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../../../Interfaces/External/IUniswapV2Pair.sol";
import "../../../../Interfaces/External/UniswapV2RouterEth.sol";
import "../../../../Interfaces/External/SushiSwap/IMiniChefV2.sol";

import "../../LockedStratLpBase.sol";

contract SushiSwapLpLockedStrat is LockedStratLpBase {

    IMiniChefV2 private miniChefV2;
    address chefAddress;
    uint256 private poolId;

    /// @param _poolId The index of the pool (inside IMiniChefV2's `.poolInfo`).
    constructor(
        address _underlyingAssetAddress,
        address _rewardAssetAddress,
        uint256 _poolId,
        address _chefAddress,
        address _unirouterAddress
    ) LockedStratLpBase(
        _underlyingAssetAddress,
        _rewardAssetAddress,
        _unirouterAddress
    )
    {
        chefAddress = _chefAddress;
        poolId = _poolId;
        miniChefV2 = IMiniChefV2(_chefAddress);
    }

    function getDeployedBalance() override external view onlyOwner returns (uint256) {
        (uint256 _amount, ) = IMiniChefV2(chefAddress).userInfo(poolId, address(this));
        return _amount;
    }

    function withdrawAll() override external onlyOwner {}

    function withdraw(uint256 _amount) override external onlyOwner {}

    function execute() override external {
        miniChefV2.harvest(poolId, address(this));

        addLiquidity();

        uint256 underlyingBalance = getUndeployedBalance();

        if (underlyingBalance > 0) {
            miniChefV2.deposit(poolId, underlyingBalance, address(this));
        }
    }
}
