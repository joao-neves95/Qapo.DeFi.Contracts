// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../../../Interfaces/External/_degen/ISalemMasterChef.sol";

import "../../LockedStratLpNoCompBase.sol";

contract LockedStratLpNoCompSalem is LockedStratLpNoCompBase {

    constructor(
        address _underlyingAssetAddress,
        address _rewardAssetAddress,
        address _unirouterAddress,
        address _chefAddress,
        uint256 _poolId,
        bool _keepToken0
    )
    LockedStratLpNoCompBase(
        _underlyingAssetAddress,
        _rewardAssetAddress,
        _unirouterAddress,
        _chefAddress,
        _poolId,
        _keepToken0
    )
    {
    }

    function getPendingRewardAmount() override external view returns (uint256) {
        return ISalemMasterChef(chefAddress).pendingSalem( poolId, address(this) );
    }
}
