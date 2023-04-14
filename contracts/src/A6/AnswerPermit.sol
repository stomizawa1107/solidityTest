// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

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
        saleId = 0;
        if(msg.sender != nftPermit.ownerOf(_args.tokenId))
        {
            revert("Caller is not token owner.");
        }
        else
        {
            SAnswerPermit.SaleInfo memory info;
            info.owner = nftPermit.ownerOf(_args.tokenId);
            //送信先をコントラクトのアドレスに設定
            info.spender = address(this);
            info.tokenId = _args.tokenId;
            info.price = _args.price;
            info.deadline = _args.deadline;
            info.v = _args.v;
            info.r = _args.r;
            info.s = _args.s;
            saleList[nonce] = info;
            //このコントラクトに対してトークンの扱いの許可
            nftPermit.permit(nftPermit.ownerOf(info.tokenId),address(this),info.tokenId ,info.deadline,info.v,info.r,info.s);
        }
        return nonce;
    }

    /**
     * @dev 希望するNFTを購入する関数
     */
    function matchOrder(SAnswerPermit.MatchOrderArgs memory _args) external {
        // Note: Fill me!
       SAnswerPermit.SaleInfo memory info = saleList[_args.saleId];
        if(info.price > _args.amount )
        {
            revert("You must permit more money to this contract.");
        }
        else if(info.deadline <= block.timestamp)
        {
            revert("Deadline has already passed.");
        }
        else if( currencyPermit.balanceOf(msg.sender)  < info.price )
        {
            revert("You don't have enough money to buy it.");
        }
        else
        {
            //購入者からマーケットに対してapprove(permit)
            currencyPermit.permit(msg.sender,address(this),_args.amount ,_args.deadline,_args.v,_args.r,_args.s);
            //購入者から所持者に対して送金
            currencyPermit.transferFrom(msg.sender,info.owner, info.price);
            //トークンを購入者へ送信
            nftPermit.transferFrom(info.owner, msg.sender, info.tokenId ); 
            //購入されたNFTの商品情報削除
            _resetOrder(info.tokenId);
        }
    }

    /**
     * @dev 購入されたNFTの商品情報を削除する関数
     */
    function _resetOrder(uint256 _tokenId) internal {
        // Note: Fill me!
        uint counter = 0;
        //トークンIDからトークンの検索
        while(true)
        {
            if(saleList[counter].tokenId == _tokenId)
            {
                //見つかったら削除
                break;                
            }
            counter++;
        }
        delete saleList[counter];
    }
}