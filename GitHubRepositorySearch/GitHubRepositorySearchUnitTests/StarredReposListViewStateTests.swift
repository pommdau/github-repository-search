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
            
            let loginUserStore: LoginUserStoreStub = .init(loginUser: .Mock.ikeh)
            let tokenStore: TokenStoreStub = .init(accessToken: "accessToken")
            let repoStore: RepoStoreStub = .init()
            repoStore.stubbedFetchStarredReposResponse = .init(
                starredRepos: testStarredRepos,
                relationLink: testRelationLink
            )
            let starredRepoStore: StarredRepoStoreStub = .init()
            
            sut = .init(
                loginUserStore: loginUserStore,
                tokenStore: tokenStore,
                repoStore: repoStore,
                starredRepoStore: starredRepoStore
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
}
