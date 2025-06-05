

## 概要
- キーワードを入力しGitHubリポジトリを検索したり、ユーザのリポジトリやスター済みのリポジトリを確認できるiOSアプリケーションです
- 下記リポジトリを基底としています。
  - [株式会社ゆめみ iOS エンジニアコードチェック課題](https://github.com/yumemi-inc/ios-engineer-codecheck)
  - [pommdau/github-repository-search](https://github.com/pommdau/github-repository-search)
      - 数年前に作成したもの

## 技術スタック
### 全般

|区分||
|---|---|
|言語|Swift 6.0|
|UIフレームワーク|SwiftUI|
|iOSのバージョン|iOS 17.6以降|
|アーキテクチャ|SVVS (=MVVM+Storeパターン)|
|ライブラリ管理|SwiftPM|
|テスト|XCTest / XCUITest|
|Linter|[SwiftLint](https://github.com/realm/SwiftLint)|


### アーキテクチャ

- SVVS(MVVM + Storeパターン)

![image](https://i.imgur.com/g224phy.png)

### ライブラリ

|名前|説明|
|---|---|
|[swift\-http\-types](https://github.com/apple/swift-http-types)|HTTP通信処理を型安全に扱う|
|[R\.swift](https://github.com/mac-cain13/R.swift)|リソースのシンボル化|
|[SwiftUI\-Shimmer](https://github.com/markiv/SwiftUI-Shimmer)|スケルトンスクリーンで利用|
|[SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI)|Webからの画像のダウンロード・表示およびそのキャッシュ管理|

## 実装で工夫した点
- (TBD)

## スクリーンショット

| 検索前 | 検索中 | 検索後 | 詳細画面 |
|---|---|---|---|
|---|---|---|---|

https://github.com/user-attachments/assets/3e26fc78-ad01-434c-b901-750513873b4d
