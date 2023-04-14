```mermaid
sequenceDiagram
    participant PostOrderFormUI
    participant EOA
    participant MarketSmartContract
    PostOrderFormUI->>EOA: 出品情報
    EOA->>MarketSmartContract:ERC20 permit(購入者EOA,コントラクトアドレス,amount,締切期限,v,r,s)呼び出し
            alt 現在時刻>締め切り時間
                MarketSmartContract-->>EOA: 期限切れ通知
                EOA-->>PostOrderFormUI: 期限切れ通知
            else
                MarketSmartContract->>MarketSmartContract: 署名チェック
                alt 署名が出品者と一致しない
                    MarketSmartContract-->>EOA:ERC20 permit失敗　署名チェックエラー通知
                    EOA-->>PostOrderFormUI:ERC20 permit失敗　署名チェックエラー通知
                else
                    MarketSmartContract->>MarketSmartContract:ERC20 approve(購入者EOA、SmartContractMarketアドレス、amount)
                    alt approve 失敗
                        MarketSmartContract-->>EOA:ERC20 permit失敗 approveエラー通知
                        EOA-->>PostOrderFormUI:ERC20 permit失敗 approveエラー通知
                    else
                        MarketSmartContract-->>EOA:ERC20 permit成功
                        EOA-->>PostOrderFormUI:ERC20 permit成功
                    end
                end
            end
```
