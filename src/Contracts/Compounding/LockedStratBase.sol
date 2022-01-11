// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../Libraries/@openzeppelin/v4.4/token/ERC20/IERC20.sol";
import "../../Libraries/@openzeppelin/v4.4/utils/math/SafeMath.sol";

import "../../Interfaces/Core/Compounding/ILockedStrat.sol";
import "./LockedStratVault.sol";

abstract contract LockedStratBase is ILockedStrat, LockedStratVault {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address internal rewardAssetAddress;

    constructor(
        address _underlyingAssetAddress,
        address _rewardAssetAddress
    ) LockedStratVault(_underlyingAssetAddress) {
        rewardAssetAddress = _rewardAssetAddress;
    }

    function getTvl() external view returns (uint256) {
        return this.getUndeployedBalance().add( this.getDeployedBalance() );
    }

    function getDeployedBalance() virtual external view returns (uint256) {
        return 0;
    }

    function getPendingRewardAmount() virtual external view returns (uint256) {
        return 0;
    }

    function panic() virtual external onlyOwner {
        IERC20 underlyingAssetContract = IERC20(underlyingAssetAddress);
        underlyingAssetContract.safeTransfer( msg.sender, underlyingAssetContract.balanceOf(address(this)) );
    }

    function unpanic() virtual external onlyOwner {
        // Not yet implemented.
        require(false == true);
    }

    function retire() virtual external onlyOwner {
        address payable owner = payable(owner());
        selfdestruct(owner);
    }

    function withdrawAll() virtual external onlyOwner {
        withdrawAllUndeployed();
    }

    function withdraw(uint256 _amount) virtual external onlyOwner {
        withdrawAllUndeployed();
    }

    function deploy() virtual external onlyOwner {
        // Not yet implemented.
        require(false == true);
    }

    function execute() virtual external {
        // Not yet implemented.
        require(false == true);
    }

}
