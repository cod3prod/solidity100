// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
contract Q51 {
    uint[] public numbers;

    function addNum(uint n) external {
        numbers.push(n);
    }

    function returnNum() external view returns (uint) {
        uint len = numbers.length;
        require(len > 2, "Not enough numbers");

        uint first = type(uint).min;
        uint second = type(uint).min;
        uint third = type(uint).min;

        for (uint i = 0; i < len; i++) {
            if(first > numbers[i]) {
                third = second;
                second = first;
                first = numbers[i];
            } else if (second > numbers[i]) {
                third = second;
                second = numbers[i];
            } else if (third > numbers[i]) {
                third = numbers[i];
            } else {
                continue;
            }
        }
        return third;
    }
}

// 자동으로 아이디를 만들어주는 함수를 구현하세요. 이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.
contract Q52 {
    function createId(
        string memory name,
        uint birth
    ) external view returns (bytes10) {
        bytes32 hash = keccak256(abi.encodePacked(name, birth, msg.sender));
        return bytes10(hash);
    }
}

// 시중에는 A,B,C,D,E 5개의 은행이 있습니다. 각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
//  힌트 : 이중 mapping을 꼭 이용하세요.
contract Q53 {
    enum Bank {
        A,
        B,
        C,
        D,
        E
    }

    mapping(Bank => mapping(address => uint)) public balances;

    function deposit(Bank bank, uint amount) external {
        balances[bank][msg.sender] += amount;
    }

    function withdraw(Bank bank, uint amount) external {
        require(balances[bank][msg.sender] >= amount, "Insufficient balance");
        balances[bank][msg.sender] -= amount;
    }
}

// 기부받는 플랫폼을 만드세요. 가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.
// 힌트 : 굳이 mapping을 만들 필요는 없습니다.
contract Q54 {
    address public top;

    constructor() {
        top = msg.sender;
    }

    mapping(address => uint) public balances;
    
    event TopChanged(address _top, uint _balance);

    function donate() external payable {
        balances[msg.sender] += msg.value;

        if (balances[msg.sender] > balances[top]) {
            top = msg.sender;
            emit TopChanged(top, balances[top]);
        }
    }
}

// 배포와 함께 owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요. owner가 sub_owner를 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 한다면 owner의 동의가 필요하게 구현하세요.
contract Qfrom055to057 {
    address public owner;
    address public sub_owner;
    mapping(address => bool) public canChangeOwner;
    bool public canChangeSubOwner;
    constructor() {
        owner = msg.sender;
        sub_owner = msg.sender;
    }

    function changeOwner(address _owner) external {
        require(
            canChangeOwner[owner] && canChangeOwner[sub_owner],
            "It's not OK."
        );
        canChangeOwner[owner] = false;
        canChangeOwner[sub_owner] = false;
        owner = _owner;
    }

    function changeSubOwner(address _sub_owner) external {
        require(canChangeSubOwner, "It's not OK.");
        sub_owner = _sub_owner;
        canChangeSubOwner = false;
    }

    function permissionForChangingOwner() external {
        require(msg.sender == owner || msg.sender == sub_owner, "It's not OK.");
        canChangeOwner[msg.sender] = true;
    }

    function permissionForChangingSubOwner() external {
        require(msg.sender == owner, "It's not OK.");
        canChangeSubOwner = true;
    }
}

// A contract에 a,b,c라는 상태변수가 있습니다. a는 A 외부에서는 변화할 수 없게 하고 싶습니다. b는 상속받은 contract들만 변경시킬 수 있습니다. c는 제한이 없습니다. 각 변수들의 visibility를 설정하세요.
// 부모 계약
contract Q058_Parent {
    uint private a; // 외부에서 변화 x
    uint internal b; // 상속 받은 contract만 변경가능
    uint public c; // 제한 x

    constructor(uint _a, uint _b, uint _c) {
        a = _a;
        b = _b;
        c = _c;
    }

    function getA() external view returns (uint) {
        return a;
    }

    function getB() external view returns (uint) {
        return b;
    }

    function setC(uint _c) external {
        c = _c;
    }
}

contract Q058_Child is Q058_Parent {
    constructor(uint _a, uint _b, uint _c) Q058_Parent(_a, _b, _c) {}

    function setB(uint _b) external {
        b = _b;
    }
}

// 현재시간을 받고 2일 후의 시간을 설정하는 함수를 같이 구현하세요.
contract Q059 {
    uint public futureTime;

    function setFutureTime() external {
        futureTime = block.timestamp + 2 days; // Solidity에서 1일은 `1 days`로 표현 가능
    }

    function getFutureTime() external view returns (uint) {
        return futureTime;
    }

    function getCurrentTime() external view returns (uint) {
        return block.timestamp;
    }
}

// 방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다. 특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.
//  예약시스템은 운영하지 않아도 됩니다. 과거의 일만 기록한다고 생각하세요.
//  힌트 : 날짜는 그냥 숫자로 기입하세요. 예) 2023년 5월 27일 → 230527
contract Q060 {
    mapping(uint => address[3][2]) public times; // time -> rooms

    function setRooms(
        uint _time,
        uint _roomIndex,
        address[] memory _people
    ) external {
        require(_people.length <= 3, "Too many people");
        require(_roomIndex < 2, "Invalid room index");

        for (uint i = 0; i < _people.length; i++) {
            times[_time][_roomIndex][i] = _people[i];
        }

        for (uint i = _people.length; i < 3; i++) {
            times[_time][_roomIndex][i] = address(0);
        }
    }
}
