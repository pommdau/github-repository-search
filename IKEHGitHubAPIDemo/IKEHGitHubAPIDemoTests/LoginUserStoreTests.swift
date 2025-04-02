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
    private var sut: LoginUserStore! // sut: System Under Test
    private let userDefaults = UserDefaults(suiteName: TokenStoreTests.userDefaultsSuiteName)!
            
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
//        sut = 
    }
}
