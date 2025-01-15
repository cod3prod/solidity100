// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract TEST11 {
    /*
    숫자를 시분초로 변환하세요.
    예) 100 -> 1분 40초, 600 -> 10분, 1000 -> 16분 40초, 5250 -> 1시간 27분 30초
*/
    function formatDate(uint256 _time) public pure returns (string memory) {
        uint256 hour = _time / 3600;
        uint256 minute = (_time % 3600) / 60;
        uint256 second = (_time % 3600) % 60;
        string memory hourStr = hour == 0
            ? ""
            : string.concat(Strings.toString(hour), unicode"시간");
        string memory minuteStr = minute == 0
            ? ""
            : string.concat(Strings.toString(minute), unicode"분");
        string memory secondStr = second == 0
            ? ""
            : string.concat(Strings.toString(second), unicode"초");

        if (hour > 0) {
            return string.concat(hourStr, " ", minuteStr, " ", secondStr);
        } else if (minute > 0) {
            return string.concat(minuteStr, " ", secondStr);
        } else {
            return secondStr;
        }
    }
}