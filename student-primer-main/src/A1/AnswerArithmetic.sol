// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AnswerArithmetic {
    /**
        A-1. 四則演算を試す/gasleft()とconsole.log()を学ぶ
    */
    uint256 baseNum = 2;
    uint256 oneHundred = 100;
    function calc() external pure returns (uint256) {
      return type(uint256).max; // Note: Fix me!
    }
    function retOneHundred() public pure returns (uint256) {   
      return 100; // Note: Fix me!
    }
    function nino(uint256 jousu) external view returns (uint256) {
      uint256 num;
      unchecked{
          num = (baseNum ** jousu);
      }
      return num; // Note: Fix me!
    }
    
    function subOneHundred(uint256 val) external view returns (uint256) {
      uint256 num = 0;
      unchecked{
          num = oneHundred - val;
      }
      return num; // Note: Fix me!
    }
}
