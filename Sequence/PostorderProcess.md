```mermaid
sequenceDiagram
    participant Seller
    participant PostOrderFormUI
    participant MarketUI
    participant EOA
    participant MarketSmartContract
        PostOrderFormUI->>EOA: 出品(token)情報送信
        EOA->>MarketSmartContract: 出品処理のコントラクト呼び出し(出品情報)
        
        alt revert(EOAとERC20 ownerOf(tokenID)が不一致)
            MarketSmartContract-->>PostOrderFormUI: tokenオーナー不一致通知
            PostOrderFormUI-->>Seller: tokenオーナー不一致通知
        else
            MarketSmartContract->>MarketSmartContract: (所有者アドレス,コントラクトアドレス,トークンID,締切期限,v,r,s)呼び出し
            MarketSmartContract->>PostOrderFormUI: 正常終了
            PostOrderFormUI->>Seller: 出品完了            
            PostOrderFormUI->>MarketUI: 出品情報の通知         
            MarketUI->>MarketUI: 出品情報の表示     
        end
        ```