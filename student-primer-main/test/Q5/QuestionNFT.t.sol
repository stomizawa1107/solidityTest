// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { AnswerNFT } from "src/A5/AnswerNFT.sol";
import { SAnswerNFT } from "src/A5/interfaces/SAnswerNFT.sol";
import { YourNFT } from "src/A5/utils/YourNFT.sol";
contract QuestionNFT is Test, SAnswerNFT { 
    AnswerNFT yourContract;
    address yourContractAddress;

    function setUp() public {
        yourContract = new AnswerNFT();
        yourContractAddress = address(yourContract);
    }
    
    /**
        Q-5. ERC-721とapprovalとプログラマブルな送金と多様なコントラクト
        ガチャガチャを通して、ERC-721の内容とコントラクトへの送金を学ぶ
     */
    function test_Q5_NFT() public {
        Vars memory vars;

        YourNFT nft = new YourNFT();
        //このコントラクトに対してnftを100個mint
        for(uint256 i; i < 100;) {
            nft.mintItem(address(yourContract));
            unchecked { ++i; }
        }

        //nft(YourNFT)のアドレスをセット
        yourContract.setNFT(address(nft));

        //アリスのアドレスを設定（2Eth）
        vars.alice.addr = makeAddr("Alice");
        vm.deal(vars.alice.addr, 2 ether);
        //ボブのアドレスを設定（2Eth）
        vars.bob.addr = makeAddr("Bob");
        vm.deal(vars.bob.addr, 2 ether);

        //アリスのアドレスに設定
        vm.prank(vars.alice.addr);
        //ブースターパック購入処理
        yourContract.buyBoosterPack{value: 1 ether}();
        //nftの所持数を取得
        vars.balance = nft.balanceOf(vars.alice.addr);
        //nftの所持数が５下チェック
        assertEq(vars.balance, 5);

        //ボブのアドレスに設定
        vm.prank(vars.bob.addr);
        //ブースターパックの購入処理
        yourContract.buyBoosterPack{value: 1 ether}(); // 売るためのNFTはこのテストファイル内で用意してある.
        //ボブのnft所持数を取得
        vars.balance = nft.balanceOf(vars.bob.addr);
        //nftの所持数が5かチェック
        assertEq(vars.balance, 5);

        //アリスのアドレスに設定
        vm.prank(vars.alice.addr);
        //アリスがオリジン（１つ目）のオーナーかチェック
        vars.canEnter = yourContract.canEnterByOriginHolder();
        assertTrue(vars.canEnter);

        //ボブのアドレスに設定
        vm.prank(vars.bob.addr);
        //ボブがオリジン（１つ目）のオーナーかチェック
        //ボブは違うのでRevert
        vm.expectRevert(abi.encodePacked("You don't have the first NFT."));
        yourContract.canEnterByOriginHolder();
    }
}