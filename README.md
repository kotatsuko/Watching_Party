# Watching Party
![ER図](https://raw.githubusercontent.com/kotatsuko/Watching_Party/main/app/assets/images/Watching%20Party.png)

## サイト概要
同時視聴をしたい人を募り、リアルタイムコメント機能で視聴をより楽しむコミュニティサイト
### サイトテーマ
- グループ機能で同時視聴をするメンバーを集める
- 投稿機能で同時視聴するメンバーを募ったり、作品の感想を投稿できる
- リアルタイムコメント機能で、感想を共有し合う


### テーマを選んだ理由
動画コンテンツを同時視聴を使いより楽しむため

### ターゲットユーザ
動画コンテンツを複数人で楽しみたいユーザー

### 主な利用シーン
- 同時視聴をしたいとき
- 動画コンテンツの感想を共有したいとき
- 気になる動画の感想を見たいとき

## 設計書
### ER図
![ER図](https://raw.githubusercontent.com/kotatsuko/Watching_Party/main/app/assets/images/Watching_Party-ER%E5%9B%B3%E4%BF%AE%E6%AD%A3%E7%89%88.jpg)

## 主な機能
 - ログイン機能
   - ユーザー名
   - メールアドレス
   - パスワード
   - プロフィール画像
   - 退会ステータス
 - 投稿機能
   - 本文
   - タグ
 - 投稿いいね機能
 - 投稿コメント機能
 - フォロー機能
 - グループ機能
   - グループオーナー
   - グループ名
   - グループ説明
   - タグ
   - 動画タイプ
   - 視聴作品名
   - 視聴時間
   - 視聴開始時間
 - グループオーナー機能
   - グループ情報の変更
   - グループメンバーの削除
   - グループコメントの削除
 - コメント機能
 - グループ、投稿検索機能
 - ゲストログイン機能
   - 投稿、グループの閲覧
 - 管理者機能
   - ユーザー情報編集
   - ユーザー退会
   - 投稿削除
   - グループ作成
   - グループ削除


## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ：jQuery
- IDE：Cloud9

## 使用素材
- Canva(https://www.canva.com/)