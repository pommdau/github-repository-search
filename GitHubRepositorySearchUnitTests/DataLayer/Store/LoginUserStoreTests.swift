//
//  LoginUserStoreTests.swift
//  GitHubRepositorySearchUnitTests
//
//  Created by HIROKI IKEUCHI on 2025/06/11.
//

@testable import GitHubRepositorySearch
import XCTest
import ConcurrencyExtras
import IKEHGitHubAPIClient

/// - SeeAlso: [UserDefaultsのDIを考える](https://zenn.dev/ikeh1024/articles/679138c8ced6a9)
@MainActor
final class LoginUserStoreTests: XCTestCase {
    
    // MARK: - Property
    
    static let userDefaultsSuiteName = "LoginUserStoreTests.UserDefaults"
    private let userDefaults = UserDefaults(suiteName: LoginUserStoreTests.userDefaultsSuiteName)!
    private var sut: LoginUserStore!
    
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
        try UserDefaults.resetAndRemovePlistUserDefaults(suiteName: Self.userDefaultsSuiteName)
    }
}

// MARK: - CRUD

extension LoginUserStoreTests {
    
    /// CRUDのテスト
    func testCRUDSuccess() async throws {
        
        // MARK: Given
        
        sut = .init(userDefaults: userDefaults)
        
        // MARK: When/Then
        
        // 初期状態
        XCTAssertNil(sut.loginUser)
        
        // 追加
        let testLoginUser = LoginUser.Mock.ikeh
        sut.addValue(testLoginUser)
        XCTAssertEqual(sut.loginUser, testLoginUser)
        
        // 削除
        sut.deleteValue()
        XCTAssertNil(sut.loginUser)
    }
}
    
// MARK: - GitHub API

extension LoginUserStoreTests {
    
    /// ログインユーザ取得のテスト_成功
    func testFetchLoginUserSuccess() async throws {
        // MARK: Given
        let testLoginUser = LoginUser.Mock.ikeh
        let gitHubAPIClient = GitHubAPIClientStub(
            fetchLoginUserStubbedResponse: .success(testLoginUser)
        )
        sut = .init(userDefaults: userDefaults, gitHubAPIClient: gitHubAPIClient)
        
        // MARK: When
        try await sut.fetchLoginUser(accessToken: "accessToken")
        
        // MARK: Then
        XCTAssertEqual(sut.loginUser, testLoginUser)
    }
    
    /// ログインユーザ取得のテスト_失敗
    func testFetchLoginUserFailed() async throws {
        
        // MARK: Given
        let gitHubAPIClient = GitHubAPIClientStub(
            fetchLoginUserStubbedResponse: .failure(.apiError(.Mock.badCredentials))
        )
        sut = .init(userDefaults: userDefaults, gitHubAPIClient: gitHubAPIClient)
        
        // MARK: When
        do {
            try await sut.fetchLoginUser(accessToken: "accessToken")
            XCTFail("期待するエラーが検出されませんでした")
            return
        } catch {
            // MARK: Then
            guard let _ = error as? GitHubAPIClientError else {
                XCTFail("期待するエラーが検出されませんでした: \(error)")
                return
            }
            XCTAssertNil(sut.loginUser)
            return
        }
    }
}
    
