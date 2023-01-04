import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from 'dotenv'
dotenv.config();
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-etherscan";
import "@openzeppelin/hardhat-upgrades";


const RINKEBY_ALCHEMY_KEY = process.env.RINKEBY_ALCHEMY_KEY;
const GOERLI_ALCHEMY_KEY = process.env.GOERLI_ALCHEMY_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
// const OWNER2_KEY = process.env.OWNER2_KEY;


const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs:200,
      },
    },
  },
  networks: {
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${GOERLI_ALCHEMY_KEY}`,
      accounts: [`${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS ? true : false,
  }
};

export default config;
