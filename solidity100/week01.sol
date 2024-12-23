// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 더하기, 빼기, 곱하기, 나누기 그리고 제곱을 반환받는 계산기를 만드세요.
contract Q001 {
    uint state;

    function setState(uint num) public {
        state = num;
    }

    function add(uint num) public view returns(uint) {
        return state + num;
    }
    
    function sub(uint num) public view returns(uint) {
        return state - num;
    }

    function mul(uint num) public view returns(uint) {
        return state * num;
    }

    function div(uint num) public view returns(uint) {
        return state / num;
    }

    function square() public view returns(uint) {
        return state * state;
    }
}

// 2개의 Input값을 가지고 1개의 output값을 가지는 4개의 함수를 만드시오. 각각의 함수는 더하기, 빼기, 곱하기, 나누기(몫)를 실행합니다.
contract Q002 {
    function add(uint num1, uint num2) public pure returns (uint) {
        return num1 + num2;
    }

    function sub(uint num1, uint num2) public pure returns (uint) {
        return num1 - num2;
    }

    function mul(uint num1, uint num2) public pure returns (uint) {
        return num1 * num2;
    }

    function div(uint num1, uint num2) public pure returns (uint) {
        return num1 / num2;
    }
}

// 1개의 Input값을 가지고 1개의 output값을 가지는 2개의 함수를 만드시오. 각각의 함수는 제곱, 세제곱을 반환합니다.
contract Q003 {
    function square(uint num) public pure returns (uint) {
        return num * num;
    }

    function cube(uint num) public pure returns (uint) {
        return num * num * num;
    }
}

// 이름(string), 번호(uint), 듣는 수업 목록(string[])을 담은 student라는 구조체를 만들고 그 구조체들을 관리할 수 있는 array, students를 선언하세요.
contract Q004 {
    struct student {
        string name;
        uint number;
        string[] classes;
    }

    student[] students;
}

/*
아래의 함수를 만드세요
1~3을 입력하면 입력한 수의 제곱을 반환받습니다.
4~6을 입력하면 입력한 수의 2배를 반환받습니다.
7~9를 입력하면 입력한 수를 3으로 나눈 나머지를 반환받습니다.
*/
contract Q005 {
    function getNumber(uint num) public pure returns (uint) {
        if(num >= 7 && num <= 9){
            return num % 3;
        } else if (num >= 4 && num <= 6){
            return num * 2;
        } else if (num >= 1 && num <= 3){
            return num * num;
        } else {
            return 0;
        }
    }
}
// 숫자만 들어갈 수 있는 array numbers를 만들고 그 array안에 0부터 9까지 자동으로 채우는 함수를 구현하세요.(for 문)
contract Q006 {
    uint[] numbers;
    function setNumber() public {
        for(uint i = 0 ; i < 10 ; i++){
            numbers.push(i);
        }
    }
}

// 숫자만 들어갈 수 있는 array numbers를 만들고 그 array안에 0부터 5까지 자동으로 채우는 함수와 array안의 모든 숫자를 더한 값을 반환하는 함수를 각각 구현하세요.(for 문)
contract Q007 {
    uint[] numbers;
    function setNumber() public {
        for(uint i = 0 ; i < 6 ; i++) {
            numbers.push(i);
        }
    }

    function getSum() public view returns (uint) {
        uint sum;
        for(uint i = 0 ; i < numbers.length ; i++) {
            sum += numbers[i];
        }
        
        return sum;
    }
}

/*
아래의 함수를 만드세요
1~10을 입력하면 “A” 반환받습니다.
11~20을 입력하면 “B” 반환받습니다.
21~30을 입력하면 “C” 반환받습니다.
*/
contract Q008 {
    function getGrade(uint score) public pure returns (string memory) {
        if(score > 20 && score <= 30){
            return "C";
        } else if (score > 10 && score <= 20) {
            return "B";
        } else if (score >=1 && score <= 10) {
            return "A";
        } else {
            return "WRONG!";
        }
    }
}

// 문자형을 입력하면 bytes 형으로 변환하여 반환하는 함수를 구현하세요.
contract Q009 {
    function toBytes(string memory str) public pure returns (bytes memory) {
        return bytes(str);
    }
}

// 숫자만 들어가는 array numbers를 선언하고 숫자를 넣고(push), 빼고(pop), 특정 n번째 요소의 값을 볼 수 있는(get)함수를 구현하세요.
contract Q010 {
    uint[] numbers;

    function pushNum(uint num) public {
        numbers.push(num);
    }

    function popNum() public {
        numbers.pop();
    }

    function getNumByIndex(uint idx) public view returns (uint) {
        return numbers[idx];
    }
}