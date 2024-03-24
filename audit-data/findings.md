### [H-1] Erroneous `ThunderLoan::updateExchangeRate()` which makes the protocol think it has collected more fees than it actually has, blocking redeemptions and incorrectly setting exchange rates.

**Description**
In `ThunderLoan::deposit()` the exchange rate of the token being deposited in modified without even collecting any fee. The updated (increased) exchange rate makes the protocol think that the fee collected is more than actual, thus transfering a higher amount to the lp during redeemption, causing the redeemption to pause or transfer incorrect amounts.

**Impact**
Multiple impacts:
1> Redeem functionality is either blocked or transfers more than required underlying tokens to the liquidity providers, causing the protocol to collapse.
2> Rewards are incorrectly calculated.

**Proof of Concept**
1. LP deposits.
2. User takes and returns the flashloan.
3. LP cannot redeem due to insufficient underlying tokens with the protocol

<details>
<summary>Proof of Code</summary>
Place this test in `ThunderloanTest.t.sol`


```javascript
function testRedeem() external setAllowedToken hasDeposits {
        uint256 amountToBorrow = AMOUNT * 10; // 100e18
        uint256 calculatedFee = thunderLoan.getCalculatedFee(
            tokenA,
            amountToBorrow
        );
        vm.startPrank(user);
        tokenA.mint(address(mockFlashLoanReceiver), AMOUNT); // to pay the `calculatedFee`
        thunderLoan.flashloan(
            address(mockFlashLoanReceiver),
            tokenA,
            amountToBorrow,
            ""
        );
        vm.stopPrank();

        vm.startPrank(liquidityProvider);
        // Deposited amount = 1000e18
        // Calculate Fee = 300000000000000000 [3e17] = 0.3e18
        // Redeem amount = Deposited Amt + Calculated Fee = 1000.3e18
        thunderLoan.redeem(tokenA, type(uint256).max);
        assert(
            tokenA.balanceOf(liquidityProvider) >=
                DEPOSIT_AMOUNT + calculatedFee
        );
        vm.stopPrank();
    }
```
</details>

**Recommendated Mitigation:** Remove the following unncessary `updateExchangeRate()` call from the `ThunderLoan::deposit()`

```diff
 function deposit(
        IERC20 token,
        uint256 amount
    ) external revertIfZero(amount) revertIfNotAllowedToken(token) {
        AssetToken assetToken = s_tokenToAssetToken[token];
        uint256 exchangeRate = assetToken.getExchangeRate();
        uint256 mintAmount = (amount * assetToken.EXCHANGE_RATE_PRECISION()) /
            exchangeRate;
        emit Deposit(msg.sender, token, amount);
        assetToken.mint(msg.sender, mintAmount);
        
        // @audit-high
        // Flash loan exchange rate should not be changed during deposit(). 
-       uint256 calculatedFee = getCalculatedFee(token, amount);
-       assetToken.updateExchangeRate(calculatedFee);
        
        token.safeTransferFrom(msg.sender, address(assetToken), amount);
    }

```

