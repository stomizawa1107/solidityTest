---
title: FAQ Answer sheet 6
---

## FAQ Answer Sheet 6
1. Q：コードの流れを見ると、AliceがyourContractに取引する許可をしているように見えますが、これが署名を渡すということですか？
   A：はい、その認識で間違いありません。補足しますと、Aliceが許可するのではなく、渡された署名を検証(Permitを実行)することで許可されるというイメージになります。
<br>

2. Q：v,r,sがいまいちわかりませんでした。わかりやすいサイトなどはありますか？
   A：v,r,sとは、イーサリアム上でトランザクションを行う際に署名として利用される暗号、ECDSA暗号に関連した数値になります。以下の　 URLに解説がございますので、ご覧ください。
   　 https://zoom-blc.com/what-is-ecdsa
<br>

3. Q：ecrecover()を使っているサイトがありましたが、関係ありますか？
   A：関係ありません。
<br>

4. Q：テストコードにあるexpectRevert("Caller is not token owner.")のcallerはbob、token ownerはAliceで合っていますか？
　 A：はい、その認識で間違いありません。
<br>

5. Q：Answer_Permit.sol側でAliceのaddressを取得する方法がわかりません。
   A：Answer_Permit.sol側に用意させていただいております、saleListをご利用ください。
<br>

6. Q：シナリオの最初の流れは、AliceがyourContractにERC721トークンを取引する権利を委任する。委任されたyourContractは、実行者がtoken ownerであるAliceであるか検証を行い、実行者がbobであるため、検証失敗となりrevertする。という認識で間違いありませんか？
   A：図（シーケンス）などを作成すれば、よりよくコードのやり取りを理解できるかと思いますので、そちらで確認していただけると幸いです。
<br>

7. Q：postOrderでsaleListに署名を代入しているのですが、これは根本的に間違えていますか？
   A：saleListへ商品を登録する点に関しては合っております。
   　 ただし、saleListは、あくまで商品情報のリストです。商品の登録をしてもpostOrderしたことにはなりません。
   　 ヒントとして、postOrderにはPermitが関係します。（この問題のタイトルです）
<br>

8. Q：PermitはIERC721Permitを呼び出して使うという感じなのでしょうか？ただ、これだと赤い破線がでてエラーとなっていました。
   A：ERC721のPermit利用に関して、utilsディレクトリにありますERC721Permit.solを利用していただくことになります。
   　 こちらのためのユーティリティがIERC721Permitとなっております。
   　 エラーについてですが、importエラーは、利用して動作エラーとならなければ問題ありません。こちらREADME.mdにも書かせていただいておりいます事象であり、お手数をお掛けします。
<br>

9. Q：Answer_Permit.solからERC721Permit.solを使おうとしているのですが、継承もなく、importされている様子もありません。どのように利用するのですか？
   A：ERC721Permitについては、YourNFTPermitというコントラクトをテスト内でimportして利用しております。なぜそのような仕様になっているか、探りながら進めていただけると幸いです。
<br>

10. Q：permitNFTAddressはどのように利用すべきですか？
   A：このアドレスの利用方法は、postOrderまでの間で行われているsetPermitNFTAddressをご覧ください。
   　 ヒントとして、_nftが何を指しているのか、考えてみてください。これを理解すると、Answer側でどのようにインスタンスを利用するかわかると思われます。
<br>

11. Q：deadlineとはsaleListのトークンのdeadlineで合っていますか？
   A：はい、その認識で間違いありません。
-----

