```mermaid

sequenceDiagram
    participant PostOrderFormUI
    participant EOA
    participant MarketSmartContract
    PostOrderFormUI->>EOA:ERC20 TransferFrom呼び出し
    EOA->>MarketSmartContract:ERC20 TransferFrom(所有者EOA、購入者EOA、amount)
    MarketSmartContract->>MarketSmartContract:ApprovalTransferFrom(所有者EOA、購入者EOA、amount)
    alt 所有者EOAが異常値
        MarketSmartContract-->>EOA:所有者EOAエラー
        EOA-->>PostOrderFormUI:所有者EOAエラー
    else
        alt コントラクトアドレスが異常値
            MarketSmartContract-->>EOA:コントラクトアドレスが異常値
            EOA-->>PostOrderFormUI:コントラクトアドレスが異常値
        else
            alt amountがコントラクトアドレスに対してapproveされていない
                MarketSmartContract-->>EOA:approve未許可エラー
                EOA-->>PostOrderFormUI:approve未許可エラー
            else
                alt amountがbalanceを超えている
                    MarketSmartContract-->>EOA:balance不足エラー
                    EOA-->>PostOrderFormUI:balance不足エラー
                else
                    MarketSmartContract-->>EOA:ERC20 TransferFrom成功
                    EOA-->>PostOrderFormUI:ERC20 TransferFrom成功
                end
            end
        end
    end
```
