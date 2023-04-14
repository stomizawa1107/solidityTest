```mermaid
sequenceDiagram
    participant Seller
    participant PostOrderFormUI
    participant MarketUI
    participant EOA
    participant MarketSmartContract
        PostOrderFormUI->>EOA: 出品(token)情報送信
        EOA->>MarketSmartContract: 出品処理のコントラクト呼び出し(出品情報)
        
        alt revert(EOAとERC721 ownerOf(tokenID)が不一致)
            MarketSmartContract-->>EOA: tokenオーナー不一致通知
            EOA-->>PostOrderFormUI: tokenオーナー不一致通知
            PostOrderFormUI-->>Seller: tokenオーナー不一致通知
        else
            MarketSmartContract->>MarketSmartContract:ERC721 permit(所有者EOA,コントラクトアドレス,トークンID,締切期限,v,r,s)呼び出し
            alt ERC721 permitエラー
                MarketSmartContract-->>EOA: ERC721 permitエラー
                EOA-->>PostOrderFormUI: ERC721 permitエラー
                PostOrderFormUI-->>Seller: 出品失敗
            end
            MarketSmartContract-->>EOA: 正常終了
            EOA-->>PostOrderFormUI: 正常終了
            PostOrderFormUI-->>Seller: 出品完了            
            PostOrderFormUI->>MarketUI: 出品情報の通知
            MarketUI->>MarketUI: 出品情報の表示     
        end
        ```