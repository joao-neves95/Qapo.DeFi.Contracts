# Qapo.DeFi.Contracts

## Commands

### Flatten

E.g.: `npx flatten-sol src/Contracts/Compounding/Strategies/SushiSwap/SushiSwapLpLockedStrat.sol`
E.g.: `npx flatten-sol src/Contracts/Compounding/Strategies/_degen/..sol`

```
npx flatten-sol src/Contracts/Compounding/LockedStratVault.sol
npx flatten-sol src/Contracts/Compounding/LockedStratBase.sol
npx flatten-sol src/Contracts/Compounding/LockedStratLpBase.sol
npx flatten-sol src/Contracts/Compounding/LockedStratLpNoCompBase.sol
npx flatten-sol src/Contracts/Compounding/LockedStratSingleAssetNoCompBase.sol
```

## Notes

- Solidity max uint256: 115792089237316195423570985008687907853269984665640564039457584007913129639935
- Solidity min uint256: 000000000000000000000000000000000000000000000000000000000000000000000000000000

## Resources

### Uniswap Docs

- v2: https://docs.uniswap.org/protocol/V2/guides/smart-contract-integration/quick-start
- v3: https://docs.uniswap.org/protocol/reference/smart-contracts

### Examples

- https://ftmscan.com/address/0x4c3c20ec541a655feb72de0ac19ea2af351fb207#code

### Articles

- https://medium.com/scrappy-squirrels/estimating-smart-contract-costs-f65acf818c26
- https://dev.to/javier123454321/solidity-gas-optimization-pt1-4271
