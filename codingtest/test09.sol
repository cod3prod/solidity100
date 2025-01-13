// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST9 {
/*
    은행에 관련된 어플리케이션을 만드세요.
    은행은 여러가지가 있고, 유저는 원하는 은행에 넣을 수 있다. 
    국세청은 은행들을 관리하고 있고, 세금을 징수할 수 있다. 
    세금은 간단하게 전체 보유자산의 1%를 징수한다. 세금을 자발적으로 납부하지 않으면 강제징수한다. 

    * 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
    * 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
    * 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
    * 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
    * 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
    * 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
    -------------------------------------------------------------------------------------------------
    * 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
    * 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
*/

    address[] public userList;
    mapping(address => bool) public isUser;

    struct Bank {
        string name;
        mapping(address => uint) balances;
        mapping(address => bool) isMember;
    }

    mapping(string => Bank) public banks;
    string[] public bankList;

    address public taxAuth;
    uint public taxRate = 1;
    mapping(address => uint) public taxes;

    constructor() {
        taxAuth = msg.sender;
    }

    modifier onlyTaxAuth() {
        require(msg.sender == taxAuth, "You are not the tax authority");
        _;
    }

    modifier onlyMember(string calldata _name) {
        require(
            banks[_name].isMember[msg.sender] == true,
            "You are not a member"
        );
        _;
    }

    // 은행 생성
    function createBank(string calldata _name) external onlyTaxAuth {
        require(
            keccak256(abi.encodePacked(_name)) != bytes32(0),
            "Invalid name"
        );
        require(bytes(banks[_name].name).length == 0, "Bank already exists");
        Bank storage newBank = banks[_name];
        newBank.name = _name;
        bankList.push(_name);
    }

    // 유저 등록
    function registerUser() external {
        require(isUser[msg.sender] == false, "User already exists");
        isUser[msg.sender] = true;
        userList.push(msg.sender);
    }

    // 은행 가입
    function joinBank(string calldata _name) external {
        require(
            banks[_name].isMember[msg.sender] == false,
            "User already exists"
        );
        Bank storage bank = banks[_name];
        bank.isMember[msg.sender] = true;
    }

    // 입금
    function deposit(string calldata _name) external payable onlyMember(_name) {
        Bank storage bank = banks[_name];
        bank.balances[msg.sender] += msg.value;
    }

    // 출금
    function withdraw(
        string calldata _name,
        uint _amount
    ) external onlyMember(_name) {
        Bank storage bank = banks[_name];
        require(bank.balances[msg.sender] >= _amount, "Insufficient balance");
        bank.balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    // 송금(1)
    function transfer(
        string calldata _name1,
        string calldata _name2,
        uint _amount // 1 ether
    ) external onlyMember(_name1) onlyMember(_name2) {
        Bank storage bank1 = banks[_name1];
        Bank storage bank2 = banks[_name2];
        require(
            bank1.balances[msg.sender] >= _amount * 1 ether,
            "Insufficient balance"
        );
        bank1.balances[msg.sender] -= _amount * 1 ether;
        bank2.balances[msg.sender] += _amount * 1 ether;
    }

    // 송금(2)
    function transferToUser(
        string calldata _name,
        address _to,
        uint _amount // 1 ether
    ) external onlyMember(_name) {
        Bank storage bank = banks[_name];
        require(
            bank.balances[msg.sender] + 1 ether / 1000 >= _amount * 1 ether,
            "Insufficient balance"
        );
        bank.balances[msg.sender] -= _amount * 1 ether + 1 ether / 1000;
        bank.balances[_to] += _amount * 1 ether;
    }

    // 세금 부과
    function imposition() external onlyTaxAuth {
        for (uint i = 0; i < userList.length; i++) {
            address user = userList[i];
            uint totalBalance = 0;

            for (uint j = 0; j < bankList.length; j++) {
                string storage bankName = bankList[j];
                Bank storage bank = banks[bankName];
                totalBalance += bank.balances[user];
            }
            if (totalBalance > 0) {
                uint taxAmount = (totalBalance * taxRate) / 100;
                taxes[user] += taxAmount;
            }
        }
    }

    // 세금 강제 징수
    function collectTaxes(address _user) external onlyTaxAuth {
        require(taxes[_user] > 0, "No taxes to collect");

        uint remainingTax = taxes[_user];

        for (uint i = 0; i < bankList.length && remainingTax > 0; i++) {
            string memory bankName = bankList[i];
            Bank storage bank = banks[bankName];

            uint userBalance = bank.balances[_user];

            if (userBalance > 0) {
                // 징수할 금액은 잔고와 남은 세금 중 최소값
                uint collectedAmount = userBalance >= remainingTax
                    ? remainingTax
                    : userBalance;

                bank.balances[_user] -= collectedAmount;
                remainingTax -= collectedAmount;
            }
        }

        taxes[_user] = remainingTax;
    }
}
