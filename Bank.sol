// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Bank{
    // receive() external payable {}

    // event CallLog(bytes input,bytes output);

    // function withdrawWithTransfer() external {
    //     payable (msg.sender).transfer(1 ether);
    // }

    // function withdrawWithSend() external {
    //     bool success = payable (msg.sender).send(1 ether);
    //     require(success,"Send failed");
    // }

    // function withdrawWithCall(bytes memory input)external {
    //     (bool success,bytes memory data) = payable (msg.sender).call{value: 1 ether}(input);
    //     require(success, "Call failed");
    //     emit CallLog(input,data);
    // }

    event Deposit(address indexed sender,uint amount);
    event Withdraw(address indexed receiver,uint amount);

    function deposit() external payable {
        emit Deposit(msg.sender,msg.value);
    }

    function withdraw(uint amount) external {
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender,amount);
    }
}

// contract BankUser {
//     Bank bank;

//     receive() external payable {}

//     constructor (address payable  _bank){
//         bank = Bank(_bank);
//     }

//     function withdrawWithTransfer() external {
//         bank.withdrawWithTransfer();
//     }

//     function withdrawWithSend() external {
//         bank.withdrawWithSend();
//     }

//     function withdrawWithCall(bytes memory input)external {
//         bank.withdrawWithCall(abi.encodePacked(input));
//     }

//     function testPay() external payable {}
// }