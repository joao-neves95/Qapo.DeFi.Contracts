// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

import "../../../Libraries/@openzeppelin/v4.4/token/ERC20/IERC20.sol";

interface ILockedStratVault {

    function getUnderlyingAssetAddress() external view returns(address);

    function getUndeployedBalance() external view returns (uint256);

    function untuckTokens(address _token) external;

    function depositAll() external;

    function deposit(uint256 _amount) external;

    function withdrawAllUndeployed() external;

    function withdrawUndeployed(uint256 _amount) external;

}
