//
//  LoginUserStoreTests.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/04/02.
//

import XCTest
@testable import IKEHGitHubAPIDemo

final class LoginUserStoreTests: XCTestCase {

    // MARK: - Property
    
    static let userDefaultsSuiteName = "LoginUserStoreTests.UserDefaults"
    private let userDefaults = UserDefaults(suiteName: TokenStoreTests.userDefaultsSuiteName)!
    private var sut: LoginUserStore! // sut: System Under Test
            
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
        sut = await LoginUserStore(userDefaults: userDefaults)
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
        try UserDefaults.resetAndRemovePlistUserDefaults(suiteName: Self.userDefaultsSuiteName)
    }
}

// MARK: - Tests

extension LoginUserStoreTests {
    
    /// CRUDのテスト
    func testCRUDSuccess() async throws {
                
        var loginUser: LoginUser?
               
        // MARK: - 初期状態
        loginUser = await sut.loginUser
        XCTAssertEqual(loginUser, nil)
        
        // MARK: - 追加
        let testLoginUser = LoginUser.Mock.ikeh
        await sut.addValue(testLoginUser)
        loginUser = await sut.loginUser
        XCTAssertEqual(loginUser, testLoginUser)
        
        // MARK: 削除
        await sut.deleteValue()
        loginUser = await sut.loginUser
        XCTAssertEqual(loginUser, nil)
    }
}
