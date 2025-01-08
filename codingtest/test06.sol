// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract TEST6 {
/*
    안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
    안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
    안건들을 모아놓은 자료구조도 구현하세요. 
    
    사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)
    
    * 사용자 등록 기능 - 사용자를 등록하는 기능
    * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    -------------------------------------------------------------------------------------------------
    * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
*/

    struct Agenda {
        uint id; // index == id
        string title;
        string description;
        address proposer;
        uint agreeCount;
        uint disagreeCount;
        uint creationBlock;
        Status status;
    }

    struct User {
        string name;
        address addr;
        uint[] proposedAgendas;
        mapping(uint => bool) votedAgendas; // id => voted
        mapping(uint => bool) voteChoice; // id => agree
    }

    enum Status {
        Voting, // 투표
        Passed, // 통과
        Rejected // 기각
    }

    mapping(address => User) public users;

    Agenda[] public agendas;
    uint public agendaCount;
    uint public VOTING_DURATION = 15;
    uint public totalUsersCount;

    modifier onlyUser() {
        require(
            bytes(users[msg.sender].name).length > 0,
            "You are not registered"
        );
        _;
    }



    /* internal functions */
    // 제목으로 안건 인덱스 검색
    function searchAgendaIndexByTitle(
        string calldata _title
    ) internal view returns (uint) {
        for (uint i = 0; i < agendas.length; i++) {
            if (
                keccak256(abi.encodePacked(agendas[i].title)) ==
                keccak256(abi.encodePacked(_title))
            ) {
                return i;
            }
        }
        revert("Agenda not found");
    }

    // 상태 업데이트 (투표 상태 변경)
    function updateStatus(uint _agendaId) internal {
        Agenda storage agenda = agendas[_agendaId];

        if (block.number < agenda.creationBlock + VOTING_DURATION) {
            agenda.status = Status.Voting;
            return; // 투표 진행 중
        }

        uint totalVotesForAgenda = agenda.agreeCount + agenda.disagreeCount;
        if (
            totalVotesForAgenda >= (totalUsersCount * 70) / 100 &&
            (agenda.agreeCount * 100) / totalVotesForAgenda >= 66
        ) {
            agenda.status = Status.Passed;
        } else {
            agenda.status = Status.Rejected;
        }
    }



    /* external functions */
    // 사용자 등록
    function registerUser(string calldata _name) external {
        require(
            bytes(users[msg.sender].name).length == 0,
            "User already registered"
        );

        users[msg.sender].name = _name;
        users[msg.sender].addr = msg.sender;
        users[msg.sender].proposedAgendas = new uint[](0);
        totalUsersCount++;
    }

    // 안건 제안
    function proposeAgenda(
        string calldata _title,
        string calldata _description
    ) external onlyUser {
        agendas.push(
            Agenda({
                id: agendaCount,
                title: _title,
                description: _description,
                proposer: msg.sender,
                agreeCount: 0,
                disagreeCount: 0,
                creationBlock: block.number,
                status: Status.Voting
            })
        );
        users[msg.sender].proposedAgendas.push(agendaCount);
        agendaCount++;
    }

    // 투표
    function vote(string calldata _title, bool _agree) external onlyUser {
        uint agendaIndex = searchAgendaIndexByTitle(_title);

        require(!users[msg.sender].votedAgendas[agendaIndex], "Already voted");

        if (_agree) {
            agendas[agendaIndex].agreeCount++;
        } else {
            agendas[agendaIndex].disagreeCount++;
        }

        users[msg.sender].votedAgendas[agendaIndex] = true;
        users[msg.sender].voteChoice[agendaIndex] = _agree;

        updateStatus(agendaIndex);
    }

    // 자신이 제안한 안건 확인
    function getMyAgendas() external view onlyUser returns (Agenda[] memory) {
        User storage user = users[msg.sender];
        uint numAgendas = user.proposedAgendas.length;
        Agenda[] memory result = new Agenda[](numAgendas);

        for (uint i = 0; i < numAgendas; i++) {
            result[i] = agendas[user.proposedAgendas[i]];
        }

        return result;
    }

    // 전체 안건 확인
    function getAllAgendas() external view returns (Agenda[] memory) {
        return agendas;
    }

    // status 조회
    function getStatus(uint _agendaId) external view returns (string memory) {
        if (agendas[_agendaId].status == Status.Voting) {
            return "Voting";
        } else if (agendas[_agendaId].status == Status.Passed) {
            return "Passed";
        } else {
            return "Rejected";
        }
    }
}
