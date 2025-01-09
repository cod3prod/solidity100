// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST7 {
/*
    흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.

    입력값을 받으면 그 입력값 안에 대문자, 소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 알려주는 함수를 구현하세요.
*/

    // 대문자, 소문자, 숫자만 사용한다고 가정
    mapping(string => bytes32) private users;

    function addUser(string calldata _name, string calldata _pw) external {
        require(users[_name] == bytes32(0), "User already exists");
        require(checkPassword(_pw), "Invalid password");
        users[_name] = keccak256(abi.encodePacked(_pw));
    }

    function deleteUser(string calldata _name, string calldata _pw) external {
        require(users[_name] != bytes32(0), "User does not exist");
        require(
            users[_name] == keccak256(abi.encodePacked(_pw)),
            "Invalid password"
        );
        delete users[_name];
    }

    function getUser(
        string calldata _name,
        string calldata _pw
    ) external view returns (bytes32) {
        require(users[_name] != bytes32(0), "User does not exist");
        require(
            users[_name] == keccak256(abi.encodePacked(_pw)),
            "Invalid password"
        );
        return users[_name];
    }

    function checkPassword(string calldata _pw) internal pure returns (bool) {
        bytes memory bytesPw = bytes(_pw);
        bool upperCk = false;
        bool lowerCk = false;
        bool numCk = false;

        for (uint i = 0; i < bytesPw.length; i++) {
            bytes1 char = bytes1(bytesPw[i]);

            // 아스키코드
            if (char >= 0x30 && char <= 0x39) {
                // 숫자
                numCk = true;
            } else if (char >= 0x41 && char <= 0x5A) {
                // 대문자
                upperCk = true;
            } else if (char >= 0x61 && char <= 0x7A) {
                // 소문자
                lowerCk = true;
            } else {
                revert("Invalid Character");
            }

            // 모든 조건 만족하면 테스트 중지
            if (upperCk && lowerCk && numCk) {
                return true;
            }
        }

        return upperCk && lowerCk && numCk;
    }
}