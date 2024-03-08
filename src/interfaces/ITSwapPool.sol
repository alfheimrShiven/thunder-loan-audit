// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

interface ITSwapPool {
    // q Why are we getting price of the pool token only in wETH?
    function getPriceOfOnePoolTokenInWeth() external view returns (uint256);
}
