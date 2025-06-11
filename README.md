

## 概要
- キーワードを入力しGitHubリポジトリを検索したり、ユーザのリポジトリやスター済みのリポジトリを確認できるiOSアプリケーションです
- 下記リポジトリを基底としています。
  - [株式会社ゆめみ iOS エンジニアコードチェック課題](https://github.com/yumemi-inc/ios-engineer-codecheck)
  - [以前に同課題を作成したもの](https://github.com/pommdau/github-repository-search)

## プレビュー

|ログイン・ログアウト|ユーザのコンテンツ表示|リポジトリ検索|
|---|---|---|
|<video src="https://github.com/user-attachments/assets/c258418a-ce7d-4597-bacc-b5bbf97d47a3">|<video src="https://github.com/user-attachments/assets/9e2da800-c728-4bdf-a12c-a66ef5b7cfac">|<video src="https://github.com/user-attachments/assets/cacac18a-fafc-4792-952b-a249525ad8d0">|

## 技術スタック
### 全般

|区分||
|---|---|
|言語|Swift 6.0|
|UIフレームワーク|SwiftUI|
|iOSのバージョン|iOS 17.6以降|
|アーキテクチャ|SVVS (=MVVM+Storeパターン)|
|ライブラリ管理|SwiftPM|
|テスト|XCTest|
|Linter|[SwiftLint](https://github.com/realm/SwiftLint)|

### アーキテクチャ

- SVVS(MVVM + Storeパターン)
    - 参考: [ChatworksさんのiOSDC2023の発表](https://github.com/chatwork/svvs-sample?tab=readme-ov-file)

![image](https://i.imgur.com/g224phy.png)

|名称|役割|
|---|---|
|View|画面の提供|
|ViewState|Viewの状態とアクションの管理|
|Store|アプリ内で利用する共通情報の一元管理|
|Repository/Backend|ローカルでのデータ永続化|
|Entiry|取り扱うデータ型の定義|

<details>
<summary>採用理由</summary>

- データフローが簡潔で安全に扱うことができる点
    - Storeを「Single Source of Truth」とし、ユーザのアクションやAPI通信の結果を一元的に管理することで、データの不整合を防止できる
    - `Observation`の登場でリアクティブ部分をより簡潔に書けるようになったことも嬉しい
- また`View`からロジックと状態変化の部分を`ViewState`に切り出すことで、ユニットテストが書きやすい
- `Store`-`ViewState`-`View`と小さい単位で扱うので影響範囲の把握やテストをしやすいのが嬉しく、またこれを最小単位としてプロダクトの成長に合わせてスケールできるため

</details>

<details>
<summary>現在の課題</summary>

- ロジックが`ViewState`に集中するので肥大化する懸念がある。その際は`UseCase`で分割するのが良いだろうか。
- `ViewState`から`Store`へ外部APIの通信処理を呼び出すための関数の宣言が冗長になる。

```swift
extension RepoStore {
    
    func searchRepos(
        searchText: String,
        accessToken: String?,
        sort: String?,
        order: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> SearchResponse<Repo> {
        let response = try await gitHubAPIClient.searchRepos(
            query: searchText,
            accessToken: accessToken,
            sort: sort,
            order: order,
            perPage: perPage,
            page: page
        )
        try await addValues(response.items)
        return response
    }
    ...
}
```

- また外部APIの結果を複数の`Store`に保存する場合、`ViewState`から`Store`に値を保存させる必要があって煩雑になってしまう
    - 例: `RepoStore`でスター済みリポジトリの一覧を取得した後、`ViewState`から`StarredRepoStore`にその情報を登録する必要がある
- 解決策としては複数の`Store`を結合させる、または`ViewState`に外部APIの処理をさせるか。
- (この辺り自分の中でもまだ答えが出せていないです)

</details>

### 外部ライブラリ

|名前|説明|
|---|---|
|[ikeh-github-api-client](https://github.com/pommdau/ikeh-github-api-client/)|GitHub API通信を行うための自作パッケージ|
|[KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)|Keychainを簡便に操作するために利用|
|[LicenseList](https://github.com/cybozu/LicenseList)|利用している外部ライブラリの一覧の作成に利用|
|[SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI)|Webからの画像のダウンロード・表示およびそのキャッシュ管理。AsyncImageの一部代替として利用。|
|[swift-concurrency-extras](https://github.com/pointfreeco/swift-concurrency-extras)|非同期処理のUnitTestで利用|
|[swift\-http\-types](https://github.com/apple/swift-http-types)|HTTP通信処理を型安全に扱えるため|
|[SwiftLintPlugins](https://github.com/SimplyDanny/SwiftLintPlugins)|SwiftLintのプラグイン|
|[SwiftUI\-Shimmer](https://github.com/markiv/SwiftUI-Shimmer)|スケルトンスクリーンで利用|

## 動作確認の手順

- 準備として個人のGitHubのOAuth Appを作成する必要があります
  - 参考: [iOSアプリでGitHubAPIのOAuth認証を行う](https://zenn.dev/ikeh1024/articles/dd5678087362c4)
- その後下記のようなファイルを作成してください

```swift
// GitHubAPICredentials.swift

/// GitHubAPIの認証情報(.gitignoreで管理から除外)
enum GitHubAPICredentials {
    /// クライアントID
    static let clientID = "<your-client-id>"
    /// クライアントシークレット
    static let clientSecret = "<your-client-secret>"
}
```

- または上記の代替として、簡単に動作を確認したい場合は下記のSchemeからビルド・実行してください
- ただし簡易的なStubを差し込んでいるだけなので、検索の続きの読み込みやスター処理など一部動作しない箇所があります

<img width="532" alt="image" src="https://github.com/user-attachments/assets/a5950b45-29c8-40a5-9e63-b2871d370116" />

