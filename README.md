非常棒的选择。对于有 **Java** 和 **Go** 背景的开发者来说，使用 **TypeScript** 开发 Hardhat 项目是绝对的“舒适区”。

JavaScript 的弱类型在处理金融相关的智能合约交互时是非常危险的（例如把字符串数字传成了整数，或者拼写错了函数名）。TypeScript 配合 **TypeChain** 插件，可以给你提供类似 Java 的**编译时检查**和 **IDE 智能提示**。

这是使用 TypeScript 配置 Hardhat 的完整指南。

---

### **1. 初始化 TypeScript 项目**

如果你是新开一个项目，Hardhat 的初始化向导已经内置了 TypeScript 选项。

```bash
npm init -y
npm install --save-dev hardhat
npx hardhat init

```

**关键步骤：**
在出现的选项中，**务必选择**：
`> Create a TypeScript project`

Hardhat 会自动帮你安装核心依赖，包括：

* `ts-node`: 让 Node 直接运行 TS 代码。
* `typescript`: TS 编译器。
* `@nomicfoundation/hardhat-toolbox`: 全家桶（包含 Ethers.js, Chai, Hardhat-Ethers 等）。

---

### **2. 核心差异：TypeChain (杀手级功能)**

Java 开发者最喜欢的功能来了。Hardhat 会根据你的 Solidity 合约（`.sol`），自动生成对应的 TypeScript 接口定义（`.d.ts`）。

这意味着：当你调用合约方法时，IDE 会告诉你这个方法需要什么类型的参数，返回值是什么类型。

**尝试编译一下：**

```bash
npx hardhat compile

```

你会发现项目根目录下多了一个 `typechain-types/` 文件夹。这里面就是根据 ABI 生成的 TS 类型定义。

---

### **3. 配置文件 (`hardhat.config.ts`)**

注意后缀变成了 `.ts`，并且我们使用 `import` 语法，拥有了类型提示。

```typescript
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL || "";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "";

// 显式声明配置对象的类型
const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: SEPOLIA_RPC_URL,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
    },
  },
};

export default config;

```

---

### **4. 编写强类型的测试脚本**

这是 TypeScript 优势最明显的地方。我们修改 `test/HelloWeb3.test.ts`。

注意看代码中的注释，体会与 JS 的不同：

```typescript
import { expect } from "chai";
import { ethers } from "hardhat";
// 引入自动生成的类型！这就像 Java 中引入生成的 POJO/Bean
import { HelloWeb3 } from "../typechain-types"; 

describe("HelloWeb3", function () {
  it("Should interact with types", async function () {
    // 1. 获取工厂
    const HelloWeb3Factory = await ethers.getContractFactory("HelloWeb3");
    
    // 2. 部署合约
    // 注意：这里得到的 hello 变量已经有了 HelloWeb3 的类型定义
    const hello = await HelloWeb3Factory.deploy("Start");
    
    // 等待部署完成 (ethers v6 语法)
    await hello.waitForDeployment();

    // 3. 调用方法
    // 这里的 .message() 会有自动补全，如果你拼写成 .msg() 编译器会直接报错！
    expect(await hello.message()).to.equal("Start");

    // 4. 修改状态
    const tx = await hello.updateMessage("End");
    await tx.wait();

    expect(await hello.message()).to.equal("End");
  });
});

```

---

### **5. 编写部署脚本 (`scripts/deploy.ts`)**

```typescript
import { ethers } from "hardhat";

async function main() {
  // 强类型带来的安全感
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;

  // 这里的 Lock 是指官方示例合约，你可以换成 HelloWeb3
  const lock = await ethers.deployContract("Lock", [unlockTime], {
    value: ethers.parseEther("0.001"), // 金额也需要特定类型
  });

  await lock.waitForDeployment();

  console.log(
    `Lock with 0.001 ETH and unlock timestamp ${unlockTime} deployed to ${lock.target}`
  );
}

// 标准的 Async/Await 错误处理模式
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

```

运行部署：

```bash
npx hardhat run scripts/deploy.ts --network localhost

```

---

### **6. 常用 TypeScript 开发技巧**

1. **自动修复 Imports**: 确保你的 VS Code 安装了 ESLint 插件。
2. **Solidity 变更后**: 每次修改 `.sol` 文件，记得运行 `npx hardhat compile` 来更新 `typechain-types`，否则 TS 会报错说找不到新加的方法。
3. **BigInt**: 在 Web3 和 TS 中，以太坊的大数字（如余额）通常使用 JS 的 `BigInt` 类型（例如 `1000n`）或者 Ethers 的 `BigNumber`，而不是普通的 `number`，防止精度丢失。

---

### **总结：为什么 Java 开发者应该选 TS + Hardhat**

| 特性 | JavaScript (弱类型) | TypeScript (强类型) | Java 开发者的感受 |
| --- | --- | --- | --- |
| **合约方法调用** | `contract.tranfer(to, val)` (拼写错不报错) | `contract.transfer(to, val)` (编译不过) | 像在调用 Java 类的方法 |
| **IDE 支持** | 只能靠记忆或看文档 | 点号(`.`)自动列出所有合约方法 | 像 IntelliJ IDEA 的补全 |
| **重构** | 修改合约方法名后，JS 测试代码很难找全 | TS 直接报红所有调用处 | 安全感拉满 |

**下一步建议：**
既然环境已经升级为 TypeScript，要不要尝试写一个**带有自定义结构体（Struct）**的 Solidity 合约，然后在 TypeScript 测试代码中尝试解析这个结构体？这能让你深刻体会 TypeChain 带来的便利。