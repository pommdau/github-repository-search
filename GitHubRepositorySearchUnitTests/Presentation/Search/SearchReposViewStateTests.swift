//
//  SearchReposViewState.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/05/28.
//

import XCTest
@testable import GitHubRepositorySearch
import ConcurrencyExtras
import IKEHGitHubAPIClient

@MainActor
final class SearchReposViewStateTests: XCTestCase {
    
    // MARK: - Property
    
    private var sut: SearchReposViewState!
    
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
}

// MARK: - リポジトリの検索のテスト

extension SearchReposViewStateTests {
    
    /// リポジトリの検索_initialの状態から_成功
    func testSearchReposFromInitialSuccess() async throws {
                       
        func test() async throws {

            // MARK: Given
            
            let testSearchText = "searchText"
            let testRepos: [Repo] = Repo.Mock.random(count: 10)
            let testNextLink: RelationLink.Link = try XCTUnwrap(.Mock.createSearchReposNext(query: "query", perPage: 10, page: 2))
            let repoStore: RepoStoreStub = .init()
            repoStore.stubbedSearchReposResponse = .init(
                totalCount: testRepos.count,
                items: testRepos,
                relationLink: .init(next: testNextLink)
            )
            sut = .init(
                searchText: testSearchText,
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                searchReposSuggestionStore: SearchReposSuggestionStoreStub()
            )
            XCTAssertTrue(sut.asyncRepos.isInitial)
            
            // MARK: When
                       
            sut.handleSearchRepos()
            
            // MARK: Then

            XCTAssertTrue(sut.asyncRepos.isLoading)
            _ = await sut.searchReposTask?.value
            
            // 検索後の状態確認
            XCTAssertTrue(sut.asyncRepos.isLoaded)
            XCTAssertEqual(sut.asyncRepos.values, testRepos)
            XCTAssertEqual(sut.nextLink, testNextLink)
            XCTAssertEqual(sut.lastSearchText, testSearchText)
            XCTAssertEqual(sut.searchReposSuggestionStore.histories.first, testSearchText)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    /// リポジトリの検索_initialの状態から_キャンセルされた
    func testSearchReposFromInitialCancelled() async throws {
                       
        func test() async throws {

            // MARK: Given
            
            let testSearchText = "searchText"
            let repoStore: RepoStoreStub = .init()
            repoStore.stubbedError = GitHubAPIClientError.apiError(.Mock.badCredentials)
            sut = .init(
                searchText: testSearchText,
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                searchReposSuggestionStore: SearchReposSuggestionStoreStub()
            )
            XCTAssertTrue(sut.asyncRepos.isInitial)
            
            // MARK: When
                       
            sut.handleSearchRepos()
            
            // MARK: Then

            XCTAssertTrue(sut.asyncRepos.isLoading)
            let searchReposTask = sut.searchReposTask // sut側のtaskはキャンセル後にnilになってしまいテストできなくなるため、テスト側で参照を保持させる
            sut.handleCancelSearchRepos()
            _ = await searchReposTask?.result // キャンセルされたタスクの結果を待つ
            
            // 検索後の状態確認
            XCTAssertTrue(sut.asyncRepos.isInitial) // キャンセルされたため、状態は初期状態に戻る
            XCTAssertEqual(sut.searchReposSuggestionStore.histories.first, testSearchText)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    /// リポジトリの検索_initialの状態から_失敗(APIエラー)
    func testSearchReposFromInitialFailed() async throws {
                       
        func test() async throws {

            // MARK: Given
            
            let testSearchText = "searchText"
            let testError: GitHubAPIError = .Mock.badCredentials
            let repoStore: RepoStoreStub = .init()
            repoStore.stubbedError = GitHubAPIClientError.apiError(testError)
            sut = .init(
                searchText: testSearchText,
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                searchReposSuggestionStore: SearchReposSuggestionStoreStub()
            )
            XCTAssertTrue(sut.asyncRepos.isInitial)
            
            // MARK: When
                       
            sut.handleSearchRepos()
            
            // MARK: Then

            XCTAssertTrue(sut.asyncRepos.isLoading)
            _ = await sut.searchReposTask?.value
            
            // 検索後の状態確認
            XCTAssertTrue(sut.asyncRepos.isError)
            XCTAssertEqual(sut.searchReposSuggestionStore.histories.first, testSearchText)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    /// スター済みリポジトリの取得_loadingの状態から_変化無し
    func testSearchReposFromLoadingSuccess() async throws {

        // MARK: - Given
        
        let testSearchText = "searchText"
        let repoStore: RepoStoreStub = .init()
        repoStore.stubbedError = GitHubAPIClientError.apiError(.Mock.badCredentials)
        sut = .init(
            searchText: testSearchText,
            tokenStore: TokenStoreStub(accessToken: "accessToken"),
            repoStore: repoStore,
            searchReposSuggestionStore: SearchReposSuggestionStoreStub(),
            asyncRepoIDs: .loading([]) // 初期状態をloadingに設定
        )
        XCTAssertTrue(sut.asyncRepos.isLoading)
        
        // MARK: When
                   
        sut.handleSearchRepos()
        
        // MARK: Then

        XCTAssertTrue(sut.asyncRepos.isLoading)
        _ = await sut.searchReposTask?.value
        XCTAssertTrue(sut.asyncRepos.isLoading) // 状態はloadingのまま変化しない
    }
}

// MARK: - 追加検索のテスト

// TODO 整理
private enum TestData {
    struct LoadingMore {
        let searchText: String
        let testRepos: [Repo]
        
        // 読み込み済みのデータ
        let loadedRepos: [Repo]
        let loadedNextLink: RelationLink.Link

        // 新規に読み込まれるデータ
        let loadedMoreRepos: [Repo]
        let loadedMoreNextLink: RelationLink.Link
        
        init(searchText: String = "SwiftUI") throws {
            self.searchText = searchText
            self.testRepos = Repo.Mock.random(count: 20)

            // 読み込み済みのデータ
            self.loadedRepos = Array(testRepos[0..<10])
            self.loadedNextLink = try .Mock.createSearchReposNext(query: searchText, perPage: 10, page: 2)
                                    
            // 新規に読み込まれるデータ
            self.loadedMoreRepos = Array(testRepos[10..<20])
            self.loadedMoreNextLink = try .Mock.createSearchReposNext(query: searchText, perPage: 10, page: 3)
        }
    }
}

extension SearchReposViewStateTests {
    
    /// リポジトリの追加検索_成功
    func testSearchReposMoreSuccess() async throws {
                       
        func test() async throws {

            // MARK: Given
            
            let testData = try TestData.LoadingMore()
            let repoStore: RepoStoreStub = .init(valuesDic: testData.loadedRepos.convertToValuesDic())
            repoStore.stubbedSearchReposResponse = .init(
                totalCount: testData.loadedMoreRepos.count,
                items: testData.loadedMoreRepos,
                relationLink: .init(next: testData.loadedMoreNextLink)
            )
            sut = .init(
                searchText: testData.searchText,
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                searchReposSuggestionStore: SearchReposSuggestionStoreStub(),
                asyncRepoIDs: .loaded(testData.loadedRepos.map { $0.id }),
                nextLink: testData.loadedNextLink
            )
            XCTAssertTrue(sut.asyncRepos.isLoaded)
            
            // MARK: When
                       
            sut.handleSearchReposMore()
            
            // MARK: Then
            XCTAssertTrue(sut.asyncRepos.isLoadingMore)
            _ = await sut.searchReposTask?.value
            
            // 検索後の状態確認
            XCTAssertTrue(sut.asyncRepos.isLoaded)
            XCTAssertEqual(sut.asyncRepos.values, testData.testRepos)
            XCTAssertEqual(sut.nextLink, testData.loadedMoreNextLink)
            XCTAssertEqual(sut.lastSearchText, testData.searchText)
            XCTAssertEqual(sut.searchReposSuggestionStore.histories.first, testData.searchText)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    /// リポジトリの追加検索_失敗(APIエラー)
    func testSearchReposMoreFailed() async throws {
                       
        func test() async throws {

            // MARK: Given
            
            let testData = try TestData.LoadingMore()
            let testError: GitHubAPIError = .Mock.badCredentials
            let repoStore: RepoStoreStub = .init(valuesDic: testData.loadedRepos.convertToValuesDic())
            repoStore.stubbedError = testError
            sut = .init(
                searchText: testData.searchText,
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                searchReposSuggestionStore: SearchReposSuggestionStoreStub(),
                asyncRepoIDs: .loaded(testData.loadedRepos.map { $0.id }),
                nextLink: testData.loadedNextLink
            )
            XCTAssertTrue(sut.asyncRepos.isLoaded)
            
            // MARK: When
                       
            sut.handleSearchReposMore()
            
            // MARK: Then
            XCTAssertTrue(sut.asyncRepos.isLoadingMore)
            _ = await sut.searchReposTask?.value
            
            // 検索後の状態確認
            XCTAssertTrue(sut.asyncRepos.isError)
            XCTAssertEqual(sut.asyncRepos.values, testData.loadedRepos)
            XCTAssertEqual(sut.nextLink, testData.loadedNextLink)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
}
