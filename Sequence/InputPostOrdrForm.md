```mermaid
sequenceDiagram
    participant Seller
    participant PostOrderFormUI
    Seller->>PostOrderFormUI :販売したいNFTを選択
    PostOrderFormUI->>Seller: 出品(token)情報登録ページ表示
    Seller->>Seller: 出品(token)情報入力
    Seller->>PostOrderFormUI: 出品(token)情報
    alt 入力情報に不備
        PostOrderFormUI->>Seller: 出品(token)情報登録ページ表示
        Seller->>Seller: 出品(token)情報入力
        Seller->>PostOrderFormUI: 出品(token)情報
    end
```