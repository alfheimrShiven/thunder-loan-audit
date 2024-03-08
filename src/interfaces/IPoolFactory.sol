// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

interface IPoolFactory {
    // q Why are we using TSwap? What does it have to do with flash loans?
    function getPool(address tokenAddress) external view returns (address);
}
