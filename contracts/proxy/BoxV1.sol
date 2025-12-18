// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract BoxV1 is Initializable,OwnableUpgradeable,UUPSUpgradeable {
    uint256 public val;

    constructor(){
        _disableInitializers();
    }

    function initialize() public initializer{
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function setVal(uint256 _val) public {
        val=_val;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner{}

}