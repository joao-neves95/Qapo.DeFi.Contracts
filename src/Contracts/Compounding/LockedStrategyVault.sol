// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../Libraries/@openzeppelin/v4.4/access/Ownable.sol";
import "../../Libraries/@openzeppelin/v4.4/token/ERC20/IERC20.sol";
import "../../Libraries/@openzeppelin/v4.4/token/ERC20/utils/SafeERC20.sol";

import "../../Interfaces/Core/Compounding/ILockedStrategyVault.sol";

struct StrategiesInfo {
    address addr;
    IERC20 underlyingTokenContract;
}

// TODO: Only authorized users.
abstract contract LockedStrategyVault is Ownable {
    using SafeERC20 for IERC20;

    address private underlyingAssetAddress;
    IERC20 private underlyingAssetContract;

    constructor(address _underlyingAssetAddress) {
        underlyingAssetAddress = _underlyingAssetAddress;
        underlyingAssetContract = IERC20(_underlyingAssetAddress);
    }

    function getUnderlyingAssetAddress() external view returns(address) {
        return underlyingAssetAddress;
    }

    function getUninvestedBalance() external view returns (uint256) {
        return underlyingAssetContract.balanceOf(address(this));
    }

    function untuckTokens(address _token) external onlyOwner {
        IERC20 tokenContract = IERC20(_token);
        tokenContract.safeTransfer( msg.sender, tokenContract.balanceOf(address(this)) );
    }

    function depositAll() external {
        this.deposit( underlyingAssetContract.balanceOf(msg.sender) );
    }

    function deposit(uint256 _amount) external {
        underlyingAssetContract.safeTransferFrom( msg.sender, address(this), _amount );
    }

    function withdrawAllUninvested() external {
        this.withdrawUninvested( underlyingAssetContract.balanceOf(address(this)) );
    }

    function withdrawUninvested(uint256 _amount) external {
        underlyingAssetContract.safeTransfer( msg.sender, _amount );
    }

}
