// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {SAnswerStructAndStorage} from "src/A2/interfaces/SAnswerStructAndStorage.sol";

contract AnswerStructAndStorage is SAnswerStructAndStorage {
    /**
        A-2. 構造体/ストレージアクセスを試す
    */
    mapping(address=> YourScore) public mscore;

    function scores(address _key) public view returns (string memory, string memory, uint256) {
      return (mscore[_key].name, mscore[_key].description,mscore[_key].score);
    }
    
    function submitScoreWithCheat(YourScore memory _score) public {
      YourScore memory _myScore;
      _myScore.name = _score.name;
      _myScore.description = _score.description;
      _myScore.score = _score.score + 50;
      //呼び出し主のスコアを50+50で100に改ざん
      mscore[msg.sender] = _myScore;
      // Note: Fill me!
    }
}
