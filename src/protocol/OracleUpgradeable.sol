// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import {ITSwapPool} from "../interfaces/ITSwapPool.sol";
import {IPoolFactory} from "../interfaces/IPoolFactory.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract OracleUpgradeable is Initializable {
    address private s_poolFactory;

    function __Oracle_init(
        address poolFactoryAddress
    ) internal onlyInitializing {
        __Oracle_init_unchained(poolFactoryAddress);
    }

    function __Oracle_init_unchained(
        address poolFactoryAddress
    ) internal onlyInitializing {
        // @audit: missing zero address check for `poolFactoryAddress`
        s_poolFactory = poolFactoryAddress;
    }

    // q interacting with an external contract
    // q can the price be manipulated?
    // @audit-info: the tests for `getPool()` and `getPriceOfOnePoolTokenInWeith()` should be using forked tests for IPoolToken protocol instead of minimised mocks.
    function getPriceInWeth(address token) public view returns (uint256) {
        address swapPoolOfToken = IPoolFactory(s_poolFactory).getPool(token);
        return ITSwapPool(swapPoolOfToken).getPriceOfOnePoolTokenInWeth();
    }

    function getPrice(address token) external view returns (uint256) {
        return getPriceInWeth(token);
    }

    function getPoolFactoryAddress() external view returns (address) {
        return s_poolFactory;
    }
}
