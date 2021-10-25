// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

import "../../Libraries/@openzeppelin/v4.3/token/ERC20/IERC20.sol";
import "../../Libraries/@openzeppelin/v4.3/utils/math/SafeMath.sol";

import "../../Interfaces/Core/Compounding/IStrategyVault.sol";
import "../../Interfaces/Core/Compounding/IStrategy.sol";

struct UserDeposit {
    uint blockNumber;
    uint amount;
}

contract StrategyVault is IStrategyVault {
    using SafeMath for uint256;

    address underlyingAssetAddress;

    IERC20 underlyingAssetContract;

    address strategyAddress;

    IStrategy strategyContract;

    address governorAddress;

    address feesReceiverAddress;

    address farmerAddress;

    // #region PRIVATE METHODS

    function _setUnderlyingAsset(address _address) internal {
        underlyingAssetAddress = _address;
    }

    function _setStrategyContract(address _address) internal {
        // TODO: Withdraw all the strategy funds back to the vault.
        strategyAddress = _address;
        strategyContract = IStrategy(_address);
    }

    // #endregion PRIVATE METHODS

    // #region PUBLIC METHODS

    function getVaultBalance() public view returns (uint256) {
        return underlyingAssetContract.balanceOf( address(this) );
    }

    function getVaultTvl() external view returns (uint256) {
        if (address(strategyAddress) == address(0)) {
            // No strategy is set.
            return getVaultBalance();
        }

        return getVaultBalance().add( strategyContract.getUnderlyingInvestedBalance() );
    }

    function farm() external {
        strategyContract.farm();
    }

    // #endregion PUBLIC METHODS

}
