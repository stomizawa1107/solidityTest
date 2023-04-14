# Q-6. Permitを試す
        EIP-2612（Permit）について：https://eips.ethereum.org/EIPS/eip-2612
        EIP-2612はERC20でPermitを利用するという提案であり、これを理解したうえで使用する問である。
        シナリオ：ERC20、ERC721でPermitを利用して、NFTを売買する


## 手順
[QuestionNFT.t.sol](../../test/Q1/QuestionNFT.t.sol)ファイル内にあるテスト関数`test_Q6_Permit()`のシナリオをよく読み、
[AnswerNFT.sol](./AnswerNFT.sol)ファイル内の`postOrder()`, `matchOrder()`, `_resetOrder()` を変更してテストをPASSさせてください。
必要に応じて別途ヘルパー関数やmapping等も作成してください。


## 初期ソースコード
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { YourNFTPermit } from "src/A6/utils/YourNFTPermit.sol";
import { YourCurrencyPermit } from "src/A6/utils/YourCurrencyPermit.sol";
import { SAnswerPermit } from "src/A6/interfaces/SAnswerPermit.sol";
import { IAnswerPermit } from "src/A6/interfaces/IAnswerPermit.sol";

contract AnswerPermit is IAnswerPermit {
    /**
        Q-6. Permitを試す
        EIP-2612（Permit）について：https://eips.ethereum.org/EIPS/eip-2612
        EIP-2612はERC20でPermitを利用するという提案であり、これを理解したうえで使用する問である。
        シナリオ：ERC20、ERC721でPermitを利用して、NFTを売買する
     */
    uint256 nonce;
    YourNFTPermit nftPermit;
    YourCurrencyPermit currencyPermit;
    
    /**
     * @dev Permit用のNFTAddressを設定する関数
     */
    function setPermitNFTAddress(address _nft) public {
        address permitNFTAddress = _nft;
        nftPermit = YourNFTPermit(permitNFTAddress);
    }

    /**
     * @dev Permit用のCurrencyAddressを設定する関数
     */
    function setPermitCurrencyAddress(address _currency) public {
        address permitCurrencyAddress = _currency;
        currencyPermit = YourCurrencyPermit(permitCurrencyAddress);
    }

    // postOrderしたNFTの商品情報を商品番号(nonce)から得る
    mapping(uint256 => SAnswerPermit.SaleInfo) public saleList;

    /**
     * @dev NFTを出品する関数
     */
    function postOrder(SAnswerPermit.PostOrderArgs memory _args) external returns (uint256 saleId) {
        // Note: Fill me!
    }

    /**
     * @dev 希望するNFTを購入する関数
     */
    function matchOrder(SAnswerPermit.MatchOrderArgs memory _args) external {
        // Note: Fill me!
    }

    /**
     * @dev 購入されたNFTの商品情報を削除する関数
     */
    function _resetOrder(uint256 _tokenId) internal {
        // Note: Fill me!
    }
}
```


## FAQ
[FAQ日本語版](./docs/FAQ/FAQ.ja.md)
