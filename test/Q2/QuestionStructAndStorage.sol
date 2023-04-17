// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {AnswerStructAndStorage} from "contracts/src/A2/AnswerStructAndStorage.sol";
import {SAnswerStructAndStorage} from "contracts/src/A2/interfaces/SAnswerStructAndStorage.sol";

contract  QuestionStructAndStorage is Test, SAnswerStructAndStorage {
    using stdStorage for StdStorage;
    AnswerStructAndStorage structAndStorage;

    struct Test2Vars {
      uint256 slot;
    }

    function setUp() public {
        structAndStorage = new AnswerStructAndStorage();
    }

    function test_Q2_StructAndStorage() public {
        Test2Vars memory vars;
        YourScore memory _score;
        _score.name = "John Doe";
        _score.description = "This is a sample score.";
        _score.score = 50;

        //スコア改ざんを呼び出し
        structAndStorage.submitScoreWithCheat(_score);

        //scores(msg.sender)の返り値の二つ目(uint256(score))
        vars.slot = stdstore
                        .target(address(structAndStorage))
                        .sig(structAndStorage.scores.selector)
                        .with_key(address(this))
                        .depth(2) // Note: Struct getter returns array of members
                        .find();
        assertEq(uint256(vm.load(address(structAndStorage), bytes32(vars.slot))), 100);

        vars.slot = stdstore
                        .target(address(structAndStorage))
                        .sig(structAndStorage.scores.selector)
                        .with_key(address(this))
                        .depth(3) // Note: Struct getter returns array of members
                        .find();
        assertEq(uint256(vm.load(address(structAndStorage), bytes32(vars.slot))), 7);


        bytes32 hash = keccak256(abi.encodePacked("Bob"));
        address BobAdr = address(uint160(bytes20(hash)));
        hash = keccak256(abi.encodePacked("Alice"));
        address AliceAdr = address(uint160(bytes20(hash)));

        YourScore memory _scoreAlice;
        _scoreAlice.name = "Alice";
        _scoreAlice.description = "This is a Alice score.";
        _scoreAlice.score = uint256(keccak256(abi.encodePacked(block.timestamp, _scoreAlice.name)))%100;
        if(_scoreAlice.score>50)
        {
            vm.expectRevert("over100");
        }
        //スコア改ざんを呼び出し
        structAndStorage.submitScoreWithCheat(AliceAdr,_scoreAlice);
                vars.slot = stdstore
                        .target(address(structAndStorage))
                        .sig(structAndStorage.scores.selector)
                        .with_key(AliceAdr)
                        .depth(2) // Note: Struct getter returns array of members
                        .find();
        console.log(uint256(vm.load(address(structAndStorage), bytes32(vars.slot))));

        vars.slot = stdstore
                        .target(address(structAndStorage))
                        .sig(structAndStorage.scores.selector)
                        .with_key(AliceAdr)
                        .depth(3) // Note: Struct getter returns array of members
                        .find();
        console.log(uint256(vm.load(address(structAndStorage), bytes32(vars.slot))));

        YourScore memory _scoreBob;
        _scoreBob.name = "Bob";
        _scoreBob.description = "This is a Bob score.";
        _scoreBob.score = uint256(keccak256(abi.encodePacked(block.timestamp, _scoreBob.name)))%100;
        if(_scoreBob.score>50)
        {
            vm.expectRevert("over100");
        }
        //スコア改ざんを呼び出し
        structAndStorage.submitScoreWithCheat(BobAdr,_scoreBob);
                vars.slot = stdstore
                        .target(address(structAndStorage))
                        .sig(structAndStorage.scores.selector)
                        .with_key(BobAdr)
                        .depth(2) // Note: Struct getter returns array of members
                        .find();
        console.log(uint256(vm.load(address(structAndStorage), bytes32(vars.slot))));

        vars.slot = stdstore
                        .target(address(structAndStorage))
                        .sig(structAndStorage.scores.selector)
                        .with_key(BobAdr)
                        .depth(3) // Note: Struct getter returns array of members
                        .find();
        console.log(uint256(vm.load(address(structAndStorage), bytes32(vars.slot))));

        /*
            Hint:
                このテストはストレージに狙った値が入っていることをテストしています。
                したがって、ストレージを検査するために外部からストレージを閲覧できるようにしてあげる必要があります。
                Solidityにおいてことなるコントラクトを叩くときは、インターフェースを用います。
                インターフェースはコンパイラに型情報をよりたくさん与えられるので、
                コンパイラが人間の代わりにミスを発見してくれる良さもあります。
        */
    }
}