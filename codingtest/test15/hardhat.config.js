require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { PROVIDER, PVK, ETHERSCAN } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",

  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${PROVIDER}`,
      accounts: [PVK],
    },
  },

  etherscan: {
    apiKey: ETHERSCAN,
  },
};
