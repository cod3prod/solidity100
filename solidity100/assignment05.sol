// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 숫자만 들어갈 수 있으며 길이가 4인 배열을 (상태변수로)선언하고 그 배열에 숫자를 넣는 함수를 구현하세요. 배열을 초기화하는 함수도 구현하세요. (길이가 4가 되면 자동으로 초기화하는 기능은 굳이 구현하지 않아도 됩니다.)
contract Q041 {
    uint[4] public numbers;
    uint public index;

    function addNumber(uint n) external {
        require(index < 4, "Array is full");
        numbers[index] = n;
        index++;
    }

    function getNumbers() external view returns (uint[4] memory) {
        return numbers;
    }

    function clear() external {
        delete numbers;
        index = 0;
    }
}

// 이름과 번호 그리고 지갑주소를 가진 '고객'이라는 구조체를 선언하세요. 새로운 고객 정보를 만들 수 있는 함수도 구현하되 이름의 글자가 최소 5글자가 되게 설정하세요.
contract Q042 {
    struct Customer {
        string name;
        uint number;
    }

    uint public totalCount;

    mapping(address => Customer) public customers;

    function addCustomer(string memory _name) external {
        require(bytes(_name).length >= 5, "Name too short");
        require(
            bytes(customers[msg.sender].name).length == 0,
            "Customer already exists"
        );

        customers[msg.sender] = Customer(_name, totalCount + 1);
        totalCount++;
    }
}

// 은행의 역할을 하는 contract를 만드려고 합니다. 별도의 고객 등록 과정은 없습니다. 해당 contract에 ether를 예치할 수 있는 기능을 만드세요. 또한, 자신이 현재 얼마를 예치했는지도 볼 수 있는 함수 그리고 자신이 예치한만큼의 ether를 인출할 수 있는 기능을 구현하세요.
//  힌트 : mapping을 꼭 이용하세요.
contract Q043 {
    mapping(address => uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}

// string만 들어가는 array를 만들되, 4글자 이상인 문자열만 들어갈 수 있게 구현하세요.
contract Q044 {
    string[] public strings;

    function addString(string memory _string) external {
        require(bytes(_string).length >= 4, "String too short");
        strings.push(_string);
    }
}

// 숫자만 들어가는 array를 만들되, 100이하의 숫자만 들어갈 수 있게 구현하세요.
contract Q045 {
    uint[] public numbers;

    function addNumber(uint n) external {
        require(n <= 100, "Number too big");
        numbers.push(n);
    }
}

// 3의 배수이거나 10의 배수이면서 50보다 작은 수만 들어갈 수 있는 array를 구현하세요.
//  (예 : 15 -> 가능, 3의 배수 // 40 -> 가능, 10의 배수이면서 50보다 작음 // 66 -> 가능, 3의 배수 // 70 -> 불가능 10의 배수이지만 50보다 큼)
contract Q046 {
    uint[] public numbers;

    function addNumber(uint n) external {
        require(n % 3 == 0 || (n % 10 == 0 && n < 50), "Invalid number");
        numbers.push(n);
    }
}

// 배포와 함께 배포자가 owner로 설정되게 하세요. owner를 바꿀 수 있는 함수도 구현하되 그 함수는 owner만 실행할 수 있게 해주세요.
contract Q047 {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function changeOwner(address _owner) external onlyOwner {
        require(_owner != address(0), "Invalid address");
        owner = _owner;
    }
}

// A라는 contract에는 2개의 숫자를 더해주는 함수를 구현하세요. B라고 하는 contract를 따로 만든 후에 A의 더하기 함수를 사용하는 코드를 구현하세요.
contract Q048_A {
    function add(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }
}

contract Q048_B is Q048_A {
    function useAdd(uint a, uint b) external pure returns (uint) {
        return add(a, b);
    }
}

// 긴 숫자를 넣었을 때, 마지막 3개의 숫자만 반환하는 함수를 구현하세요.
//  예) 459273 → 273 // 492871 → 871 // 92218 → 218
contract Q049 {
    function lastThree(uint n) public pure returns (uint) {
        return n % 1000;
    }
}

// 숫자 3개가 부여되면 그 3개의 숫자를 이어붙여서 반환하는 함수를 구현하세요.
//  예) 3,1,6 → 316 // 1,9,3 → 193 // 0,1,5 → 15
contract Q050_1 {
    function concat(uint a, uint b, uint c) public pure returns (uint) {
        return a * 100 + b * 10 + c;
    }
}

// 응용 문제 : 3개 아닌 n개의 숫자 이어붙이기
contract Q050_2 {
    function concat(uint[] memory nums) public pure returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < nums.length; i++) {
            sum *= 10;
            sum += nums[i];
        }
        return sum;
    }
}
