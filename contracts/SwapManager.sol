// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import './SwapManagerBase.sol';

contract SwapManager is SwapManagerBase {
    constructor()
        SwapManagerBase(
            ["UNISWAP", "SUSHISWAP"],
            [
                0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
                0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F
            ],
            [0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac]
        )
    {}
}