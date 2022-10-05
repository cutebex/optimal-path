
const { ethers, network } = require("hardhat")
const { expect } = require("chai")

describe("Hello SwapManager", function () {
  let swapmanager
  let oraclemanager

  let USD = ethers.utils.getAddress("0xdAC17F958D2ee523a2206206994597C13D831ec7")
  let USDC = ethers.utils.getAddress("0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48")
  let WBTC = ethers.utils.getAddress("0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599")
  let LEO = ethers.utils.getAddress("0x2AF5D2aD76741191D15Dfe7bF6aC92d4Bd912Ca3")
  let ZERO = ethers.utils.getAddress("0x0000000000000000000000000000000000000000");

  before(async () => {
    const SwapManager = await ethers.getContractFactory("SwapManager")
    swapmanager = await SwapManager.deploy()
    await swapmanager.deployed()

    const OracleManager = await ethers.getContractFactory("OracleManager")
    oraclemanager = await OracleManager.deploy(USDC, WBTC)
    await oraclemanager.deployed()
  })

  it ("Swap bestOutputFixedInput Test", async () => {
    await expect(swapmanager.bestOutputFixedInput(ZERO, WBTC, 20000)).to.be.revertedWith("INVALID_TOKEN")
    await expect(swapmanager.bestOutputFixedInput(USD, WBTC, 0)).to.be.revertedWith("INVALID_AMOUNT")

    const input = await swapmanager.bestOutputFixedInput(USD, WBTC, 20000);
    console.log("In bestOutputFixedInput, amountOut is ", input.amountOut);
    console.log("In bestOutputFixedInput, bestPath is ", input.bestPath);
    console.log("In bestOutputFixedInput, routerIndex is ", input.routerIndex);
  })

  it ("Swap bestInputFixedOutput Test", async () => {
    await expect(swapmanager.bestInputFixedOutput(ZERO, WBTC, 20000)).to.be.revertedWith("INVALID_TOKEN")
    await expect(swapmanager.bestInputFixedOutput(USD, WBTC, 0)).to.be.revertedWith("INVALID_AMOUNT")
    
    output = await swapmanager.bestInputFixedOutput(USD, WBTC, 200)
    console.log("In bestInputFixedOutput, amountIn is ", output.amountIn);
    console.log("In bestInputFixedOutput, bestPath is ", output.bestPath);
    console.log("In bestInputFixedOutput, routerIndex is ", output.routerIndex);
  })

  it("Oracle Consult Test", async() => {
    let day = 1000 * 60 * 60 * 24 * 2
    await network.provider.request({
      method: 'evm_increaseTime',
      params: [day],
    })
    await oraclemanager.update()
    await oraclemanager.consult(USDC, 100000)
    await oraclemanager.consult(WBTC, 100000)
  })

  it("Oracle Period Not Elapsed Test", async() => {
    await expect(oraclemanager.update()).to.be.revertedWith("PERIOD_NOT_ELAPSED")
  })

  it("INVALID TOKEN", async() => {
    let day = 1000 * 60 * 60 * 24 * 2
    await network.provider.request({
      method: 'evm_increaseTime',
      params: [day],
    })
    await oraclemanager.update()
    await expect(oraclemanager.consult(LEO, 10)).to.be.revertedWith('INVALID_TOKEN')
  })
})