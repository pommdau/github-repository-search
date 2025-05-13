//
//  StarredReposListViewState.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/05/13.
//

import XCTest
@testable import GitHubRepositorySearch

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
    
    // MARK: 成功
    func testFetchStarredReposSuccess() async {
        
        // MARK: Given
        let loginUserStore: LoginUserStoreStub = .init()
        let tokenStore: TokenStoreStub = .init()
        let repoStore: RepoStoreStub = .init()
        let starredRepoStore: StarredRepoStoreStub = .init()
        
        sut = .init(
            loginUserStore: loginUserStore,
            tokenStore: tokenStore,
            repoStore: repoStore,
            starredRepoStore: starredRepoStore
        )
        
        // MARK: When
        sut.fetchStarredRepos()
                                                
        // MARK: Then
        
        switch sut.asyncStarredRepoIDs {
        case .initial:
            break
        default:
            XCTFail("unexpected asyncStarredRepoIDs: \(sut.asyncStarredRepoIDs)")
        }
    }
}
