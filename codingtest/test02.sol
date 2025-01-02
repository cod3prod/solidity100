// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST2 {
/*
    학생 점수관리 프로그램입니다.
    여러분은 한 학급을 맡았습니다.
    학생은 번호, 이름, 점수로 구성되어 있고(구조체)
    가장 점수가 낮은 사람을 집중관리하려고 합니다.

    가장 점수가 낮은 사람의 정보를 보여주는 기능,
    총 점수 합계, 총 점수 평균을 보여주는 기능,
    특정 학생을 반환하는 기능, -> 숫자로 반환
    가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
*/

    struct Student {
        uint number;
        string name;
        uint score;
    }

    Student[] public students;

    // 학생 추가
    function addStudent(uint _number, string memory _name, uint _score) public {
        for(uint i = 0; i < students.length; i++) {
            if(students[i].number == _number) {
                revert("Number already exists");
            }
        }
        
        Student memory _s = Student({
            number: _number,
            name: _name,
            score: _score
        });

        students.push(_s);
    }

    // 가장 점수가 낮은 사람
    function lowestScoreStudent() public view returns (Student memory) {
        require(students.length > 0, "There is no student");
        Student memory _s = students[0];
        for (uint i = 1; i < students.length; i++) {
            if (students[i].score < _s.score) {
                _s = students[i];
            }   
        }
        return _s;
    }

    // 총 점수 합계
    function totalScore() public view returns (uint) {
        uint _total = 0;
        for (uint i = 0; i < students.length; i++) {
            _total += students[i].score;
        }
        return _total;
    } 

    // 평균 점수
    function averageScore() public view returns (uint) {
        require(students.length > 0, "There is no student");
        uint _total = totalScore();
        uint _average = _total / students.length;
        return _average;
    }

    // 학번으로 특정 학생 정보 반환
    function getStudentByNumber(uint _number) public view returns(Student memory) {
        for (uint i = 0 ; i < students.length; i++) {
            if(students[i].number == _number) {
                return students[i];
            }
        }
        revert("Student Not Found");
    }

    // 모든 학생의 정보를 반환
    function getAllStudents() public view returns (Student[] memory) {
        return students;
    }
}
