// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "hardhat/console.sol";
import "./interfaces/ISwapManager.sol";

abstract contract SwapManagerBase is ISwapManager {

    uint256 lastUpdatedAt;
    bool updated = false;
    uint256 public constant N_DEX = 2;

    string[N_DEX] public dexes = ["UNISWAP", "SUSHISWAP"];
    address[N_DEX] public routers;
    address[N_DEX] public factories;

    constructor(
        string[2] memory _dexes,
        address[2] memory _routers,
        address[2] memory _factories
    ) {
        dexes = _dexes;
        routers = _routers;
        factories = _factories;
    }

    function bestOutputFixedInput(
        address _fromToken,
        address _toToken,
        uint256 _amountIn
    ) external virtual override view returns ( 
        address[] memory bestPath,
        uint amountOut,
        uint routerIndex
    ){
        require(_fromToken != address(0) && _toToken != address(0), "INVALID_TOKEN");
        require(_amountIn > 0, "INVALID_AMOUNT");

        address[] memory firstPath = new address[](2);
        firstPath[0] = _fromToken;
        firstPath[1] = _toToken;

        address[] memory secondPath = new address[](3);
        secondPath[0] = _fromToken;
        secondPath[1] = IUniswapV2Router02(routers[0]).WETH();
        secondPath[2] = _toToken;

        for (uint i = 0; i < N_DEX; ++i) {
            (uint256 maxAmount, address[] memory path) = findBestOutTrade(_amountIn, routers[i], firstPath, secondPath);
            if(i == 0) {
                amountOut = maxAmount;
                bestPath = path;
                routerIndex = i;
            } else {
                if(amountOut < maxAmount) {
                    amountOut = maxAmount;
                    bestPath = path;
                    routerIndex = i;
                }
            }
        }
    }

    function bestInputFixedOutput (
        address _fromToken,
        address _toToken,
        uint256 _amountOut
    ) external virtual override view returns (
        address[] memory bestPath,
        uint amountIn,
        uint routerIndex
    ) {
        require(_fromToken != address(0) && _toToken != address(0), "INVALID_TOKEN");
        require(_amountOut > 0, "INVALID_AMOUNT");
        
        address[] memory firstPath = new address[](2);
        firstPath[0] = _fromToken;
        firstPath[1] = _toToken;

        address[] memory secondPath = new address[](3);
        secondPath[0] = _fromToken;
        secondPath[1] = IUniswapV2Router02(routers[0]).WETH();
        secondPath[2] = _toToken;

        for (uint i = 0; i < N_DEX; ++i) {
            (uint256 minAmount, address[] memory path) = findBestInTrade(_amountOut, routers[i], firstPath, secondPath);
            if(i == 0) {
                amountIn = minAmount;
                bestPath = path;
                routerIndex = i;
            } else {
                if(amountIn > minAmount) {
                    amountIn = minAmount;
                    bestPath = path;
                    routerIndex = i;
                }
            }
        }
    }

    function findBestOutTrade(
        uint256 amountIn,
        address routerAddr,
        address[] memory firstPath,
        address[] memory secondPath
    ) internal view returns (
        uint256 maxAmountOut,
        address[] memory path
    ){
        uint256[] memory firstAmountArr = IUniswapV2Router02(routerAddr).getAmountsOut(amountIn, firstPath);
        uint256 firstAmountOut = firstAmountArr[firstAmountArr.length - 1];
        
        uint256[] memory secondAmountArr = IUniswapV2Router02(routerAddr).getAmountsOut(amountIn, secondPath);
        uint256 secondAmountOut = secondAmountArr[secondAmountArr.length - 1];
        
        if(firstAmountOut > secondAmountOut) {
            maxAmountOut = firstAmountOut;
            path = firstPath;
        } else {
            maxAmountOut = secondAmountOut;
            path = secondPath;
        }
    }

    function findBestInTrade(
        uint256 amountOut,
        address routerAddr,
        address[] memory firstPath,
        address[] memory secondPath
    ) internal view returns (
        uint256 minAmountIn,
        address[] memory path
    ){
        uint256[] memory firstAmountArr = IUniswapV2Router02(routerAddr).getAmountsIn(amountOut, firstPath);
        uint256 firstAmountIn = firstAmountArr[0];

        uint256[] memory secondAmountArr = IUniswapV2Router02(routerAddr).getAmountsIn(amountOut, secondPath);
        uint256 secondAmountIn = secondAmountArr[0];

        if(firstAmountIn < secondAmountIn) {
            minAmountIn = firstAmountIn;
            path = firstPath;
        } else {
            minAmountIn = secondAmountIn;
            path = secondPath;
        }
    }
}