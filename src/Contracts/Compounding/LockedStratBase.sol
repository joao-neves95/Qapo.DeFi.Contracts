// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../Libraries/@openzeppelin/v4.4/utils/math/SafeMath.sol";

import "../../Interfaces/Core/Compounding/ILockedStrat.sol";
import "./LockedStratVault.sol";

abstract contract LockedStratBase is ILockedStrat, LockedStratVault {
    using SafeMath for uint256;

    address internal rewardAssetAddress;

    constructor(
        address _underlyingAssetAddress,
        address _rewardAssetAddress
    ) LockedStratVault(_underlyingAssetAddress) {
        rewardAssetAddress = _rewardAssetAddress;
    }

    function getRewardAssetAddress() external view onlyOwner returns(address) {
        return rewardAssetAddress;
    }

    function getTvl() external view onlyOwner returns (uint256) {
        return this.getUndeployedBalance().add(this.getDeployedBalance());
    }

    function getDeployedBalance() virtual external view onlyOwner returns (uint256) {
        return 0;
    }

    function retire() external onlyOwner {
        // ...
        address payable owner = payable(owner());
        selfdestruct(owner);
    }

    function withdrawAll() virtual external onlyOwner {}
        require(false == true);
    }

    function withdraw(uint256 _amount) virtual external onlyOwner {}

    function withdraw(uint256 _amount) virtual external {}

    function execute() virtual external {
        require(false == true);
    }

}
