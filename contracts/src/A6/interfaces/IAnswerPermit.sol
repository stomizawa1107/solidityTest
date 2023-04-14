// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SAnswerPermit } from "src/A6/interfaces/SAnswerPermit.sol";

interface IAnswerPermit {
    function setPermitNFTAddress(address _nft) external;
    function setPermitCurrencyAddress(address _currency) external;
    function postOrder(SAnswerPermit.PostOrderArgs memory _args) external returns (uint256 saleId);
    function matchOrder(SAnswerPermit.MatchOrderArgs memory _args) external;
}