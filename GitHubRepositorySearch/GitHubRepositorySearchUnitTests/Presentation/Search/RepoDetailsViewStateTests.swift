//
//  RepoDetailsViewStateTests.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/06/09.
//

@testable import GitHubRepositorySearch
import XCTest
import ConcurrencyExtras
import IKEHGitHubAPIClient

@MainActor
final class RepoDetailsViewStateTests: XCTestCase {
    
    // MARK: - Property
    
    private var sut: RepoDetailsViewState!
    
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

// MARK: -

extension RepoDetailsViewStateTests {
    
    /// スターをつける: 成功
    func testStarSuccess() async throws {
        
        func test() async throws {
            
            // MARK: Given
            
            let testRepo = Repo.Mock.random()
            let testStarredRepo = StarredRepo(repoID: testRepo.id)
                        
            sut = .init(
                repoID: testRepo.id,
                tokenStore: TokenStoreStub(accessToken: "testAccessToken"),
                loginUserStore: LoginUserStoreStub(loginUser: .Mock.ikeh),
                repoStore: RepoStoreStub(valuesDic: [testRepo].convertToValuesDic()),
                starredRepoStore: StarredRepoStoreStub(valuesDic: [testStarredRepo].convertToValuesDic())
            )
            
            // MARK: When
            
            let task = Task {
                await sut.handleStarButtonTapped()
            }
            
            // MARK: Then
            await Task.yield()
            XCTAssertTrue(sut.isUpdatingStarred)
            _ = await task.value // 全処理の完了を待つ
            
            // スター状態の確認
            XCTAssertTrue(sut.isStarred) // スター状態がtrueになっていること
            XCTAssertEqual(sut.repo?.starsCount, testRepo.starsCount + 1) // スター数が1増えていること
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    /// スターをつける: 失敗(APIエラー)
    func testStarFailed() async throws {
        
        func test() async throws {
            
            // MARK: Given
            
            let testRepo = Repo.Mock.random()
            let testStarredRepo = StarredRepo(repoID: testRepo.id)
            let testError = GitHubAPIClientError.apiError(.Mock.badCredentials)
            
            let starredRepoStore = StarredRepoStoreStub(valuesDic: [testStarredRepo].convertToValuesDic())
            starredRepoStore.stubbedError = testError
                        
            sut = .init(
                repoID: testRepo.id,
                tokenStore: TokenStoreStub(accessToken: "testAccessToken"),
                loginUserStore: LoginUserStoreStub(loginUser: .Mock.ikeh),
                repoStore: RepoStoreStub(valuesDic: [testRepo].convertToValuesDic()),
                starredRepoStore: starredRepoStore
            )
            
            // MARK: When
            
            let task = Task {
                await sut.handleStarButtonTapped()
            }
            
            // MARK: Then
            await Task.yield()
            XCTAssertTrue(sut.isUpdatingStarred)
            _ = await task.value // 全処理の完了を待つ
            
            // スター状態の確認
            XCTAssertFalse(sut.isStarred) // スター状態がfalseのまま
            XCTAssertEqual(sut.repo?.starsCount, testRepo.starsCount) // スター数が変化していないこと
            XCTAssertNotNil(sut.error) // エラーが設定されていること
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
    
    /// スターを取り消す: 成功
    func testUnstarSuccess() async throws {
        
        func test() async throws {
            
            // MARK: Given
            
            let testRepo = Repo.Mock.random()
            let testStarredRepo = StarredRepo(repoID: testRepo.id, starredAt: ISO8601DateFormatter.shared.string(from: .now), isStarred: true)
            
            sut = .init(
                repoID: testRepo.id,
                tokenStore: TokenStoreStub(accessToken: "testAccessToken"),
                loginUserStore: LoginUserStoreStub(loginUser: .Mock.ikeh),
                repoStore: RepoStoreStub(valuesDic: [testRepo].convertToValuesDic()),
                starredRepoStore: StarredRepoStoreStub(valuesDic: [testStarredRepo].convertToValuesDic())
            )
            
            // MARK: When
            
            let task = Task {
                await sut.handleStarButtonTapped()
            }
            
            // MARK: Then
            await Task.yield()
            XCTAssertTrue(sut.isUpdatingStarred)
            _ = await task.value // 全処理の完了を待つ
            
            // スター状態の確認
            XCTAssertFalse(sut.isStarred) // スター状態がfalseになっていること
            XCTAssertEqual(sut.repo?.starsCount, testRepo.starsCount - 1) // スター数が1減っていること
        }
        
        for _ in 0..<1 {
            try await withMainSerialExecutor {
                try await test()
            }
        }
    }
}
