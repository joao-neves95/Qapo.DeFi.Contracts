// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../Libraries/@openzeppelin/v4.4/token/ERC20/IERC20.sol";
import "../../Libraries/@openzeppelin/v4.4/utils/math/SafeMath.sol";
import "../../Interfaces/External/UniswapV2RouterEth.sol";
import "../../Interfaces/External/IMasterChef.sol";

import "./LockedStratLpBase.sol";

contract LockedStratLpNoCompBase is LockedStratLpBase {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address[] internal rewardToUnderlyingRoute;

    address internal chefAddress;
    uint256 internal poolId;

    bool internal keepToken0;

    constructor(
        address _underlyingAssetAddress,
        address _rewardAssetAddress,
        address _unirouterAddress,
        address _chefAddress,
        uint256 _poolId,
        bool _keepToken0
    ) LockedStratLpBase (
        _underlyingAssetAddress,
        _rewardAssetAddress,
        _unirouterAddress
    ) {
        chefAddress = _chefAddress;
        poolId = _poolId;
        keepToken0 = _keepToken0;

        uniswapV2RouterEth = IUniswapV2RouterEth(_unirouterAddress);
        rewardToUnderlyingRoute = [_rewardAssetAddress, _underlyingAssetAddress];

        _giveAllowances();
    }

    function getDeployedBalance() override virtual public view returns (uint256) {
        // Not yet implemented.
        require(false == true);

        return 0;
    }

    function getPendingRewardAmount() override virtual external view returns (uint256) {
        // Not yet implemented.
        require(false == true);

        return 0;
    }

    function panic() override virtual external onlyOwner {
        IMasterChef(chefAddress).emergencyWithdraw( poolId );
        _removeAllowances();
    }

    function unpanic() override virtual external onlyOwner {
        _giveAllowances();
    }

    function retire() override virtual external onlyOwner {
        IMasterChef(chefAddress).withdraw( poolId, getDeployedBalance() );

        address payable ownerAddy = payable(msg.sender);
        selfdestruct(ownerAddy);
    }

    function withdrawAll() override virtual external onlyOwner {
        IMasterChef(chefAddress).withdraw( poolId, getDeployedBalance() );

        IERC20 underlyingAssetContract = IERC20(underlyingAssetAddress);
        underlyingAssetContract.safeTransfer( msg.sender, underlyingAssetContract.balanceOf(address(this)) );
    }

    function withdraw(uint256 _amount) override virtual external onlyOwner {
        IERC20 underlyingAssetContract = IERC20(underlyingAssetAddress);
        uint256 underlyingBal = underlyingAssetContract.balanceOf(address(this));

        if (underlyingBal < _amount) {
            IMasterChef(chefAddress).withdraw( poolId, _amount.sub(underlyingBal) );
            underlyingBal = underlyingAssetContract.balanceOf( address(this) );
        }

        if (underlyingBal > _amount) {
            underlyingBal = _amount;
        }

        underlyingAssetContract.safeTransfer( msg.sender, underlyingBal );
    }

    function deploy() override virtual external onlyOwner {
        IMasterChef(chefAddress).deposit( poolId, IERC20(underlyingAssetAddress).balanceOf( address(this) ) );
    }

    /// @dev A check if there is a reward should be done off-chain.
    function execute() override virtual external {
        IMasterChef(chefAddress).withdraw(poolId, 0);

        // Override to only dump the reward (no LP mint).
        addLiquidity();
    }

    function addLiquidity() override virtual internal {
        uint256 rewardBalance = IERC20(rewardAssetAddress).balanceOf(address(this));

        if (keepToken0) {
            uniswapV2RouterEth.swapExactTokensForTokens(
                rewardBalance, 0, rewardToLp0Route, address(this), block.timestamp
            );

        } else {
            uniswapV2RouterEth.swapExactTokensForTokens(
                rewardBalance, 0, rewardToLp1Route, address(this), block.timestamp
            );
        }
    }

    function _giveAllowances() virtual internal {
        IERC20(underlyingAssetAddress).safeApprove(chefAddress, type(uint256).max);
        IERC20(rewardAssetAddress).safeApprove(address(uniswapV2RouterEth), type(uint256).max);
    }

    function _removeAllowances() virtual internal {
        IERC20(underlyingAssetAddress).safeApprove(chefAddress, 0);
        IERC20(rewardAssetAddress).safeApprove(address(uniswapV2RouterEth), 0);
    }

}