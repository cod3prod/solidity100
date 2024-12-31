// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST01 {
/*
    여러분은 선생님입니다. 학생들의 정보를 관리하려고 합니다. 
    학생의 정보는 이름, 번호, 점수, 학점 그리고 듣는 수업들이 포함되어야 합니다.

    학점은 점수에 따라 자동으로 계산되어 기입하게 합니다. 90점 이상 A, 80점 이상 B, 70점 이상 C, 60점 이상 D, 나머지는 F 입니다.

    필요한 기능들은 아래와 같습니다.

    * 학생 추가 기능 - 특정 학생의 정보를 추가
    * 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    * 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    * 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    * 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    * 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    * 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    * 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    * 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    -------------------------------------------------------------------------------
    * S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)

    기입할 학생들의 정보는 아래와 같습니다.

    Alice, 1, 85
    Bob,2, 75
    Charlie,3,60
    Dwayne, 4, 90
    Ellen,5,65
    Fitz,6,50
    Garret,7,80
    Hubert,8,90
    Isabel,9,100
    Jane,10,70
*/
    struct Student {
        string name;
        uint number;
        uint score;
        string grade;
        string[] subjects;
    }

    Student[] students;

    // 학생 추가 기능 - 특정 학생의 정보를 추가
    function addStudent(string memory _name, uint _score, string[] memory _subjects) public {
        string memory _grade;

        if(_score >= 90){
            _grade = "A";
        } else if( _score >= 80) {
            _grade = "B";
        } else if( _score >= 70) {
            _grade = "C";
        } else if( _score >= 60) {
            _grade = "D";
        } else {
            _grade = "F";
        }

        Student memory _s = Student({
            name : _name,
            number : students.length + 1,
            score : _score,
            grade : _grade,
            subjects : _subjects
        });

        students.push(_s);
    }

    // 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    function getStudentByNumber(uint _number) public view returns(Student memory) {
        for(uint i = 0; i < students.length; i++){
            if(students[i].number == _number){
                return students[i];   
            }    
        }
        revert("Not Found");
    }

    // 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    function getStudentByName(string memory _name) public view returns(Student memory) {
        for(uint i = 0; i < students.length ; i++) {
            if(keccak256(abi.encodePacked(students[i].name)) == keccak256(abi.encodePacked(_name))){
                return students[i];   
            }    
        }
        revert("Not Found");
    }

    // 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    function getScoreByName(string memory _name) public view returns(uint) {
        for(uint i = 0; i < students.length ; i++) {
            if(keccak256(abi.encodePacked(students[i].name)) == keccak256(abi.encodePacked(_name))){
                return students[i].score;   
            }    
        }
        revert("Not Found");
    }

    // 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    function getTotalCount() public view returns(uint) {
        return students.length;
    }

    // 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    function getAllStudents() public view returns(Student[] memory) {
        return students;
    }

    // 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    function getAverageScore() public view returns(uint) {
        uint sum;
        if(students.length == 0) {
            return 0;
        } else {
            for(uint i = 0; i < students.length ; i++){
                sum += students[i].score;
            }
            return sum / students.length; // 소수점 내림
        }
    }

    // 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    function isQualified() public view returns(bool) {
        uint avg = getAverageScore();
        if(avg >= 70) {
            return true;
        } else {
            return false;
        }
    }

    // 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    function getFails() public view returns(Student[] memory) {
        uint failCount = 0;
        for (uint i = 0; i < students.length; i++) {
            if (keccak256(abi.encodePacked(students[i].grade)) == keccak256(abi.encodePacked("F"))) {
                failCount++;
            }
        }

        Student[] memory fails = new Student[](failCount);
        uint index = 0;

        for (uint i = 0; i < students.length; i++) {
            if (keccak256(abi.encodePacked(students[i].grade)) == keccak256(abi.encodePacked("F"))) {
                fails[index] = students[i];
                index++;
            }
        }

        return fails;
    }

    // S반 조회 기능 - 가장 점수가 높은 학생 4명을 S반으로 설정하는데, 이 학생들의 전체 정보를 반환하는 기능 (S반은 4명으로 한정)
    function getSClass() public view returns (Student[] memory) {
        uint len = students.length;
        
        Student[] memory temp = new Student[](len);
        for (uint i = 0; i < len; i++) {
            temp[i] = students[i];
        }

        for (uint i = 0; i < len; i++) {
            for (uint j = i + 1; j < len; j++) {
                if (temp[i].score < temp[j].score) {
                    (temp[i], temp[j]) = (temp[j], temp[i]);
                }
            }
        }

        uint resultLen = len < 4 ? len : 4;
        Student[] memory sClass = new Student[](resultLen);
        for (uint i = 0; i < resultLen; i++) {
            sClass[i] = temp[i];
        }

        return sClass;
    }
}
