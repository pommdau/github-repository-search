//
//  LoginUserReposListViewStateTests.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/06/09.
//

@testable import GitHubRepositorySearch
import XCTest
import ConcurrencyExtras
import IKEHGitHubAPIClient

@MainActor
final class LoginUserReposListViewStateTests: XCTestCase {
    
    // MARK: - Property
    
    private var sut: LoginUserReposListViewState!
    
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

// MARK: - リポジトリ一覧の取得のテスト

extension LoginUserReposListViewStateTests {
    
    /// ログインユーザのリポジトリの取得_initialの状態から_成功
    func testFetchUserReposFromInitialSuccess() async throws {
        
        func test() async throws {
            
            // MARK: Given
            
            let testRepos: [IKEHGitHubAPIClient.Repo] = IKEHGitHubAPIClient.Repo.Mock.random(count: 10)
            let testRelationLink: RelationLink = .init(
                next: try RelationLink.Link.Mock.createFetchAuthenticatedUserReposNext(
                    perPage: 10,
                    page: 2
                )
            )
            let repoStore: RepoStoreStub = .init()
            repoStore.stubbedFetchAuthenticatedUserReposResponse = .init(
                items: testRepos,
                relationLink: testRelationLink
            )
            sut = .init(
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore
            )
            
            // MARK: When
            let task = Task {
                await sut.handleFetchUserRepos()
            }
            
            // MARK: Then
            await Task.yield()
            XCTAssertTrue(sut.asyncRepoIDs.isLoading)
            _ = await task.value // 全処理の完了を待つ
            XCTAssertTrue(sut.asyncRepoIDs.isLoaded)
            XCTAssertEqual(sut.asyncRepoIDs.values, testRepos.map { $0.id })
            XCTAssertEqual(sut.nextLink, testRelationLink.next)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    /// ログインユーザのリポジトリの取得_initialの状態から_失敗(APIエラー)
    func testFetchUserReposFromInitialFailed() async throws {
        
        func test() async throws {
            
            // MARK: Given
            
            let repoStore: RepoStoreStub = .init()
            repoStore.stubbedError = GitHubAPIClientError.apiError(.Mock.badCredentials)
            sut = .init(
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore
            )
            
            // MARK: When
            
            XCTAssertTrue(sut.asyncRepoIDs.isInitial)
            let task = Task {
                await sut.handleFetchUserRepos()
            }
            
            // MARK: Then
            await Task.yield()
            XCTAssertTrue(sut.asyncRepoIDs.isLoading)
            _ = await task.value // 全処理の完了を待つ
            
            // 期待するエラー発生時の状態となっているか
            XCTAssertTrue(sut.asyncRepoIDs.isError)
            XCTAssertEqual(sut.asyncRepoIDs.values, [])
            XCTAssertNil(sut.nextLink)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
}

// MARK: - リポジトリの追加取得_成功

private struct FetchUserReposMoreTestData {
    let testRepos: [Repo]
    
    // 読み込み済みのデータ
    let loadedRepos: [Repo]
    let loadedNextLink: RelationLink.Link

    // 新規に読み込まれるデータ
    let loadedMoreRepos: [Repo]
    let loadedMoreNextLink: RelationLink.Link
    
    init() throws {
        self.testRepos = Repo.Mock.random(count: 20)

        // 読み込み済みのデータ
        self.loadedRepos = Array(testRepos[0..<10])
        self.loadedNextLink = try .Mock.createFetchAuthenticatedUserReposNext(
            perPage: 10,
            page: 2
        )
                                
        // 新規に読み込まれるデータ
        self.loadedMoreRepos = Array(testRepos[10..<20])
        self.loadedMoreNextLink = try .Mock.createFetchAuthenticatedUserReposNext(
            perPage: 10,
            page: 3
        )
    }
}

extension LoginUserReposListViewStateTests {
    
    /// スター済みリポジトリの追加取得_成功
    func testFetchUserReposMoreSuccess() async throws {
                                        
        func test() async throws {
            // MARK: Given
            let testData = try FetchUserReposMoreTestData()
                                    
            let repoStore: RepoStoreStub = .init(valuesDic: testData.loadedRepos.convertToValuesDic())
            repoStore.stubbedFetchAuthenticatedUserReposResponse = .init(
                items: testData.loadedMoreRepos,
                relationLink: .init(next: testData.loadedMoreNextLink)
            )
            sut = .init(
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                asyncRepoIDs: .loaded(testData.loadedRepos.map { $0.id }),
                nextLink: testData.loadedNextLink
            )
            
            // MARK: When
            let task = Task {
                await sut.handleFetchUserReposMore()
            }
            
            // MARK: Then
            await Task.yield()
            XCTAssertTrue(sut.asyncRepoIDs.isLoadingMore)
            _ = await task.value // 全処理の完了を待つ
            
            // 期待するエラー発生時の状態となっているか
            XCTAssertTrue(sut.asyncRepoIDs.isLoaded)
            XCTAssertEqual(
                sut.asyncRepoIDs.values.sorted(by: { $0 < $1 }),
                testData.testRepos.map { $0.id }.sorted(by: { $0 < $1 })
            )
            XCTAssertEqual(sut.nextLink, testData.loadedMoreNextLink)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
}
