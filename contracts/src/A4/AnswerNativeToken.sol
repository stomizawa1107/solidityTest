// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAnswerNativeToken } from "src/A4/interfaces/IAnswerNativeToken.sol";
import { SAnswerNativeToken } from "src/A4/interfaces/SAnswerNativeToken.sol";

contract AnswerNativeToken is IAnswerNativeToken, SAnswerNativeToken {

    /**
        A-4. ネイティブトークン支払いを試す
     */
    mapping(address => LicenseCandidate) public licenseHolders;

    function gimmeLicense(LicenseCandidate memory candidate)
        external payable override onlyYou2(candidate)
    {
        // Note: Fix me!
        if(msg.value < 1 ether)
        {
            require(candidate.score > 80, "You failed.");
        }
        licenseHolders[msg.sender] = candidate;
    }

    modifier onlyYou2(LicenseCandidate memory candidate) {
        require(msg.sender == candidate.addr, "You are not the owner of this account.");
        _;
    }
}
