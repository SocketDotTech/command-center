import fs from "fs";
import "hardhat-preprocessor";
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-ethers";
import "xdeployer";

import "./tasks/deploy";

function getRemappings() {
  return fs
    .readFileSync("remappings.txt", "utf8")
    .split("\n")
    .filter(Boolean)
    .map((line) => line.trim().split("="));
}

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    sources: "./src", // Use ./src rather than ./contracts as Hardhat expects
    cache: "./cache_hardhat", // Use a different cache for Hardhat than Foundry
  },
  // This fully resolves paths for imports in the ./lib directory for Hardhat
  preprocess: {
    eachLine: (hre) => ({
      transform: (line: string) => {
        if (line.match(/^\s*import /i)) {
          getRemappings().forEach(([find, replace]) => {
            if (line.match(find)) {
              line = line.replace(find, replace);
            }
          });
        }
        return line;
      },
    }),
  },
  xdeploy: {
    contract: "CommandCenter",
    constructorArgsPath: "./deploy-args.ts",
    salt: "b6abd238ec67763ab9f423e85e9537a920c215ee9c2ce930d2063bc840229a64",
    signer: process.env.PRIVATE_KEY,
    networks: [
      "ethMain",
      "polygon",
      "gnosis",
      "arbitrumMain",
      "fantomMain",
      "optimismMain",
      "avalanche",
      "bscMain",
      "auroraMain",
      "goerli",
      "rinkeby",
      "ropsten",
      "arbitrumTestnet",
      "sokol",
      "mumbai",
    ],
    rpcUrls: [
      "https://main-light.eth.linkpool.io/",
      "https://rpc-mainnet.matic.network",
      "https://rpc.xdaichain.com",
      "https://arb1.arbitrum.io/rpc",
      "https://rpc.ftm.tools",
      "https://mainnet.optimism.io/",
      "https://rpc.ankr.com/avalanche",
      "https://bsc-dataseed1.binance.org",
      "https://mainnet.aurora.dev",
      "https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161",
      "https://rpc.ankr.com/eth_rinkeby",
      "https://rpc.ankr.com/eth_ropsten	",
      "https://rinkeby.arbitrum.io/rpc",
      "https://sokol.poa.network",
      "https://matic-mumbai.chainstacklabs.com",
    ],
    gasLimit: 1.2 * 10 ** 6,
  },
};

export default config;
