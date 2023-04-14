// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { SAnswerNFT } from "src/A5/interfaces/SAnswerNFT.sol";
import { IAnswerNFT } from "src/A5/interfaces/IAnswerNFT.sol";

contract AnswerNFT is IAnswerNFT, Ownable {
    /**
        Q-5. ERC-721とapprovalとプログラマブルな送金と多様なコントラクト
        ガチャを通して、ERC-721の内容とコントラクトへの送金を学ぶ
     */
    IERC721 nft;

    /**
     * @dev NFTAddressを設定する関数
     */
    function setNFT(address _nft) public onlyOwner {
        nft = IERC721(_nft);
    }

    uint256 _boosterCounter = 1;

    /**
     * @dev NFTのガチャガチャを回す関数
     */
    function buyBoosterPack() public payable override {
        // Note: Fill me
        //0.2 etherで１枚払い出し
       uint loopnum = msg.value / 0.2 ether;
       for(uint i = 0 ;i < loopnum; i++)
       {
            //_boosterCounterのnftをこのコンストラクタから呼び出し主に送る。
            nft.transferFrom(address(this),msg.sender,_boosterCounter);
            _boosterCounter++;
       }
    }

    /**
     * @dev 最初にNFTのガチャガチャを回した者に入場の権利を付与する関数
     */
    function canEnterByOriginHolder() public override view returns (bool) {
        // Note: Fill me
        bool Ok = false;
        if(msg.sender != nft.ownerOf(1))
        {
            revert("You don't have the first NFT.");
        }
        else
        {
            Ok = true;
        }
        return Ok;
    }
}