// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// 배열에서 특정 요소를 없애는 함수를 구현하세요. 
//  예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
contract Q091 {
    function removeElement(uint[] memory arr, uint order) public pure returns (uint[] memory) {
        uint[] memory result = new uint[](arr.length - 1);

        for(uint i = 0; i < order-1; i++) {
            result[i] = arr[i];
        }

        for(uint i = order; i < arr.length; i++) {
            result[i-1] = arr[i];
        }

        return result;
    }
}


// 특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
contract Q092 {
    function isEOA(address _addr) external view returns(bool) {
        return _addr.code.length == 0;
    }
}

// 다른 컨트랙트의 함수를 사용해보려고 하는데, 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
contract Q093 {
    function callFunction(address _addr, bytes4 _methodId, uint _number, address _inputAddr) external {
        (bool success, ) = _addr.call(abi.encodeWithSelector(bytes4(_methodId), _number, _inputAddr));
        require(success, "Function call failed");
    }
}

// inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
contract Q094 {
    function add(uint a, uint b) external pure returns (uint) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, add(a, b))
            mstore(0x40, add(ptr, 0x20))
            return(ptr, 0x20)
        }
    }

    function sub(uint a, uint b) external pure returns (uint) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sub(a, b))
            mstore(0x40, add(ptr, 0x20))
            return(ptr, 0x20)
        }
    }

    function mul(uint a, uint b) external pure returns (uint) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, mul(a, b))
            mstore(0x40, add(ptr, 0x20))
            return(ptr, 0x20)
        }
    }

    function div(uint a, uint b) external pure returns (uint) {
        assembly {
            if iszero(b) { revert(0, 0) }
            let ptr := mload(0x40)
            mstore(ptr, div(a, b))
            mstore(0x40, add(ptr, 0x20))
            return(ptr, 0x20)
        }
    }
}

// inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
contract Q095 {
    function add(uint a, uint b, uint c) external pure returns (uint) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, add(add(a, b), c))
            mstore(0x40, add(ptr, 0x20))
            return(ptr, 0x20)
        }
    }


    function mul(uint a, uint b, uint c) external pure returns (uint) {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, mul(mul(a, b),c))
            mstore(0x40, add(ptr, 0x20))
            return(ptr, 0x20)
        }
    }
}

// inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
contract Q096 {
    function max(uint[4] memory numbers) external pure returns (uint) {
        assembly {
            let max := mload(numbers)
            for{let i := 1} lt(i, 4) {i := add(i,1)} {
                let value := mload(add(numbers, mul(0x20, i)))
                if lt(max, value) {
                    max := value
                }
            }
            
            let ptr := mload(0x40)
            mstore(ptr, max)
            mstore(0x40, add(ptr, 0x20))

            return(ptr, 0x20)            
        }
    }

    function min(uint[4] memory numbers) external pure returns (uint) {
        assembly {
            let min := mload(numbers)
            for{let i := 1} lt(i, 4) {i := add(i,1)} {
                let value := mload(add(numbers, mul(0x20, i)))
                if lt(value, min) {
                    min := value
                }
            }
            
            let ptr := mload(0x40)
            mstore(ptr, min)
            mstore(0x40, add(ptr, 0x20))

            return(ptr, 0x20)
    
        }
    }
}

// inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 pop하는 함수 그리고 전체를 반환하는 구현하세요.
contract Q097 {
    uint[] numbers;

    function push(uint num) external {
        assembly {
            let slot := numbers.slot
            let len := sload(slot)
            
            let ptr := mload(0x40)
            mstore(ptr, slot)

            let target := add(keccak256(ptr, 0x20), len)
            sstore(target, num)
            sstore(slot, add(len, 1))
            mstore(0x40, add(ptr, 0x20))    
        }
    }

    function pop() external {
        assembly {
            let slot := numbers.slot
            let len := sload(slot)
            if iszero(len) { revert(0,0)}

            sstore(slot, sub(len, 1))    
        }
    }

    function getNumbers() external view returns(uint[] memory) {
        return numbers;
    }
}

// inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요.
contract Q098 {
    string public str;

    function setStr(string memory _str) external {
        assembly {
            let slot := str.slot

            let len := mload(_str)
            sstore(slot, add(mload(add(0x20, _str)), mul(2, len)))
        }
    }
}

// inline - bytes4형 b의 값을 정하는 함수 setB를 구현하세요.
contract Q099 {
    bytes4 public b;

    function setB(bytes4 _b) external {
        assembly {
            let slot := b.slot

            // 28bytes만큼 오른쪽
            // 28 * 8bit
            sstore(slot,  shr(mul(8,28), _b))

        }
    }
}

// inline - bytes형 변수 b의 값을 정하는 함수 setB를 구현하세요.
contract Q100 {
    bytes public b;
    function setB(bytes memory _b) external {
        assembly {
            let slot := b.slot

            let len := mload(_b)
            let value := mload(add(0x20, _b))
            
            sstore(slot, add(value, mul(2, len)))
        }
    }
}