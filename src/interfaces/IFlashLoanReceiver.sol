// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.20;

// @audit-low: Unused import
// Bad engineering practice to modify actual source code for mocks or tests. Pls import this directly in the mock/test file where used.
// import { IThunderLoan } from "./IThunderLoan.sol";

/**
 * @dev Inspired by Aave:
 * https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/interfaces/IFlashLoanReceiver.sol
 */
interface IFlashLoanReceiver {
    // @audit-info: Pls add natspec
    // q is the `token` the token being borrowed?
    function executeOperation(
        address token,
        uint256 amount,
        uint256 fee,
        address initiator,
        bytes calldata params
    ) external returns (bool);
}
