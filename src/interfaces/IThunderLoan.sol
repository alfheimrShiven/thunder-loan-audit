// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// @audit-info: This interface is not implemented by ThunderLoan.sol
interface IThunderLoan {
    function repay(address token, uint256 amount) external;
}
