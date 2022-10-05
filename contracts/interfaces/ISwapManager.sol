// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface ISwapManager {
    function bestOutputFixedInput( address _fromToken, address _toToken, uint256 _amountIn) external view returns (address[] memory bestPath, uint amountOut, uint routerIndex);
    function bestInputFixedOutput (address _fromToken, address _toToken, uint256 _amountOut) external view returns (address[] memory bestPath, uint amountIn, uint routerIndex);
}