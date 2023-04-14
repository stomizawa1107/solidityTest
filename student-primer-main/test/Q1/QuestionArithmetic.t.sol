// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {AnswerArithmetic} from "src/A1/AnswerArithmetic.sol";

contract QuestionArithmetic is Test {
    AnswerArithmetic arithmetic;

    struct Test1Vars {
        uint256 tempGas;
        uint256 execGas;
        uint256 result;
    }

    function setUp() public {
        arithmetic = new AnswerArithmetic();
    }

    /**
        Q-1. 制御構文(if, for, require, revert), modifier, アクセス制御, オーナー権限を試す
     */

    function test_Q1_Arithmetic() public {
        Test1Vars memory vars;
        vars.tempGas = gasleft();
        vars.execGas = vars.tempGas - gasleft();
        uint256 nowGasLeft = gasleft();
        console.log(vars.tempGas);
        console.log(nowGasLeft);
        console.log(gasleft());
        assertTrue(vars.tempGas != nowGasLeft); // Note: ただし上記の値をそのままコピペすることは無効です
        assertTrue(arithmetic.retOneHundred() == 100); // Note: ただし上記の値をそのままコピペすることは無効です
        assertTrue(gasleft() != nowGasLeft); // Note: ただし上記の値をそのままコピペすることは無効です
        vars.result = arithmetic.calc();
        //console.log(vars.result); // Note: Try me, and remove me later ;)

        uint256 resultMath = arithmetic.nino(256);
        assertTrue(resultMath == 0); // Note:
        console.log(resultMath);
        resultMath = arithmetic.nino(255);
        console.log(resultMath);
        assertTrue(resultMath == 2 ** 255); // Note:        assertTrue(resultMath == 2 ** 255); // Note:
        assertTrue(vars.result == 115792089237316195423570985008687907853269984665640564039457584007913129639935);
        assertTrue(vars.execGas < 6000); // Note: ただし上記の値をそのままコピペすることは無効です
    }
}
