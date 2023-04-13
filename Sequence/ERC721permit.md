```mermaid
sequenceDiagram
    participant PostOrderFormUI
    participant EOA
    participant MarketSmartContract
    PostOrderFormUI->>EOA: ERC721 permit呼び出し
    EOA->>MarketSmartContract:ERC721 permit(所有者EOA,コントラクトアドレス,トークンID,締切期限,v,r,s)呼び出し
            alt 現在時刻>締め切り時間
                MarketSmartContract-->>EOA: 期限切れ通知
                EOA-->>PostOrderFormUI: 期限切れ通知
            else
                MarketSmartContract->>MarketSmartContract: 署名チェック
                alt 署名が出品者と一致しない
                    MarketSmartContract-->>EOA:ERC721 permit失敗　署名チェックエラー通知
                    EOA-->>PostOrderFormUI:ERC721 permit失敗　署名チェックエラー通知
                else
                    MarketSmartContract->>MarketSmartContract:ERC721 approve(所有者EOA、SmartContractMarketアドレス、トークンID)
                    alt approve 失敗
                        MarketSmartContract-->>EOA:ERC721 permit失敗 approveエラー通知
                        EOA-->>PostOrderFormUI:ERC721 permit失敗 approveエラー通知
                    else
                        MarketSmartContract-->>EOA:ERC721 permit成功
                        EOA-->>PostOrderFormUI:ERC721 permit成功
                    end
                end
            end
```
