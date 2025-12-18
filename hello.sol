
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Hello3Dot0 {
    // string public hello = "hello 3.0!";

    // int public account = -1*2**255;

    // uint public account2 = 1*2**256-1;

    // bool public flag = true;

    // address public address3 =0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    // bytes32 public b2 = hex"1000";

    // enum Status {
    //     Create,
    //     Approve,
    //     Hello
    // }

    // function sayHello(string memory name) public pure returns (string memory){
    //     return string.concat("hello ",name);
    // }
    //1.状态变量默认存在storage中
    struct Item {
        uint256 id;
        string name;
    }

    mapping (uint256 => Item) public items;

    //_name存在callData中，来自外部调用不需要修改
    function createItem(uint256 _id,string calldata _name) external {
        //2. memory:在内存中创建一个临时的结构体
        //我们可以在这里修改memory Item，不会影响区块链上的状态，直到写入到storage
        Item memory memoryItem = Item(_id,_name);

        //将 Memory 中的数据复制到storage
        items[_id] = memoryItem;
    }

    function updateItemName(uint256 _id,string calldata _newName) external {
        // storage作为指针
        // storageItem是一个指向item[_id]的指针
        // 修改storageItem会直接修改区块链数据
        Item storage storageItem = items[_id];

        storageItem.name = _newName;
    }

    function badPractice(uint256 _id) external view {
        // 如果使用memory，则会从storage拷贝一份副本到内存
        // 修改localCopy不会影响到items[_id]
        Item memory localCopy = items[_id];
        localCopy.id=999;
    }
}