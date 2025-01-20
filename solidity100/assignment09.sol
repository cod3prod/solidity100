// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Contract에 예치, 인출할 수 있는 기능을 구현하세요. 지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.
contract Q081 {
    mapping(address => uint) public balances;

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function getBalance() external view returns (uint) {
        return balances[msg.sender];
    }
}

// 특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
contract Q082 {
    function getNumbers(uint num) public pure returns (uint[3] memory) {
        uint[3] memory result;
        
        for(uint i = 1; i < num + 1 ; i++) {
            if (i % 3 == 0) {
                result[0]++;
            }
            if (i % 5 == 0) {
                result[1]++;
            }
            if (i % 8 == 0) {
                result[2]++;
            }
        }

        return result;
    }
}

// 이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요. 사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
contract Q083 {
    struct Person {
        string name;
        uint number;
        address addr;
        mapping(string => uint) memos;
    }

    Person[] public people;

    function addPerson(string memory _name, uint _number, address _addr, string[] memory _keys, uint[] memory _values) external {
        people.push();

        Person storage _p = people[people.length - 1];
        _p.name = _name;
        _p.number = _number;
        _p.addr = _addr;
        for(uint i = 0; i < _keys.length; i++) {
            _p.memos[_keys[i]] = _values[i];
        }
    }

    function getMemo(uint _index, string memory _key) external view returns (uint) {
        return people[_index].memos[_key];
    }
}

// 2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
contract Q084 {
    mapping(address => bool) public blacklist;

    modifier noBlacklist() {
        require(!blacklist[msg.sender], "You are on the blacklist");
        _;
    }

    function add(uint x, uint y) external view noBlacklist() returns(uint) {
        return x + y;
    }

    function sub(uint x, uint y) external view noBlacklist() returns(uint) {
        return x - y;
    }

    function mul(uint x, uint y) external view noBlacklist() returns(uint) {
        return x * y;
    }
}

// 숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
contract Q085 {
    uint blockNumber;
    uint approvalNumber;
    uint oppositionNumber;
    mapping (address => bool) public hasVoted;

    constructor() {
        blockNumber = block.number;
    }

    function vote(bool _approval) external {
        require(block.number <= blockNumber + 20, "Vote is closed");
        require(hasVoted[msg.sender] == false, "You have already voted");
        
        if (_approval) {
            approvalNumber++;
        } else {
            oppositionNumber++;
        }

        hasVoted[msg.sender] = true;
    }

    function getVoteResult() external view returns (uint, uint) {
        return (approvalNumber, oppositionNumber);
    }
}

// 숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
contract Q086 {
    uint blockNumber;
    uint approvalNumber;
    uint oppositionNumber;
    mapping (address => bool) public hasVoted;
    mapping (address => bool) public hasDeposited;
    
    constructor() {
        blockNumber = block.number;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value >= 1 ether, "1 ether or more is required");
        hasDeposited[msg.sender] = true;
    }

    function vote(bool _approval) external {
        require(hasDeposited[msg.sender] == true, "You are not a voter");
        require(hasVoted[msg.sender] == false, "You have already voted");
        
        if (_approval) {
            approvalNumber++;
        } else {
            oppositionNumber++;
        }

        hasVoted[msg.sender] = true;
    }

    function getVoteResult() external view returns (uint, uint) {
        return (approvalNumber, oppositionNumber);
    }
}

// 숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 변화시키는 것도 오직 내부에서만 할 수 있게 해주세요. 
contract Q087 {
    uint private a;

    function setA(uint _a) internal {
        a = _a;
    }

    function getA() public view returns(uint) {
        return a;
    }
}

// 아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요.
contract OWNER {
	address private owner;

	constructor() {
		owner = msg.sender;
	}

    function setInternal(address _a) internal {
        owner = _a;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}

contract Q088 is OWNER {
    function changeOwner(address _owner) external {
        setInternal(_owner);
    }
}

// 이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
contract Q089 {
    struct Customer {
        string name;
        string description;
    }

    Customer[] public customers;

    modifier nameCheck(string calldata _name) {
        bytes memory nameBytes = bytes(_name);
        require(nameBytes.length >= 5 && nameBytes.length <= 10, "Name must be between 5 and 10 characters");
        _;
    }

    modifier descriptionCheck(string calldata _description) {
        bytes memory descriptionBytes = bytes(_description);
        require(descriptionBytes.length >= 20 && descriptionBytes.length <= 50, "Description must be between 20 and 50 characters");
        _;
    }

    function setCustomer(string calldata _name, string calldata _description) nameCheck(_name) descriptionCheck(_description) external {
        customers.push(Customer({name: _name, description: _description}));
    }

    function getCustomer(uint _index) external view returns (string memory, string memory) {
        return (customers[_index].name, customers[_index].description);
    }

    function setName(uint _index, string calldata _name) nameCheck(_name) external {
        customers[_index].name = _name;
    }

    function setDescription(uint _index, string calldata _description) descriptionCheck(_description) external {
        customers[_index].description = _description;
    }
}

// 당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
contract Q090 {
    function getAddress() external view returns (string memory) {
        return toHexString(msg.sender);
    }

    function toHexString(address _addr) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory data = abi.encodePacked(_addr);
        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2 + i * 2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3 + i * 2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }
}