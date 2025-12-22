// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract ABI {

    function encodeData(string memory text, uint256 number) public pure  returns(bytes memory,bytes memory){
        return (
            abi.encode(text,number),
            abi.encodePacked(text,number)
            );
    }
}