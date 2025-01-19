// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
// 한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
contract Q071 {
    uint256 public a;
    uint256 public updatedAt;

    function setA(uint256 num) external {
        require(block.timestamp >= updatedAt + 600, "You cannot updated yet.");
        a = num;
        updatedAt = block.timestamp;
    }
}

// contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요. owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
// 예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner)
contract Q072 {
    address owner;
    uint256 value;

    function deposit() external payable {
        if (msg.value > value) {
            owner = msg.sender;
        }
    }

    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "You are not the owner");
        payable(owner).transfer(amount);
    }
}

// 위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
contract Q073 {
    address owner;
    mapping(address => uint256) balances;

    function deposit() external payable {
        if (msg.value + balances[msg.sender] > balances[owner]) {
            owner = msg.sender;
        }
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "You are not the owner");
        payable(owner).transfer(amount);
    }
}

// 어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요. 
//  예) 20 -> 22(20 + 2, 2는 20의 10%), 0 // 50 -> 55(50+5, 5는 50의 10%), 0 // 42 -> 46(42+4), 4 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) // 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
contract Q074 {
    function getNumber(uint256 num) external pure returns (uint256, uint256) {
        uint256 addedAmount = (num * 10) / 100; 
        uint256 finalAmount = num + addedAmount;
        
        uint256 integerPart = finalAmount; // 정수
        uint256 decimalPart = finalAmount - integerPart;  // 소수

        return (integerPart, decimalPart);
    }
}

// 문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
contract Q075 {
    function getString(string calldata _str, uint n) external pure returns(string memory) {
        string memory str = "";
        for(uint i = 0 ; i < n ; i++){
            str = string.concat(str, _str);
        }
        return str;
    }
}

// 숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. 
contract Q076 {
    function numToStr(uint num) external pure returns (string memory) {
        if (num == 0) {
            return "0";
        }

        bytes memory buffer;

        while (num > 0) {
            buffer = abi.encodePacked(uint8(48 + (num%10)), buffer);
            num /= 10;
        }

        return string(buffer);
    }
}

// 위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
import "@openzeppelin/contracts/utils/Strings.sol";
contract Q077 {
    function numToStr(uint num) external pure returns (string memory) {
        return Strings.toString(num);
    }
}

// 숫자만 들어갈 수 있는 array를 선언하세요. array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
contract Q078 {
    uint[] public arr;

    function push(uint n) external {
        arr.push(n);
    }

    function getNums() external view returns(uint[] memory) {
        return arr;
    }

    function checkNumbers() external view returns (bool) {
        uint len = arr.length;
        for(uint i = 0; i < len ; i++) {
            if(arr[i] >= 10 && arr[i] <= 25) {
                return true;
            }
        }
        return false;
    }
}

// 3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요. Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요. 학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요. 구현할 때는 Contract A를 import 하여 구현하세요
contract Q079_A {
    function max(uint[3] memory arr) internal pure returns (uint) {
        uint largest = arr[0];
        for (uint i = 1; i < arr.length; i++) {
            if (arr[i] > largest) {
                largest = arr[i];
            }
        }
        return largest;
    }
}

contract Q079_B is Q079_A {
    
    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[3] public students;

    function addStudents(string[3] memory names, uint[3] memory numbers, uint[3] memory scores) public {
        for (uint i = 0; i < 3; i++) {
            students[i] = Student(names[i], numbers[i], scores[i]);
        }
    }

    function getTopStudent() public view returns (Student memory) {
        uint[3] memory scores = [students[0].score, students[1].score, students[2].score];
        uint highestScore = max(scores);

        Student memory result;
        for (uint i = 0; i < 3; i++) {
            if (students[i].score == highestScore) {
                result = students[i];
            }
        }

        return result;
    }
}

// 지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 가장 먼저 들어온 것이 가장 마지막에 나갑니다. 이런 것들을FILO(First In Last Out)이라고도 합니다. 가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다. push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
contract Q080 {
    uint[] public queue;

    function enqueue(uint value) external {
        queue.push(value);
    }

    function dequeue() external{
        uint len = queue.length;
        require(len > 0, "The queue is empty");
        
        uint[] memory newQueue = new uint[](len-1);
        for(uint i = 0 ; i < len ; i++) {
            if(i == 0) {
                continue;
            } else {
                newQueue[i-1] = queue[i];
            }
        } 
        
        queue = newQueue;
    }

    function getQueue() external view returns(uint[] memory) {
        return queue;
    }
}