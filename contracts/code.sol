// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {

    event Received(address sender, uint amount);

    receive() external payable { 
        emit Received(msg.sender,msg.value);
    }

    event FallbackCalled(address sender,uint around,bytes data);

    fallback() external payable {
        emit FallbackCalled(msg.sender,msg.value,msg.data);
    }
}