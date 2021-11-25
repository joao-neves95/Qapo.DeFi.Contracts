// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../Libraries/@openzeppelin/v4.4/utils/math/SafeMath.sol";

import "../../Interfaces/Core/Compounding/ILockedStrategy.sol";
import "./LockedStrategyVault.sol";

abstract contract LockedStrategyBase is ILockedStrategy, LockedStrategyVault {
    using SafeMath for uint256;

    address private rewardAssetAddress;

    constructor(
        address _underlyingAssetAddress,
        address _rewardAssetAddress
    ) LockedStrategyVault(_underlyingAssetAddress) {
        rewardAssetAddress = _rewardAssetAddress;
    }

    function getRewardAssetAddress() external view returns(address) {
        return rewardAssetAddress;
    }

    function getTvl() external view returns (uint256) {
        return this.getUninvestedBalance().add(this.getInvestedBalance());
    }

    function getInvestedBalance() virtual external view returns (uint256) {
        return 0;
    }

    function retire() external {
        // ...
        address payable owner = payable(owner());
        selfdestruct(owner);
    }

    function deployUnderlying() virtual external {
        require(false == true);
    }

    function withdrawAll() virtual external {}

    function withdraw(uint256 _amount) virtual external {}

    function farm() virtual external {
        require(false == true);
    }

}