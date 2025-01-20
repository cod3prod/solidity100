// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// a의 b승을 반환하는 함수를 구현하세요.
contract Q061 {
    function pow(uint a, uint b) public pure returns (uint) {
        return a ** b;
    }
}

// 2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
contract Q062 {
    modifier checkNum(uint a, uint b) {
        require(a < 10 && b < 10, "Invalid input");
        _;
    }

    function add(uint a, uint b) public pure checkNum(a, b) returns (uint) {
        return a + b;
    }

    function mul(uint a, uint b) public pure checkNum(a, b) returns (uint) {
        return a * b;
    }

    function pow(uint a, uint b) public pure checkNum(a, b) returns (uint) {
        return a ** b;
    }
}

// 2개 숫자의 차를 나타내는 함수를 구현하세요.
contract Q063 {
    function sub(uint a, uint b) public pure returns (uint) {
        return a - b > 0 ? a - b : b - a;
    }
}

// 지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
contract Q064 {
    function split(address _addr) public pure returns (bytes4[5] memory) {
        bytes20 addr = bytes20(_addr);

        bytes4[5] memory parts;
        for (uint i = 0; i < 5; i++) {
            parts[i] = bytes4(
                abi.encodePacked(
                    addr[i * 4],
                    addr[i * 4 + 1],
                    addr[i * 4 + 2],
                    addr[i * 4 + 3]
                )
            );
        }

        return parts;
    }
}

// 숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요. 그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
//  예) func A : input → 1,2,3 // output → 1,4,9 | func B : output 4 (1,4,9중 가운데 숫자)
contract Q065 {
    function pow(uint a) internal pure returns (uint) {
        return a ** 2;
    }

    function getNumbers(
        uint a,
        uint b,
        uint c
    ) public pure returns (uint, uint, uint) {
        return (pow(a), pow(b), pow(c));
    }

    function getMiddle(uint a, uint b, uint c) public pure returns (uint) {
        return b;
    }
}

// 특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
contract Q066 {
    function getDigit(uint n) public pure returns (uint) {
        if (n == 0) {
            return 1;
        }

        uint digit = 0;
        while (n > 0) {
            digit++;
            n /= 10;
        }

        return digit;
    }
}

// 자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
contract Q067_A {
    receive() external payable {}

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}

contract Q067_B {
    receive() external payable {}

    function deposit() external payable {}

    function transfer(address _addr, uint _amount) external {
        require(address(this).balance >= _amount, "Insufficient balance");
        payable(_addr).transfer(_amount);
    }
}

// 계승(팩토리얼)을 구하는 함수를 구현하세요. 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다.
//  예) 5 → 1*2*3*4*5 = 60, 11 → 1*2*3*4*5*6*7*8*9*10*11 = 39916800
contract Q068 {
    function factorial(uint n) public pure returns (uint) {
        uint result = 1;
        for (uint i = 1; i <= n; i++) {
            result *= i;
        }
        return result;
    }
}

// 숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
contract Q069 {
    function getString(
        uint a,
        uint b,
        uint c
    ) public pure returns (string memory) {
        string memory aStr = numToStr(a);
        string memory bStr = numToStr(b);
        string memory cStr = numToStr(c);
        return string.concat(aStr, " and ", bStr, " or ", cStr);
    }

    function numToStr(uint num) internal pure returns (string memory) {
        if (num == 0) {
            return "0";
        }

        bytes memory buffer;

        while (num > 0) {
            buffer = abi.encodePacked(uint8(48 + (num % 10)), buffer);
            num /= 10;
        }

        return string(buffer);
    }
}

// 번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 고객의 정보를 넣고 변화시키는 함수를 구현하세요.
contract Q070 {
    struct Customer {
        uint number;
        string name;
        bytes32 data;
    }

    function addCustomer(
        uint _number,
        string memory _name
    ) external pure returns (Customer memory) {
        Customer memory customer = Customer(
            _number,
            _name,
            keccak256(abi.encodePacked(_number, _name))
        );
        return customer;
    }
}
