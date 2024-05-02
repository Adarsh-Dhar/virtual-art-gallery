
require("@nomiclabs/hardhat-ethers");
require('@nomicfoundation/hardhat-toolbox');
const fs = require('fs');
// const infuraId = fs.readFileSync(".infuraid").toString().trim() || "";

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat:{
      chainId : 11155111
    },
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/ttO_pNTAABnXF_9T1g7sSRQfRN1wbcip", // Replace with the actual RPC endpoint for the Sepolia testnet
      accounts: [ "56a96c57ac92b2d35cd073ce2a81415ab31fbb7181df929069a125384c83b7fd" ]
    }
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};
