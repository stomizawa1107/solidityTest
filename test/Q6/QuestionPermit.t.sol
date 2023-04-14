// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import { SigUtils } from "scal-std/SigUtils.sol";
import { YourNFTPermit } from "src/A6/utils/YourNFTPermit.sol";
import { YourCurrencyPermit } from "src/A6/utils/YourCurrencyPermit.sol";
import { AnswerPermit } from "src/A6/AnswerPermit.sol";
import { SAnswerPermit } from "src/A6/interfaces/SAnswerPermit.sol";

contract Question_Permit is Test, SAnswerPermit {
    using stdStorage for StdStorage;

    AnswerPermit yourContract;
    address yourContractAddress;

    function setUp() public {
        yourContract = new AnswerPermit();
        yourContractAddress = address(yourContract);
    }

    /**
        Q-6. Permitを試す
        EIP-2612（Permit）について：https://eips.ethereum.org/EIPS/eip-2612
        EIP-2612はERC20でPermitを利用するという提案であり、これを理解したうえで使用する問である。
        シナリオ：ERC20、ERC721でPermitを利用して、NFTを売買する
     */
    function test_Q6_Permit() public {
        // setting
        Vars memory vars;
        //現在時刻の取得
        vars.START_TIME = block.timestamp;
        //アドレスとキーの作成。
        (vars.alice.addr, vars.alice.pkey) = makeAddrAndKey("0xA11CE");
        (vars.bob.addr, vars.bob.pkey) = makeAddrAndKey("0xB0B");
        (vars.carl.addr, vars.carl.pkey) = makeAddrAndKey("0xCA81");
        console.log(gasleft());
        //ERC721Permitを継承したYourNFTPermitのContractをnew
        YourNFTPermit permitNFT = new YourNFTPermit("YourNFT", "YNFT");
        //アリスのアドレスに対してNFTをミント×10
        for(uint256 i; i < 10;) {
            permitNFT.mintItem(vars.alice.addr);
            unchecked { ++i; }
        }
        //testerAddrsにアドレス群を代入
        address[] memory testerAddrs = new address[](3);
        testerAddrs[0] = vars.alice.addr;
        testerAddrs[1] = vars.bob.addr;
        testerAddrs[2] = vars.carl.addr;

        //ERC20Permitを継承したYourCurrencyPermitのContractをnew
        YourCurrencyPermit permitCurrency = new YourCurrencyPermit("YourCurrency", 3, testerAddrs);

        //permitNFT・permitCurrencyのアドレスをセット
        yourContract.setPermitNFTAddress(address(permitNFT));
        yourContract.setPermitCurrencyAddress(address(permitCurrency));

        //sigUtilのnew
        SigUtils nftSig = new SigUtils(permitNFT.DOMAIN_SEPARATOR());
        SigUtils currencySig = new SigUtils(permitCurrency.DOMAIN_SEPARATOR());

        // scenario
        //アリスの署名用keyの作成
        SigUtils.Permit memory alicePermit = SigUtils.Permit({
            owner: vars.alice.addr,
            spender: address(yourContract),
            value: 3,   //tokenId
            nonce: 0,
            deadline: vars.START_TIME + 1 days
        });
        vars.alice.digest =  nftSig.getTypedDataHash(alicePermit);

        (vars.alice.crypto.v , vars.alice.crypto.r, vars.alice.crypto.s) = vm.sign(vars.alice.pkey, vars.alice.digest);

        //現在のアドレスをボブのアドレスに
        vm.prank(vars.bob.addr);
        //ボブがアリスのnftを出品する事ができないためエラーに
        vm.expectRevert("Caller is not token owner.");
        //アリスのnftを6e17出品
        yourContract.postOrder(PostOrderArgs({
            tokenId: alicePermit.value,
            price: 6e17,   //tokenPrice
            deadline: alicePermit.deadline,
            v: vars.alice.crypto.v,
            r: vars.alice.crypto.r,
            s: vars.alice.crypto.s
        }));

        //現在のアドレスをアリスのアドレスに
        vm.prank(vars.alice.addr);
        //アリスのnftを6e17出品
        vars.saleId = yourContract.postOrder(SAnswerPermit.PostOrderArgs({
            tokenId: alicePermit.value,
            price: 6e17,
            deadline: alicePermit.deadline,
            v: vars.alice.crypto.v,
            r: vars.alice.crypto.r,
            s: vars.alice.crypto.s
        }));

        vars.slot = stdstore
                        .target(address(yourContract))
                        .sig(yourContract.saleList.selector)
                        .with_key(vars.saleId)
                        .depth(3)
                        .find();
        //設定金額が6e17であっているか
        assertEq((uint256(vm.load(address(yourContract), bytes32(vars.slot)))), 6e17);

        //ボブのキー設定
        SigUtils.Permit memory bobWrongPermit = SigUtils.Permit({
            owner: vars.bob.addr,
            spender: address(yourContract),
            value: 15e16,
            nonce: 0,
            deadline: block.timestamp + 2 days
        });

        vars.bob.wrongDigest = currencySig.getTypedDataHash(bobWrongPermit);

        (vars.bob.wrongCrypto.v, vars.bob.wrongCrypto.r, vars.bob.wrongCrypto.s) = vm.sign(vars.bob.pkey, vars.bob.wrongDigest);

        //ボブの使用認可しているethが足りない
        vm.expectRevert("You must permit more money to this contract.");
        //ボブのアドレス似設定
        vm.prank(vars.bob.addr);
        //ボブから購入申請
        yourContract.matchOrder(SAnswerPermit.MatchOrderArgs({
            saleId: vars.saleId,
            amount: bobWrongPermit.value,
            deadline: bobWrongPermit.deadline,
            v: vars.bob.wrongCrypto.v,
            r: vars.bob.wrongCrypto.r,
            s: vars.bob.wrongCrypto.s
        }));

        //ボブのキー設定
        SigUtils.Permit memory bobPermit = SigUtils.Permit({
            owner: vars.bob.addr,
            spender: address(yourContract),
            value: 6e17,
            nonce: 0,
            deadline: vars.START_TIME + 3 days
        });

        vars.bob.digest = currencySig.getTypedDataHash(bobPermit);

        (vars.bob.crypto.v, vars.bob.crypto.r, vars.bob.crypto.s) = vm.sign(vars.bob.pkey, vars.bob.digest);

        //現在の日付を二日後に
        vm.warp(vars.START_TIME + 2 days);
        //ボブのアドレスに設定
        vm.prank(vars.bob.addr);
        //締切期限が過ぎているよ
        vm.expectRevert("Deadline has already passed.");
        //購入申請
        yourContract.matchOrder(SAnswerPermit.MatchOrderArgs({
            saleId: vars.saleId,
            amount: bobPermit.value,
            deadline: bobPermit.deadline,
            v: vars.bob.crypto.v,
            r: vars.bob.crypto.r,
            s: vars.bob.crypto.s
        }));

        //現在時刻の設定
        vm.warp(vars.START_TIME);
        //ボブのアドレスの設定
        vm.prank(vars.bob.addr);
        //アリスのアドレスに5e17送金
        permitCurrency.transfer(vars.alice.addr, 5e17);
        //ボブのアドレスに設定。
        vm.prank(vars.bob.addr);
        //残高が不足している
        vm.expectRevert("You don't have enough money to buy it.");
        //購入申請
        yourContract.matchOrder(SAnswerPermit.MatchOrderArgs({
            saleId: vars.saleId,
            amount: bobPermit.value,
            deadline: bobPermit.deadline,
            v: vars.bob.crypto.v,
            r: vars.bob.crypto.r,
            s: vars.bob.crypto.s
        }));

        //アリスのアドレスに設定
        vm.prank(vars.alice.addr);
        //ボブに5e17送金
        permitCurrency.transfer(vars.bob.addr, 5e17);
        //ボブのアドレス似設定
        vm.prank(vars.bob.addr);
        //購入申請
        yourContract.matchOrder(SAnswerPermit.MatchOrderArgs({
            saleId: vars.saleId,
            amount: bobPermit.value,
            deadline: bobPermit.deadline,
            v: vars.bob.crypto.v,
            r: vars.bob.crypto.r,
            s: vars.bob.crypto.s
        }));

        //saleList[3].priceが0かチェック
        vars.slot = stdstore
                        .target(address(yourContract))
                        .sig(yourContract.saleList.selector)
                        .with_key(alicePermit.value)
                        .depth(3)
                        .find();
        assertEq((uint256(vm.load(address(yourContract), bytes32(vars.slot)))), 0);

        //ボブの再リリース用のキー作成
        SigUtils.Permit memory bobResalePermit = SigUtils.Permit({
            owner: vars.bob.addr,
            spender: address(yourContract),
            value: 3,
            nonce: 0,
            deadline: block.timestamp + 4 days
        });

        vars.bob.resaleDigest =  nftSig.getTypedDataHash(bobResalePermit);

        (vars.bob.resaleCrypto.v, vars.bob.resaleCrypto.r, vars.bob.resaleCrypto.s) = vm.sign(vars.bob.pkey, vars.bob.resaleDigest);

        //ボブのアドレスに設定
        vm.prank(vars.bob.addr);
        //8e17で再出品
        vars.saleId = yourContract.postOrder(PostOrderArgs({
            tokenId: bobResalePermit.value,
            price: 8e17,
            deadline: bobResalePermit.deadline,
            v: vars.bob.resaleCrypto.v,
            r: vars.bob.resaleCrypto.r,
            s: vars.bob.resaleCrypto.s
        }));
        console.log(vars.saleId);
        //カールの購入用のキーを設定
        SigUtils.Permit memory carlPermit = SigUtils.Permit({
            owner: vars.carl.addr,
            spender: address(yourContract),
            value: 8e17,
            nonce: 0,
            deadline: block.timestamp + 5 days
        });

        vars.carl.digest =  currencySig.getTypedDataHash(carlPermit);

        (vars.carl.crypto.v, vars.carl.crypto.r, vars.carl.crypto.s) = vm.sign(vars.carl.pkey, vars.carl.digest);

        //カールのアドレスに設定
        vm.prank(vars.carl.addr);

        yourContract.matchOrder(SAnswerPermit.MatchOrderArgs({
            saleId: vars.saleId,
            amount: carlPermit.value,
            deadline: carlPermit.deadline,
            v: vars.carl.crypto.v,
            r: vars.carl.crypto.r,
            s: vars.carl.crypto.s
        }));

        assertEq(permitCurrency.balanceOf(vars.alice.addr), 16e17);
        assertEq(permitCurrency.balanceOf(vars.bob.addr), 12e17);
        assertEq(permitCurrency.balanceOf(vars.carl.addr), 2e17);
        assertEq(permitNFT.ownerOf(3), vars.carl.addr);
    }
}