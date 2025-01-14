// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AContract is ERC20 {
/*
    A라고 하는 erc-20(decimal 0)을 발행하고, B라는 NFT를 발행하십시오.
    A 토큰은 개당 0.001eth 정가로 판매한다.
    B NFT는 오직 A로만 구매할 수 있고 가격은 50으로 시작합니다.
    첫 10명은 50A, 그 다음 20명은 100A, 그 다음 40명은 200A로 가격이 상승합니다. (그 이후는 안해도 됨)

    B를 burn 하면 20A만큼 환불 받을 수 있고, 만약에 C라고 하는 contract에 전송하면 30A 만큼 받는 기능도 구현하세요.
*/

    constructor() ERC20("AToken", "A") {}

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    function mint() external payable {
        uint amount = msg.value / 10**15 ;
        
        _mint(msg.sender, amount);
    }
}

contract BContract is ERC721 {
    AContract public aTokenContract;
    CContract public cNFTContract;
    uint256 public tokenCounter;

    constructor(address _aTokenContract) ERC721("BNFT", "B") {
        aTokenContract = AContract(_aTokenContract);
        cNFTContract = new CContract();
        tokenCounter = 0;
    }

    function priceForMinting() internal view returns (uint256) {
        if (tokenCounter < 10) {
            return 50;  // 첫 10명은 50 A
        } else if (tokenCounter < 30) {
            return 100;  // 그 다음 20명은 100 A
        } else {
            return 200;  // 그 이후는 200 A
        }
    }

    function mint() external {
        require(aTokenContract.balanceOf(msg.sender) >= priceForMinting(), "Not enough A tokens to mint B");

        // 민팅하기 전에 B에게 approve 필요
        aTokenContract.transferFrom(msg.sender, address(this), priceForMinting());

        tokenCounter++;
        _mint(msg.sender, tokenCounter);
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "You do not own this token");
        _burn(tokenId);
        aTokenContract.transfer(msg.sender, 20); // 20 A 환불
    }

    function transferToC(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "You do not own this token");
        
        // 전송하기 전에 B에게 approve 필요
        safeTransferFrom(msg.sender, address(cNFTContract), tokenId);
        aTokenContract.transfer(msg.sender, 30); // 30 A 지급
    }
}

contract CContract is ERC721 {
    constructor() ERC721("CNFT", "C") {}

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
