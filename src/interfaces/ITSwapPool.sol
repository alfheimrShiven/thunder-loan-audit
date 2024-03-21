// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

interface ITSwapPool {
    // qanswered Why are we getting price of the pool token only in wETH?
    // ans: we shouldn't be getting price in wETH. Instead the price/fee should be returned in the specific token being borrowed.
    // So if a user borrows USDC -> the fee should be charged in USDC only, not wETH.
    function getPriceOfOnePoolTokenInWeth() external view returns (uint256);
}
