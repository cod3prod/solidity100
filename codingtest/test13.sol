// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST13 {
/*
    숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요. (숫자는 작은수에서 큰수로)
    예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   3,5,9 // 28712 -> 5,   1,2,2,7,8
    --------------------------------------------------------------------------------------------
    문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요. (알파벳은 순서대로)
    예) abde -> 4,   a,b,d,e // fkeadf -> 6,   a,d,e,f,f,k

    소문자 대문자 섞이는 상황은 그냥 생략하셔도 됩니다
*/
    function getNumbers(uint num) external pure returns(uint, uint[] memory) {
        uint digit = calculateDigit(num);
        uint[] memory numArr = new uint[](digit);
        for(uint i = 0; i < digit; i++) {
            numArr[i] = num%10;
            num /= 10;
        }

        for(uint i = 0; i < digit; i++) {
            for(uint j = i+1; j < digit ; j++) {
                if(numArr[i] > numArr[j]) {
                    (numArr[i], numArr[j]) = (numArr[j], numArr[i]);
                }
            }
        }
        return (digit, numArr);
    }

    function getStrings(string memory str) external pure returns(uint, string[] memory) {
        bytes memory convertedStr = bytes(str);
        uint len = convertedStr.length;
        string[] memory strArr = new string[](len);

        for(uint i = 0; i < len; i++) {
            for(uint j = i+1; j < len; j++) {
                if(convertedStr[i]>convertedStr[j]){
                    (convertedStr[i], convertedStr[j]) = (convertedStr[j], convertedStr[i]);
                }
            }
            strArr[i] = string(abi.encodePacked(convertedStr[i]));
        }

        return (len, strArr);
    }
 
    function calculateDigit(uint num) internal pure returns(uint) {
        require(num>0, "Yon cannot input zero");
        uint digit;
        while(num>0){
            digit++;
            num /= 10;
        }
        return digit;
    }
}