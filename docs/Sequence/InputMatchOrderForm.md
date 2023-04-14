```mermaid
sequenceDiagram
    participant Buyer
    participant MarketUI
    participant MatchOrderFormUI
    Buyer->>MarketUI :購入したいNFTを選択
    MarketUI->>MatchOrderFormUI: 購入ページに切り替え
    MatchOrderFormUI->>Buyer: 購入ページの表示
    Buyer->>Buyer: 購入ボタン押下
    Buyer->>MatchOrderFormUI: 購入処理呼び出し
```