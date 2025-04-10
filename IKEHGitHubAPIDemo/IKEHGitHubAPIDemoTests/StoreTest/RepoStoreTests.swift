//
//  RepoStoreTests.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/04/07.
//


import XCTest
import KeychainAccess
@testable import IKEHGitHubAPIDemo

@MainActor
final class RepoStoreTests: XCTestCase {
    
    // MARK: - Property
    
    private var sut: RepoStore! // sut: System Under Test
            
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
        sut = RepoStore(repository: nil)
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
}

// MARK: - Tests

extension RepoStoreTests {
        
    /// Create/Updateのテスト
    func testAddValuesSuccess() async throws {
                                                
        // MARK: Given
        XCTAssertEqual(sut.valuesDic.count, 0)
        
        // MARK: When
        let testRepos = Repo.Mock.random(count: 10)
        try await sut.addValues(testRepos, updateStarred: false)

        // MARK: Then
        // 登録数の確認
        XCTAssertEqual(sut.valuesDic.count, testRepos.count)
    }
    
    /// Create/Updateのテスト(スター情報の更新を含む)
    func testAddValuesWithUpdateStarredSuccess() async throws {
                                                
        // MARK: Given
        
        // 初期値の設定
        let initialRepos = Repo.Mock.random(count: 10)
        sut.valuesDic = Dictionary(uniqueKeysWithValues: initialRepos.map { ($0.id, $0) })
        
        // MARK: When
        
        // 登録済みの情報から、スター情報のみを更新したテストデータを用意
        let testRepos: [Repo] = initialRepos.map { repo in
            var repo = repo
            repo.isStarred.toggle()
            repo.starredAt = ISO8601DateFormatter.shared.string(from: .now)
            return repo
        }
        try await sut.addValues(testRepos, updateStarred: true)

        // MARK: Then
        
        // 登録数の確認
        XCTAssertEqual(sut.valuesDic.count, initialRepos.count)
        // スターの状態の確認
        testRepos.forEach { testRepo in
            guard let repo = sut.valuesDic[testRepo.id] else {
                XCTFail("Faild to find repo: \(testRepo.id)")
                return
            }
            XCTAssertEqual(repo.isStarred, testRepo.isStarred)
            XCTAssertEqual(repo.starredAt, testRepo.starredAt)
        }
    }
              
    ///  Deleteのテスト
    func testDeleteValueSuccess() async throws {
                                                
        // MARK: Given
        try await sut.addValues(Repo.Mock.random(count: 10), updateStarred: false)
        
        // MARK: When
        try await sut.deleteAllValues()

        // MARK: Then
        XCTAssertEqual(sut.valuesDic.count, .zero)
    }
}
