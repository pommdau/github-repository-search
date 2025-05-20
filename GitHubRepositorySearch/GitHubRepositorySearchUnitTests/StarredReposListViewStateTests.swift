//
//  StarredReposListViewState.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/05/13.
//

import XCTest
@testable import GitHubRepositorySearch
import ConcurrencyExtras
import IKEHGitHubAPIClient

@MainActor
final class StarredReposListViewStateTests: XCTestCase {
    
    // MARK: - Property
    
    private var sut: StarredReposListViewState!
    
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

extension StarredReposListViewStateTests {
    
    // MARK: 成功(.initialの状態から)
    func testFetchStarredReposFromInitialSuccess() async throws {
        
        func test() async throws {
            
            // MARK: Given
            
            let testStarredRepos: [IKEHGitHubAPIClient.StarredRepo] = IKEHGitHubAPIClient.StarredRepo.Mock.random(count: 10)
            let testRelationLink: RelationLink = .Mock.fetchStarredReposResponse
            let repoStore: RepoStoreStub = .init()
            repoStore.stubbedFetchStarredReposResponse = .init(
                starredRepos: testStarredRepos,
                relationLink: testRelationLink
            )
            let starredRepoStore: StarredRepoStoreStub = .init()
            
            sut = .init(
                loginUserStore: LoginUserStoreStub(loginUser: .Mock.ikeh),
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                starredRepoStore: StarredRepoStoreStub()
            )
            
            // MARK: When
            XCTAssertTrue(sut.asyncStarredRepoIDs.isInitial)
            let task = Task {
                await sut.handleFetchStarredRepos()
            }
            
            // MARK: Then
            await Task.yield()
            XCTAssertTrue(sut.asyncStarredRepoIDs.isLoading)
            _ = await task.value // 全処理の完了を待つ
            XCTAssertTrue(sut.asyncStarredRepoIDs.isLoaded)
            XCTAssertEqual(sut.asyncStarredRepoIDs.values, testStarredRepos.map { $0.id })
            XCTAssertEqual(sut.nextLinkForFetchingStarredRepos, testRelationLink.next)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    func testFetchStarredReposFromInitialFailed() async throws {
        
        func test() async throws {
            
            // MARK: Given
            
            let repoStore: RepoStoreStub = .init()
            repoStore.stubbedError = GitHubAPIClientError.apiError(.Mock.badCredentials)
            sut = .init(
                loginUserStore: LoginUserStoreStub(loginUser: .Mock.ikeh),
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                starredRepoStore: StarredRepoStoreStub()
            )
            
            // MARK: When
            
            XCTAssertTrue(sut.asyncStarredRepoIDs.isInitial)
            let task = Task {
                await sut.handleFetchStarredRepos()
            }
            
            // MARK: Then
            await Task.yield()
            XCTAssertTrue(sut.asyncStarredRepoIDs.isLoading)
            _ = await task.value // 全処理の完了を待つ
            
            // 期待するエラー発生時の状態となっているか
            XCTAssertTrue(sut.asyncStarredRepoIDs.isError)
            XCTAssertEqual(sut.asyncStarredRepoIDs.values, [])
            XCTAssertNil(sut.nextLinkForFetchingStarredRepos)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    func testFetchStarredReposFromLoading() async throws {
        
        // MARK: Given
        sut = .init(
            loginUserStore: LoginUserStoreStub(loginUser: .Mock.ikeh),
            tokenStore: TokenStoreStub(accessToken: "accessToken"),
            repoStore: RepoStoreStub(),
            starredRepoStore: StarredRepoStoreStub()
        )
        sut.asyncStarredRepoIDs = .loading([])
        
        // MARK: When
        XCTAssertTrue(sut.asyncStarredRepoIDs.isLoading)
        await sut.handleFetchStarredRepos()
        
        // MARK: Then
        XCTAssertTrue(sut.asyncStarredRepoIDs.isLoading)
    }
    
    // MARK: スター済みリポジトリの取得_開始状態が.loaded
    func testFetchStarredReposMoreFromLoaded() async throws {
                        
        func test() async throws {
            // MARK: Given
            let testData = try TestCaseData()
                                    
            let repoStore: RepoStoreStub = .init(valuesDic: testData.loadedRepos.convertToValuesDic())
            repoStore.stubbedFetchStarredReposResponse = .init(
                starredRepos: testData.loadedoMoreStarredRepos,
                relationLink: .init(next: testData.loadedMoreNextLink)
            )
            sut = .init(
                loginUserStore: LoginUserStoreStub(loginUser: .Mock.ikeh),
                tokenStore: TokenStoreStub(accessToken: "accessToken"),
                repoStore: repoStore,
                starredRepoStore: StarredRepoStoreStub(),
                asyncStarredRepoIDs: .loaded(testData.loadedStarredRepos.map { $0.repoID }),
                nextLinkForFetchingStarredRepos: testData.loadedNextLink,
            )
            
            // MARK: When
            XCTAssertTrue(sut.asyncStarredRepoIDs.isLoaded)
            XCTAssertEqual(
                sut.asyncStarredRepoIDs.values.sorted(by: { $0 < $1 }),
                testData.loadedRepos.map { $0.id }.sorted(by: { $0 < $1 })
            )
            XCTAssertEqual(sut.nextLinkForFetchingStarredRepos, testData.loadedNextLink)
            let task = Task {
                await sut.handleFetchStarredReposMore()
            }
            
            // MARK: Then
            await Task.yield()
            print(sut.asyncStarredRepoIDs)
            XCTAssertTrue(sut.asyncStarredRepoIDs.isLoadingMore)
            _ = await task.value // 全処理の完了を待つ
            
            // 期待するエラー発生時の状態となっているか
            XCTAssertTrue(sut.asyncStarredRepoIDs.isLoaded)
            XCTAssertEqual(
                sut.asyncStarredRepoIDs.values.sorted(by: { $0 < $1 }),
                testData.testRepos.map { $0.id }.sorted(by: { $0 < $1 })
            )
            XCTAssertEqual(sut.nextLinkForFetchingStarredRepos, testData.loadedMoreNextLink)
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
}
//extension Array where Element: Identifiable {
//    func convertToValuesDic() -> [Element.ID: Element] {
//        Dictionary(
//            uniqueKeysWithValues: self.map { value in
//                (value.id, value)
//            })
//    }
//}

// TODO: rename
struct TestCaseData {
    let testRepos: [Repo]
    
    // 読み込み済みのデータ
    let loadedRepos: [Repo]
    let loadedStarredRepos: [GitHubRepositorySearch.StarredRepo]
    let loadedNextLink: RelationLink.Link

    // 新規に読み込まれるデータ
    let loadedMoreRepos: [Repo]
    let loadedoMoreStarredRepos: [IKEHGitHubAPIClient.StarredRepo]
    let loadedMoreNextLink: RelationLink.Link
    
    init() throws {
        self.testRepos = Repo.Mock.random(count: 20)

        // 読み込み済みのデータ
        self.loadedRepos = Array(testRepos[0..<10])
        self.loadedStarredRepos = GitHubRepositorySearch.StarredRepo.Mock.randomWithRepos(loadedRepos)
        self.loadedNextLink  = .init(
            id: UUID().uuidString,
            url: try XCTUnwrap(URL(string: "https://api.github.com/search/repositories?q=SwiftUI&per_page=10&page=2")),
            queryItems: [
                .init(name: "q", value: "SwiftUI"),
                .init(name: "per_page", value: "10"),
                .init(name: "page", value: "2")
            ]
        )
                                
        // 新規に読み込まれるデータ
        self.loadedMoreRepos = Array(testRepos[10..<20])
        self.loadedoMoreStarredRepos = IKEHGitHubAPIClient.StarredRepo.Mock.randomWithRepos(loadedMoreRepos)
        self.loadedMoreNextLink = .init(
            id: UUID().uuidString,
            url: try XCTUnwrap(URL(string: "https://api.github.com/search/repositories?q=SwiftUI&per_page=10&page=3")),
            queryItems: [
                .init(name: "q", value: "SwiftUI"),
                .init(name: "per_page", value: "10"),
                .init(name: "page", value: "3")
            ]
        )
    }
}
