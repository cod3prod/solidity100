// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;


contract TEST5 {
/*
    로또 프로그램을 만드려고 합니다. 
    숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
    4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. (순서는 상관없음)

    참가 금액은 0.05이더입니다.

    당첨번호 : 7,3,2,5,B,C
    예시 1  : 8,2,4,7,D,A -> 맞은 번호 : 2     (1개)
    예시 2  : 9,1,4,2,F,B -> 맞은 번호 : 2,B   (2개)
    예시 3  : 2,3,4,6,A,B -> 맞은 번호 : 2,3,B (3개)
*/

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    string[6] private lottery = ['7', '3', '2', '5', 'B', 'C'];

    function deposit() public payable {} 

    function setNewLottery(string[6] memory _inputs) public {
        uint numCount;
        for (uint i = 0; i < 6; i++) {
            if (isDigit(_inputs[i])) numCount++;
        }

        if (numCount != 4) {
            revert("The count of numbers must be 4");
        }

        for (uint i = 0; i < 6; i++) {
            lottery[i] = _inputs[i];
        }
    }

    // 50,000,000,000,000,000
    function participate(string[6] memory _inputs) public payable {
        require(msg.value == 0.05 ether, "Fee is required");

        uint count = 0;

        bytes32[6] memory lotteryHashes;
        for (uint i = 0; i < 6; i++) {
            lotteryHashes[i] = keccak256(abi.encodePacked(lottery[i]));
        }

        for (uint i = 0; i < 6; i++) {
            for (uint j = 0; j < 6; j++) {
                if (lotteryHashes[i] == keccak256(abi.encodePacked(_inputs[j]))) {
                    count++;
                }
            }
        }

        if (count == 6) {
            payable(msg.sender).transfer(1 ether);
        } else if (count == 5) {
            payable(msg.sender).transfer(0.75 ether);
        } else if (count == 4) {
            payable(msg.sender).transfer(0.25 ether);
        } else if (count == 3) {
            payable(msg.sender).transfer(0.1 ether);
        } else {
            return;
        }
    }

    function isDigit(string memory str) internal pure returns (bool) {
        require(bytes(str).length == 1, "Input must be a single character");

        uint8 char = uint8(bytes(str)[0]);
        return (char >= 48 && char <= 57);  // 아스키코드
    }
}
