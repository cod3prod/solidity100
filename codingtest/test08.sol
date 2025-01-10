// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract TEST8 {
    /*
    자동차와 관련된 어플리케이션을 만들면 됩니다.
    1개의 smart contract가 자동차라고 생각하시고, 구조체를 활용하시면 편합니다.

    아래의 기능들을 구현하세요.

    * 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    --------------------------------------------------------
    * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
*/
    enum State {
        OFF,
        ON
    }

    struct Car {
        address owner;
        uint speed;
        uint charge;
        State engineState;
        uint balance;
    }

    Car public car;

    constructor() {
        car.owner = msg.sender;
        car.speed = 0;
        car.charge = 0;
        car.engineState = State.OFF;
        car.balance = 0;
    }

    // 충전
    function deposit() external payable {
        car.balance += msg.value;
    }

    // 주유
    function charge() external {
        require(car.balance >= 1 ether, "Not enough money");
        uint amount = car.balance / 1 ether;
        car.balance -= amount * 1 ether;
        car.charge += 10 * amount;
    }

    // 시동 켜기
    function turnOn() external {
        require(car.engineState == State.OFF, "The engine is already on");
        car.engineState = State.ON;
    }

    // 시동 끄기
    function turnOff() internal {
        require(car.engineState == State.ON, "The engine is already off");
        require(car.speed == 0, "The car is moving");
        car.engineState = State.OFF;
    }

    // 악셀
    function speedUp() external {
        require(car.engineState == State.ON, "The engine is off");
        require(car.speed < 70, "The car is too fast");
        require(car.charge >= 30, "Not enough charge");
        car.charge -= 20;
        car.speed += 10;
    }

    // 브레이크
    function speedDown() external {
        require(car.engineState == State.ON, "The engine is off");
        require(car.speed > 0, "The car is already stopped");
        car.charge -= 10;
        car.speed -= 10;
        if (car.speed == 0) {
            turnOff();
        }
    }

    // 차 상태
    function getStatus() external view returns (string memory) {
        if (car.engineState == State.ON) {
            return string(abi.encodePacked("The car is on ", "Speed: ", Strings.toString(car.speed)));
        } else {
            return "The car is off";
        }
    }
}
