// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20, ERC20Burnable, ERC20Pausable, AccessControl, ERC20Permit {
    // 定义角色：使用 keccak256 哈希值作为角色的唯一标识
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor(
        string memory name, 
        string memory symbol, 
        address defaultAdmin, 
        address initialMinter
    ) 
        ERC20(name, symbol) 
        ERC20Permit(name) 
    {
        // 1. 授予部署者(或指定地址)最高管理员权限
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
        
        // 2. 授予指定地址铸币权
        _grantRole(MINTER_ROLE, initialMinter);
        
        // 3. 授予指定地址暂停权
        _grantRole(PAUSER_ROLE, defaultAdmin);

        // 4. 初始铸造：给管理员发 100 万个币 (注意 18 位精度)
        _mint(defaultAdmin, 1000000 * 10 ** decimals());
    }

    // --- 核心功能 ---

    // 暂停合约：只有拥有 PAUSER_ROLE 的人可以调用
    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    // 恢复合约：只有拥有 PAUSER_ROLE 的人可以调用
    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // 铸造新币：只有拥有 MINTER_ROLE 的人可以调用
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    // --- 必要的 Override (这是 Solidity 多重继承的要求) ---

    // 在转账前执行的钩子函数
    // 每次转账(包括 mint 和 burn)都会触发这个函数
    // 我们在这里检查：如果合约被 paused，则禁止转账
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}