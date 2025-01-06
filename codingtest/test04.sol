// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST4 {
/*
    간단한 게임이 있습니.
    유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
    참가할 때 참가비용 0.01ETH를 내야합니다. (payable 함수)
    4명까지만 들어올 수 있는 방이 있습니다. (array)
    선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

    예) 
    방 안 : "empty" 
    -- A 입장 --
    방 안 : A 
    -- B, D 입장 --
    방 안 : A , B , D 
    -- F 입장 --
    방 안 : A , B , D , F 
    A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
    방 안 : "empty" 

    유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
    예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

    유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환.
    게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    ---------------------------------------------------------------------------------------------------
    예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
*/

    struct User {
        uint number;
        string name;
        address payable addr;
        uint balance;
        uint score;
    }

    User public owner;
    User[] public users;
    User[] public room;

    constructor() {
        owner = User({
            number: 0,
            name: "admin",
            addr: payable(msg.sender),
            balance: 0,
            score: 0
        });

        users.push(owner);
    }

    // 유저 등록 기능
    function addUser(string memory _name) public {
        for (uint i = 0; i < users.length; i++) {
            if (users[i].addr == msg.sender) {
                revert("You already registered");
            }
        }

        User memory _u = User({
            number: users.length,
            name: _name,
            addr: payable(msg.sender),
            balance: 0,
            score: 0
        });
        users.push(_u);
    }

    // 유저 조회 기능
    function getUserByAddress(address _addr) public view returns (User memory) {
        for (uint i = 0; i < users.length; i++) {
            if (users[i].addr == _addr) {
                return users[i];
            }
        }
        revert("User Not Found");
    }

    // 유저 스코어 변경
    function setUserScoreByAddress(address _addr, uint _score) public {
        for (uint i = 0; i < users.length; i++) {
            if (users[i].addr == _addr) {
                users[i].score = _score;
                return;
            }
        }
        revert("User Not Found");
    }

    // 유저 잔고 변경
    function setUserBalanceByAddress(address _addr, uint _balance) public {
        for (uint i = 0; i < users.length; i++) {
            if (users[i].addr == _addr) {
                users[i].balance = _balance;
                return;
            }
        }
        revert("User Not Found");
    }

    // 게임 참가
    function participate() public {
        User memory _u = getUserByAddress(msg.sender);
        require(_u.balance >= 0.1 ether, "You must pay fee");

        for (uint i = 0; i < room.length; i++) {
            if (room[i].addr == msg.sender) {
                revert("You already participate");
            }
        }

        if (room.length < 3) {
            room.push(_u);
        } else if (room.length == 3) {
            for (uint i = 0; i < 3; i++) {
                uint newScore = room[i].score + 4 - i;
                setUserScoreByAddress(room[i].addr, newScore);
            }
            setUserScoreByAddress(_u.addr, _u.score + 1);
            delete room;
        } else {
            revert("Try again");
        }

        setUserBalanceByAddress(msg.sender, _u.balance - 0.1 ether);
    }

    // 입금
    function deposit() public payable {
        User memory _u = getUserByAddress(msg.sender);
        setUserBalanceByAddress(msg.sender, _u.balance + msg.value);
    }

    // 100,000,000,000,000,000
    // 일반 유저 인출
    function withdraw() public {
        User memory _u = getUserByAddress(msg.sender);
        require(_u.score >= 10, "Insufficient score");
        _u.addr.transfer((_u.score / 10) * 0.1 ether);
        setUserScoreByAddress(_u.addr, _u.score % 10);
    }

    // admin 인출
    function withdrawByAdmin(uint _amount) public {
        require(msg.sender == owner.addr, "You are not the owner");
        owner.addr.transfer(_amount * 1 ether);
    }
}
