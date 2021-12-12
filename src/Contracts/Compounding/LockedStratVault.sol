// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../Libraries/@openzeppelin/v4.4/token/ERC20/IERC20.sol";
import "../../Libraries/@openzeppelin/v4.4/token/ERC20/utils/SafeERC20.sol";

import "../../Libraries/Core/PrivatelyOwnable.sol";
import "../../Interfaces/Core/Compounding/ILockedStratVault.sol";

abstract contract LockedStratVault is ILockedStratVault, PrivatelyOwnable {
    using SafeERC20 for IERC20;

    address internal underlyingAssetAddress;

    constructor(address _underlyingAssetAddress) {
        underlyingAssetAddress = _underlyingAssetAddress;
    }

    function getUndeployedBalance() public view returns (uint256) {
        return IERC20(underlyingAssetAddress).balanceOf(address(this));
    }

    function depositAll() external {
        this.deposit( IERC20(underlyingAssetAddress).balanceOf(msg.sender) );
    }

    function deposit(uint256 _amount) external {
        IERC20(underlyingAssetAddress).safeTransferFrom( msg.sender, address(this), _amount );
    }

    function withdrawAllUndeployed() external onlyOwner {
        IERC20 underlyingAssetContract = IERC20(underlyingAssetAddress);
        underlyingAssetContract.safeTransfer( msg.sender, underlyingAssetContract.balanceOf(address(this)) );
    }

    function untuckTokens(address _token) external onlyOwner {
        IERC20 tokenContract = IERC20(_token);
        tokenContract.safeTransfer( msg.sender, tokenContract.balanceOf(address(this)) );
    }

}
