//
//  TokenStoreTests.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/18.
//

import XCTest
import KeychainAccess
@testable import IKEHGitHubAPIDemo

extension UserDefaults {
    static func plistURL(suitName: String) -> URL? {
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return nil
        }
        return libraryURL
            .appendingPathComponent("Preferences")
            .appendingPathComponent("\(suitName).plist")
    }
}

final class TokenStoreTests: XCTestCase {
    
    // MARK: - Property
    
    
    static let userDefaultsSuiteName = "TokenStoreTests"
    private var sut: TokenStore! // sut: System Under Test
    private let keyChain = Keychain(service: "TokenStoreTests")
    private let userDefaults = UserDefaults(suiteName: TokenStoreTests.userDefaultsSuiteName)!
            
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
        sut = TokenStore(
            keyChain: keyChain,
            userDefaults: userDefaults
        )
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
        try keyChain.removeAll()
        try resetUserDefaultsForTest(suitName: Self.userDefaultsSuiteName)
    }
    
    func resetUserDefaultsForTest(suitName: String) throws {
        /*
         https://developer.apple.com/documentation/foundation/userdefaults/1417339-removepersistentdomain
         removeObject(forKey:)を回すのと同等の処理
         */
        // 保存した値の削除
        UserDefaults().removePersistentDomain(forName: suitName)
        
        // plistファイルの削除(removePersistentDomainではキー/値の削除しかされないため)
        if let url = UserDefaults.plistURL(suitName: suitName),
           FileManager.default.fileExists(atPath: url.path()) {
            try FileManager.default.removeItem(at: url)
        }
    }
                
}

// MARK: - Tests

extension TokenStoreTests {
    
    // MARK: - トークン/有効期限の更新のテスト

    /// アクセストークンと有効期限の更新
    func testUpdateAccessTokenAndExpiresAt() async throws {
        
        // MARK: Given
        let testAccessToken = "test_access_token"
        let testAccessTokenExpiresAt = Date().addingTimeInterval(60 * 60 * 24)

        // MARK: When
        await sut.updateTokens(
            accessToken: testAccessToken,
            accessTokenExpiresAt: testAccessTokenExpiresAt
        )

        // MARK: Then
        let retrievedToken = await sut.accessToken
        let retrievedAccessTokenExpiresAt = await sut.accessTokenExpiresAt
        XCTAssertEqual(retrievedToken, testAccessToken)
        XCTAssertEqual(retrievedAccessTokenExpiresAt, testAccessTokenExpiresAt)
    }

    /// アクセストークンが有効期限内
    func testUpdateAccessTokenAndValidateSuccess() async throws {
        // MARK: Given
        let testAccessToken = "test_access_token"
        let testAccessTokenExpiresAt = Date().addingTimeInterval(60 * 60 * 24)

        // MARK: When
        await sut.updateTokens(
            accessToken: testAccessToken,
            accessTokenExpiresAt: testAccessTokenExpiresAt
        )

        // MARK: Then
        let retrievedIsAccessTokenValid = await sut.isAccessTokenValid
        XCTAssertTrue(retrievedIsAccessTokenValid)
    }
    
    /// アクセストークンが有効期限外
    func testUpdateAccessTokenAndValidateFail() async throws {
        // MARK: Given
        let testAccessToken = "test_access_token"
        let testAccessTokenExpiresAt = Date().addingTimeInterval(-10)

        // MARK: When
        await sut.updateTokens(
            accessToken: testAccessToken,
            accessTokenExpiresAt: testAccessTokenExpiresAt
        )

        // MARK: Then
        let retrievedIsAccessTokenValid = await sut.isAccessTokenValid
        XCTAssertFalse(retrievedIsAccessTokenValid)
    }

    // MARK: - ログインIDの更新のテスト

    func testUpdateLastLoginStateID() async throws {
        
        // MARK: Given
        let testLastLoginStateID = "test_state_id"

        // MARK: When
        await sut.updateLastLoginStateID(testLastLoginStateID)

        // MARK: Then
        let retrievedStateID = await sut.lastLoginStateID
        XCTAssertEqual(retrievedStateID, testLastLoginStateID)
    }

    // MARK: - 情報の削除のテスト
    
    func testDeleteAll() async throws {
        
        // MARK: Given
        let testAccessToken = "test_access_token"
        let testAccessTokenExpiresAt = Date().addingTimeInterval(60 * 60 * 24)

        // MARK: When
        await sut.updateTokens(
            accessToken: testAccessToken,
            accessTokenExpiresAt: testAccessTokenExpiresAt
        )
        await sut.deleteAll()

        // MARK: Then
        let retrievedToken = await sut.accessToken
        let retrievedAccessTokenExpiresAt = await sut.accessTokenExpiresAt
        XCTAssertNil(retrievedToken)
        XCTAssertNil(retrievedAccessTokenExpiresAt)
    }
}
