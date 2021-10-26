// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.7;

import "../Libraries/@openzeppelin/v4.3/security/ReentrancyGuard.sol";
import "../Libraries/@openzeppelin/v4.3/token/ERC20/IERC20.sol";
import "../Libraries/@openzeppelin/v4.3/token/ERC20/ERC20.sol";
import "../Libraries/@openzeppelin/v4.3/token/ERC20/utils/SafeERC20.sol";
import "../Libraries/@openzeppelin/v4.3/utils/math/SafeMath.sol";

import "../Interfaces/Core/ITranferableERC20Position.sol";

abstract contract TranferableERC20Position is ITranferableERC20Position, ERC20, ReentrancyGuard {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
    }

    function directPositionTransferAll(address _recipient) external {
        IERC20 vaultToken = IERC20(address(this));

        directPositionTransfer(_recipient, vaultToken.balanceOf(msg.sender));
    }

    function directPositionTransfer(address _recipient, uint256 _amount) public nonReentrant {
        require(_amount > 0, "The amount to transfer to the new address must be more than 0.");

        IERC20 vaultToken = IERC20(address(this));
        vaultToken.safeTransferFrom( msg.sender, _recipient, _amount );
    }

    mapping(address => uint256) private unredeemedTokens;

    function indirectPositionTransferAll(address _recipient) external {
        IERC20 vaultToken = IERC20(address(this));
        uint256 transferAmount = vaultToken.balanceOf(msg.sender);

        indirectPositionTransfer( _recipient, transferAmount );
    }

    function indirectPositionTransfer(address _recipient, uint256 _amount) public nonReentrant {
        IERC20 vaultToken = IERC20(address(this));

        require(_amount > 0, "The amount to transfer to the new address must be more than 0.");
        require(_amount <= vaultToken.balanceOf(msg.sender), "Not enough balance.");

        unredeemedTokens[_recipient].add(_amount);
        vaultToken.safeTransferFrom( msg.sender, address(this), _amount );
    }

    function getUnredeemedPositionTranferAmount() public view returns (uint256) {
        return unredeemedTokens[msg.sender];
    }

    function redeemPositionTransfer() external nonReentrant {
        IERC20 vaultToken = IERC20(address(this));
        uint256 unredeemedAmount = getUnredeemedPositionTranferAmount();

        require(unredeemedAmount > 0, "There are no tokens to unredeem.");
        require(unredeemedAmount <= balanceOf(address(this)), "There are not enough tokens in circulation for a redemption (???).");

        unredeemedTokens[msg.sender] = 0;
        vaultToken.safeTransfer( msg.sender, unredeemedAmount );
    }

}
