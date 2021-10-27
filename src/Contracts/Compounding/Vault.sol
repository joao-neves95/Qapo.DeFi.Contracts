// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

import "../../Libraries/@openzeppelin/v4.3/security/Pausable.sol";
import "../../Libraries/@openzeppelin/v4.3/security/ReentrancyGuard.sol";
import "../../Libraries/@openzeppelin/v4.3/token/ERC20/IERC20.sol";
import "../../Libraries/@openzeppelin/v4.3/token/ERC20/ERC20.sol";
import "../../Libraries/@openzeppelin/v4.3/token/ERC20/utils/SafeERC20.sol";
import "../../Libraries/@openzeppelin/v4.3/utils/math/SafeMath.sol";

import "../../Interfaces/Core/Compounding/IVault.sol";
import "../../Interfaces/Core/Compounding/IStrategy.sol";
import "../../Contracts/IndirectTranferablePositionERC20.sol";

contract Vault is IVault, IndirectTranferablePositionERC20, Pausable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address underlyingAssetAddress;

    IERC20 underlyingAssetContract;

    address strategyAddress;

    IStrategy strategyContract;

    address governorAddress;

    address feesReceiverAddress;

    address farmerAddress;

    constructor(
        string memory _name,
        string memory _symbol,
        address _underlyingAssetAddress,
        address _strategyAddress
    ) IndirectTranferablePositionERC20(_name, _symbol) {
        _setUnderlyingAsset(_underlyingAssetAddress);
        _setStrategyContract(_strategyAddress);
    }

    // #region PRIVATE METHODS

    function _setUnderlyingAsset(address _address) internal {
        underlyingAssetAddress = _address;
        underlyingAssetContract = IERC20(_address);
    }

    function _setStrategyContract(address _address) internal {
        // TODO: Withdraw all the strategy funds back to the vault.
        strategyAddress = _address;
        strategyContract = IStrategy(_address);
    }

    /// @notice Deploys/transfers the available underling asset to the Strategy.
    function _deployAvailableUnderlyingToStrategy() internal {
        underlyingAssetContract.safeTransfer( strategyAddress, getVaultBalance() );
    }

    // #endregion PRIVATE METHODS

    // #region PUBLIC METHODS

    /// @dev Gets the available underlying asset balance of this Vault, not deployed to the strategy.
    function getVaultBalance() public view returns (uint256) {
        return underlyingAssetContract.balanceOf( address(this) );
    }

    /// @dev Gets the Total Value Locked, taking into account both the Vault and Strategy balances.
    function getVaultTvl() public view returns (uint256) {
        if (address(strategyAddress) == address(0)) {
            // No strategy is set.
            return getVaultBalance();
        }

        return getVaultBalance().add( strategyContract.getInvestedBalance() );
    }

    function getUnderlyingAssetAddress() external view returns(address) {
        return underlyingAssetAddress;
    }

    function getStrategyAddress() external view returns(address) {
        return strategyAddress;
    }

    function farm() external whenNotPaused {
        strategyContract.farm();
    }

    function pause() public {
        _pause();
    }

    function unpause() public {
        _unpause();
    }

    function panic() external {
        pause();
    }

    function unpanic() external {
        unpause();
    }

    function depositAll() external nonReentrant {
        _deposit( underlyingAssetContract.balanceOf(msg.sender) );
    }

    function deposit(uint256 _amount) external nonReentrant {
        _deposit( _amount );
    }

    function _deposit(uint256 _amount) internal whenNotPaused {
        require(_amount > 0, "The deposit amount must be higher than 0.");

        strategyContract.beforeDeposit();

        uint256 initialTvl = getVaultTvl();

        underlyingAssetContract.safeTransferFrom(msg.sender, address(this), _amount);
        _deployAvailableUnderlyingToStrategy();

        uint256 newTvl = getVaultTvl();
        _amount = newTvl.sub(initialTvl); // Additional check for deflationary tokens.

        if (totalSupply() > 0) {
            // From here the "amount" variable refers to the Vault shares to mint, instead of the underlying deposit amount.
            _amount = ( _amount.mul(totalSupply()) ).div(initialTvl);
        }

        _mint(msg.sender, _amount);
    }

    function withdrawAll() external {
    }

    function withdraw(uint256 _amount) external {
        require(_amount > 0, "The withdrawal amount must be higher than 0.");
    }

    // #endregion PUBLIC METHODS

}
