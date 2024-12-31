// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// uint 형이 들어가는 array를 선언하고, 짝수만 들어갈 수 있게 걸러주는 함수를 구현하세요.
contract Q011 {
    uint[] public numbers;
    function addNum(uint num) public {
        require(num % 2 == 0, "You cannot push odd numbers.");
        numbers.push(num);
    }
}

// 숫자 3개를 더해주는 함수, 곱해주는 함수 그리고 순서에 따라서 a*b+c를 반환해주는 함수 3개를 각각 구현하세요.
contract Q012 {
    function sum(uint a, uint b, uint c) public pure returns(uint) {
        return a+b+c;
    }
    
    function mul(uint a, uint b, uint c) public pure returns(uint) {
        return a*b*c;
    }
    
    function mulThenAdd(uint a, uint b, uint c) public pure returns(uint) {
        return a*b+c;
    }
}

// 3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
contract Q013 {
    function dividedBy3(uint num) public pure returns(string memory) {
        if(num % 3 == 0) {
            return "A";
        } else if (num % 3 == 1) {
            return "B";   
        } else {
            return "C";
        }
    }
}

// 학번, 이름, 듣는 수험 목록을 포함한 학생 구조체를 선언하고 학생들을 관리할 수 있는 array를 구현하세요. array에 학생을 넣는 함수도 구현하는데 학생들의 학번은 1번부터 순서대로 2,3,4,5 자동 순차적으로 증가하는 기능도 같이 구현하세요.
contract Q014 {
    struct Student {
        string name;
        uint number;
        string[] subjects;
    }

    Student[] public students;

    function addStudent(string memory _name, string[] memory _subjects) public {
        Student memory _s = Student({
            name: _name,
            number: students.length+1,
            subjects: _subjects
        });
        students.push(_s);
    }
}

// 배열 A를 선언하고 해당 배열에 0부터 n까지 자동으로 넣는 함수를 구현하세요. 
contract Q015 {
    uint[] public A;
    function setNumbers(uint n) public {
        for(uint i = 0 ; i <= n ; i++){
            A.push(i);
        }
    }
}

// 숫자들만 들어갈 수 있는 array를 선언하고 해당 array에 숫자를 넣는 함수도 구현하세요. 또 array안의 모든 숫자의 합을 더하는 함수를 구현하세요.
contract Q016 {
    uint[] public numbers;

    function addNumber(uint num) public {
        numbers.push(num);
    }

    function getTotalSum() public view returns(uint) {
        uint len = numbers.length;
        uint sum;
        for(uint i = 0 ; i < len ; i++){
            sum += numbers[i];
        }
        return sum;
    }
}

// string을 input으로 받는 함수를 구현하세요. 이 함수는 true 혹은 false를 반환하는데 Bob이라는 이름이 들어왔을 때에만 true를 반환합니다. 
contract Q017 {
    function isBob(string memory name) public pure returns(bool) {
        if(keccak256(abi.encodePacked("Bob")) == keccak256(abi.encodePacked(name))) {
            return true;
        } else {
            return false;
        }
    }
}

// 이름을 검색하면 생일이 나올 수 있는 자료구조를 구현하세요. (매핑) 해당 자료구조에 정보를 넣는 함수, 정보를 볼 수 있는 함수도 구현하세요.
contract Q018 {
    mapping(string => string) public births;
    
    function addBirth(string memory name, string memory birth) public {
        births[name] = birth;
    }

    function getBirth(string memory name) public view returns(string memory) {
        return births[name];
    }
}

// 숫자를 넣으면 2배를 반환해주는 함수를 구현하세요. 단 숫자는 1000이상 넘으면 함수를 실행시키지 못하게 합니다.
contract Q019 {
    function double(uint num) public pure returns(uint) {
        require(num<1000, "no more than 1000");
        return num*2;
    }
}

// 숫자만 들어가는 배열을 선언하고 숫자를 넣는 함수를 구현하세요. 15개의 숫자가 들어가면 3의 배수 위치에 있는 숫자들을 초기화 시키는(3번째, 6번째, 9번째 등등) 함수를 구현하세요. (for 문 응용 → 약간 까다로움)
contract Q020 {
    uint[15] public numbers;

    function setNumber() public {
        for(uint i = 0 ; i < 15 ; i++){
            if( (i+1) % 3 == 0){
                delete numbers[i];
            } else {
                numbers[i] = i+1;
            }
        }
    }
}
