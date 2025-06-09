//
//  RepoStoreTests.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/06/09.
//

@testable import GitHubRepositorySearch
import XCTest
import ConcurrencyExtras
import IKEHGitHubAPIClient

@MainActor
final class RepoStoreTests: XCTestCase {
    
    // MARK: - Property
    
    private var sut: RepoStore!
    
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

// MARK: - CRUD

extension RepoStoreTests {
    
    func testAddValuesSuccess() async throws {
     
        // MARK: Given

        let testRepos = Repo.Mock.random(count: 10)
        sut = .init(repository: nil, gitHubAPIClient: GitHubAPIClientStub())
                        
        // MARK: When/Then
        
        // 新規に値を追加
        try await sut.addValues(Array(testRepos[0...2]))
        XCTAssertEqual(sut.repos.count, 3)
        XCTAssertEqual(sut.valuesDic, Array(testRepos[0...2]).convertToValuesDic())
                      
        // 追加で値を追加、重複有り
        try await sut.addValues(testRepos)
        XCTAssertEqual(sut.repos.count, testRepos.count)
        XCTAssertEqual(Set(sut.repos), Set(testRepos))
        XCTAssertEqual(sut.valuesDic, testRepos.convertToValuesDic())
    }
    
    func testUpdateStarSuccess() async throws {
     
        // MARK: Given

        let testRepos = Repo.Mock.random(count: 10)
        let testTargetRepo = testRepos[0]
        sut = .init(repository: nil, gitHubAPIClient: GitHubAPIClientStub())
        sut.valuesDic = testRepos.convertToValuesDic()
                        
        // MARK: When
        
        try await sut.update(repoID: testTargetRepo.id, starsCount: testTargetRepo.starsCount + 1)
        
        // MARK: Then
        
        XCTAssertEqual(
            sut.repos.first(where: { $0.id == testTargetRepo.id })?.starsCount,
            testTargetRepo.starsCount + 1
        )
    }
    
    func testDeleteAllValuesSuccess() async throws {
     
        // MARK: Given

        let testRepos = Repo.Mock.random(count: 10)
        sut = .init(repository: nil, gitHubAPIClient: GitHubAPIClientStub())
        sut.valuesDic = testRepos.convertToValuesDic()
                        
        // MARK: When
        
        try await sut.deleteAllValues()
        
        // MARK: Then
        
        XCTAssertEqual(sut.repos.count, .zero)
    }
}

// MARK: - GitHub API

extension RepoStoreTests {

    func testSearchReposSuccess() async throws {
        
        // MARK: Given

        let testRepos = Repo.Mock.random(count: 10)
        let gitHubAPIClient = GitHubAPIClientStub(searchReposStubbedResponse: .success(.init(totalCount: testRepos.count, items: testRepos)))
        sut = .init(repository: nil, gitHubAPIClient: gitHubAPIClient)
                        
        // MARK: When
        
        let response = try await sut.searchRepos(
            searchText: "searchText",
            accessToken: "accessToken",
            sort: nil,
            order: nil,
            perPage: nil,
            page: nil
        )
        
        // MARK: Then
        
        XCTAssertEqual(response.items.sortedByID(), testRepos.sortedByID())
        XCTAssertEqual(sut.repos.sortedByID(), testRepos.sortedByID())
    }
    
    func testSearchReposFailed() async throws {
        
        // MARK: Given

        let gitHubAPIClient = GitHubAPIClientStub(searchReposStubbedResponse: .failure(.apiError(.Mock.badCredentials)))
        sut = .init(repository: nil, gitHubAPIClient: gitHubAPIClient)
                        
        // MARK: When
        do {
            _ = try await sut.searchRepos(
                searchText: "searchText",
                accessToken: "accessToken",
                sort: nil,
                order: nil,
                perPage: nil,
                page: nil
            )
            XCTFail("期待するエラーが検出されませんでした")
        } catch {
            // MARK: Then
            guard let _ = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
        }
    }
    
    func testFetchAuthenticatedUserReposSuccess() async throws {
        
        // MARK: Given

        let testRepos = Repo.Mock.random(count: 10)
        let gitHubAPIClient = GitHubAPIClientStub(
            fetchAuthenticatedUserReposStubbedResponse: .success(.init(items: testRepos))
        )
        sut = .init(repository: nil, gitHubAPIClient: gitHubAPIClient)
                        
        // MARK: When
        
        let response = try await sut.fetchAuthenticatedUserRepos(
            accessToken: "accessToken",
            sort: nil,
            direction: nil,
            perPage: nil,
            page: nil
        )
        
        // MARK: Then
        
        XCTAssertEqual(response.items.sortedByID(), testRepos.sortedByID())
        XCTAssertEqual(sut.repos.sortedByID(), testRepos.sortedByID())
    }
    
    func testFetchAuthenticatedUserReposSuccessa() async throws {
        
        // MARK: Given

        let testStarredRepos = IKEHGitHubAPIClient.StarredRepo.Mock.random(count: 10)
        let gitHubAPIClient = GitHubAPIClientStub(
            fetchStarredReposStubbedResponse: .success(.init(starredRepos: testStarredRepos))
        )
        sut = .init(repository: nil, gitHubAPIClient: gitHubAPIClient)
                        
        // MARK: When
        
        let response = try await sut.fetchStarredRepos(
            userName: "userName",
            accessToken: nil,
            sort: nil,
            direction: nil,
            perPage: nil,
            page: nil
        )
        
        // MARK: Then
        
        XCTAssertEqual(response.starredRepos.sortedByID(), testStarredRepos.sortedByID())
        XCTAssertEqual(sut.repos.sortedByID(), testStarredRepos.map { $0.repo }.sortedByID())
    }
}
