// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20("A Token", "A") {
    uint public timestamp;

    constructor() {
        timestamp = block.timestamp;
    }
    
    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function mint() external payable {
        uint _amount;
        if(block.timestamp < timestamp + 172800) {
            _amount = msg.value / (1 ether / 1000);
        } else {
            _amount = msg.value / (5 ether / 1000);
        }
    }
}