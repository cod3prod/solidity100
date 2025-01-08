// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 3의 배수만 들어갈 수 있는 array를 구현하세요.
contract Q021 {
    uint[] public numbers;

    function addNum(uint n) public {
        if (n % 3 == 0) {
            numbers.push(n);
        } else {
            revert("You can push only multiple of 3");
        }
    }
}

// 뺄셈 함수를 구현하세요. 임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.
//  예) 2,5 input → 5-2=3(output)
contract Q022 {
    function sub(uint a, uint b) public pure returns (uint) {
        return a - b > 0 ? a - b : b - a;
    }
}

// 5의 배수라면 “A”를, 나머지가 1이면 “B”를, 나머지가 2면 “C”를, 나머지가 3이면 “D”, 나미저가 4면 “E”를 반환하는 함수를 구현하세요.
contract Q023 {
    function checkNumber(uint n) public pure returns (string memory) {
        if (n % 5 == 0) {
            return "A";
        } else if (n % 5 == 1) {
            return "B";
        } else if (n % 5 == 2) {
            return "C";
        } else if (n % 5 == 3) {
            return "D";
        } else {
            return "E";
        }
    }
}

// string을 input으로 받는 함수를 구현하세요. “Alice”가 들어왔을 때에만 true를 반환하세요.
contract Q024 {
    function isAlice(string memory name) public pure returns (bool) {
        if (
            keccak256(abi.encodePacked(name)) ==
            keccak256(abi.encodePacked("Alice"))
        ) {
            return true;
        } else {
            return false;
        }
    }
}

// 배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요.
contract Q025 {
    uint[] public numbers;

    function setNumber(uint n) public {
        for (uint i = n; i > 0; i--) {
            numbers.push(i);
        }

        numbers.push(0);
    }
}

// 홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 숫자를 넣었을 때 자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
contract Q026 {
    uint[] public odds;
    uint[] public evens;

    function setNumber(uint n) public {
        if (n % 2 == 0) {
            evens.push(n);
        } else {
            odds.push(n);
        }
    }
}

// string 과 bytes32를 key-value 쌍으로 묶어주는 mapping을 구현하세요. 해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.
contract Q027 {
    mapping(string => bytes32) public users;

    function addUser(string memory _name, string memory _pw) public {
        require(users[_name] == bytes32(0), "User already exists");
        users[_name] = keccak256(abi.encodePacked(_pw));
    }

    function deleteUser(string memory _name, string memory _pw) public {
        require(users[_name] != bytes32(0), "User does not exist");
        require(users[_name] == keccak256(abi.encodePacked(_pw)), "Invalid password");        
        delete users[_name];
    }

    function getUser(
        string memory _name,
        string memory _pw
    ) public view returns (bytes32) {
        require(users[_name] != bytes32(0), "User does not exist");
        require(users[_name] == keccak256(abi.encodePacked(_pw)), "Invalid password");

        return users[_name];
    }
}

// ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
contract Q028 {
    function hashUser(
        string memory _name,
        string memory _pw
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_name, _pw));
    }
}

// 숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
contract Q029 {
    uint public a;
    string public b;
    constructor() {
        a = 10;
        b = "A";
    }
}

// 임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요 (sorting 코드 응용 → 약간 까다로움)
//  예 : [2,6,7,4,5,1,9] → [9,7,6,5,4,2,1]
contract Q030 {
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

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }
}
