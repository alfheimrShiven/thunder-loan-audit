// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

interface IPoolFactory {
    // qanswered Why are we using TSwap? What does it have to do with flash loans?
    // a TSwap is being used to get the value of a single token in wEth, which is used by `ThunderLoan::getCalculatedFee()`
    function getPool(address tokenAddress) external view returns (address);
}
