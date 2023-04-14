// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface SAnswerPermit {
    struct Crypto {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    struct SaleInfo {
        address owner;
        address spender;
        uint256 tokenId;
        uint256 price;
        uint256 deadline;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    struct Vars {
        Person alice;
        Person bob;
        Person carl;
        uint256 slot;
        uint256 START_TIME;
        uint256 saleId;
    }

    struct Person {
        address addr;
        uint256 pkey;
        bytes32 digest;
        bytes32 wrongDigest;
        bytes32 resaleDigest;
        Crypto crypto;
        Crypto wrongCrypto;
        Crypto resaleCrypto;
    }

    struct PostOrderArgs {
        uint256 tokenId;
        uint256 price;
        uint256 deadline;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    struct MatchOrderArgs {
        uint256 saleId;
        uint256 amount;
        uint256 deadline;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }
}