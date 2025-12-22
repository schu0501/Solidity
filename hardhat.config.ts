import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
// 如果你需要可升级合约，解除下面这行的注释并运行 npm install @openzeppelin/hardhat-upgrades
import "@openzeppelin/hardhat-upgrades";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
    solidity: {
        compilers: [
            { version: "0.8.28" },
            { version: "0.8.24" },
            { version: "0.8.20" },
        ],
    },
    networks: {
        hardhat: {
            chainId: 31337,
        },
        localhost: {
            url: "http://127.0.0.1:8545",
            chainId: 31337,
        },
        // 如果你有 .env 配置了 Sepolia，这里可以解注
        sepolia: {
          url: process.env.SEPOLIA_RPC_URL || "",
          accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
        },
    },
};

export default config;