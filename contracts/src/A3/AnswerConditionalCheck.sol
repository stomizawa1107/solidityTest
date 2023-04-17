// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAnswerConditionalCheck } from "src/A3/interfaces/IAnswerConditionalCheck.sol";
import { SAnswerConditionalCheck } from "src/A3/interfaces/SAnswerConditionalCheck.sol";

contract AnswerConditionalCheck is IAnswerConditionalCheck, SAnswerConditionalCheck {

    /**
        A-3. 制御構文(if, for, require, revert), modifier, アクセス制御, オーナー権限を試す
     */
    bool public retOk = false;
    function borrowMore(Person memory person, uint256 amount)
        external override onlyYou(person) nonDept(person) toHigh(person,amount) returns (bool)
    {
        // Note: Fill me!
        retOk = true;
       return retOk;
    }

    modifier onlyYou(Person memory person)  {
        // Note: Fill me!
        if(person.addr == msg.sender)
        {
            _;
        }
        else
        {
            revert("You are not the owner of this account.");
        }
    }

    modifier nonDept(Person memory person) {
       if(person.debt == 0)
       {
            retOk = false;
            revert("Collateralization ratio must be more than 110%");
       }
       else
       {
            _;
       }
    }

     modifier toHigh(Person memory person,uint256 amount) {
       if((amount * person.collateral / person.debt) <= 110)
       {
            retOk = false;
            revert("Collateralization ratio is already too high");
       }
       else
       {
            _;
       }
    }
}
