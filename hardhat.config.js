require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config()
require('solidity-coverage')
const accounts = [...Array(50).keys()].map(x=>{return "ACCOUNT"+x}).map(x=>{return process.env[x]}).filter((x)=>{return x!==undefined})

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more



/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = { 
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
      allowUnlimitedContractSize: false,
      timeout: 1000000,
      forking: {
        url: 'https://eth-mainnet.g.alchemy.com/v2/bMPtjoaH5fJRB9uRqkpJxbIHJn3ZkBes'
      }
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: false,
            runs: 200
          }
        }
      },
      {
        version: "0.6.2"
      },
      {
        version: "0.6.6"
      },
      {
        version: "0.5.16"
      },
      {
        version: "0.8.0"
      }
    ]
  },

  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 300000000
  },
  plugins: ["solidity-coverage"]
}

