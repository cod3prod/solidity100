// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
contract Q031 {
    function isAliceOrBob(string memory name) public pure returns (bool) {
        bytes32 hashedName = keccak256(abi.encodePacked(name));
        bytes32 hashedAlice = keccak256(abi.encodePacked("Alice"));
        bytes32 hashedBob = keccak256(abi.encodePacked("Bob"));
        if (hashedName == hashedAlice || hashedName == hashedBob) {
            return true;
        } else {
            return false;
        }
    }
}

// 3의 배수만 들어갈 수 있는 array를 구현하되, 3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
//  예) 3 → o , 9 → o , 15 → o , 30 → x
contract Q032 {
    uint[] public numbers;
    function addNumber(uint n) public {
        require(n % 3 == 0 && n % 10 != 0, "Invalid Number");
        numbers.push(n);
    }
}

// 이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
contract Q033 {
    struct User {
        string name;
        uint number;
        address addr;
        string birth;
    }

    mapping(string => User) public users;

    function addUser(
        string memory _name,
        uint _number,
        address _addr,
        string memory _birth
    ) public {
        users[_name] = User(_name, _number, _addr, _birth);
    }

    function getUserByName(
        string memory _name
    ) public view returns (User memory) {
        return users[_name];
    }
}

// 이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
contract Q034 {
    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[] public students;

    function addStudent(string memory _name, uint _number, uint _score) public {
        students.push(Student(_name, _number, _score));
    }

    function getAverage() public view returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < students.length; i++) {
            sum += students[i].score;
        }
        return sum / students.length;
    }
}

// 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
contract Q035 {
    uint[] public numbers;

    function addNumber(uint n) public {
        numbers.push(n);
    }

    function getNumbersWithOddIndex() public view returns (uint[] memory) {
        uint[] memory result = new uint[](numbers.length / 2);
        uint index;
        for (uint i = 1; i < numbers.length; i += 2) {
            result[index] = numbers[i];
            index++;
        }
        return result;
    }

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }
}

// high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
contract Q036 {
    enum Status {
        high,
        neutral,
        low
    }

    Status public status;
    uint public a;
    constructor(uint n) {
        a = n;
        setStatus();
    }

    function setStatus() public {
        if (a >= 7) {
            status = Status.high;
        } else if (a >= 4) {
            status = Status.neutral;
        } else {
            status = Status.low;
        }
    }

    function setNumber(uint n) public {
        a = n;
        setStatus();
    }
}

// 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
//  (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
contract Q037 {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function deposit() public payable {}

    function withdrawInWei(uint _wei) public onlyOwner {
        payable(msg.sender).transfer(_wei);
    }

    function withdrawInFinney(uint _finney) public onlyOwner {
        payable(msg.sender).transfer(_finney * 10 ** 15);
    }

    function withdrawInEther(uint _ether) public onlyOwner {
        payable(msg.sender).transfer(_ether * 1 ether);
    }
}

// 상태변수 a를 "A"로 설정하여 선언하세요. 이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
//  (힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
contract Q038 {
    string public a = "A";
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function changeToB() public onlyOwner {
        a = "B";
    }

    function changeToC() public onlyOwner {
        a = "C";
    }
}

// 특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
//  예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)

contract Q039 {
    function multipleCounter(uint n) public pure returns (uint[4] memory) {
        uint multipleOf2;
        uint multipleOf3;
        uint multipleOf5;
        uint multipleOf7;

        for (uint i = 1; i < n + 1; i++) {
            if (i % 2 == 0) {
                multipleOf2++;
            }
            if (i % 3 == 0) {
                multipleOf3++;
            }
            if (i % 5 == 0) {
                multipleOf5++;
            }
            if (i % 7 == 0) {
                multipleOf7++;
            }
        }
        return [multipleOf2, multipleOf3, multipleOf5, multipleOf7];
    }
}

// 숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요. 가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
//  예) [5,2,4,7,1] -> [1,2,4,5,7], 4 // [1,5,4,9,6,3,2,11] -> [1,2,3,4,5,6,9,11], 4,5 // [6,3,1,4,9,7,8] -> [1,3,4,6,7,8,9], 6
contract Q040 {
    uint[] public numbers;

    function addNumber(uint n) public {
        numbers.push(n);

        uint[] memory sortedNumbers = numbers;

        for (uint i = 0; i < sortedNumbers.length; i++) {
            for (uint j = i + 1; j < sortedNumbers.length; j++) {
                if (sortedNumbers[i] < sortedNumbers[j]) {
                    (sortedNumbers[i], sortedNumbers[j]) = (
                        sortedNumbers[j],
                        sortedNumbers[i]
                    );
                }
            }
        }

        numbers = sortedNumbers;
    }

    function getCenter() public view returns (uint[] memory) {
        require(numbers.length > 0, "There is no number");

        uint middleIndex = numbers.length / 2;
        uint[] memory result = new uint[](numbers.length % 2 == 0 ? 2 : 1);
        if (numbers.length % 2 == 0) {
            result[0] = numbers[middleIndex - 1];
            result[1] = numbers[middleIndex];
            return result;
        } else {
            result[0] = numbers[middleIndex];
            return result;
        }
    }

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }
}
