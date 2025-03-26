//
//  GitHubAPIClientTests.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import XCTest
@testable import IKEHGitHubAPIDemo

final class GitHubAPIClientTests: XCTestCase {
    
    // MARK: - Property
    
    private var sut: GitHubAPIClient!
    
    // MARK: - SetUp
    
    override func setUp() async throws {
        try await super.setUp()
//        sut = .init(clientID: "", clientSecret: "", urlSession: <#T##URLSession#>, tokenManager: <#T##TokenStore#>)
                
        sut = .init(clientID: "", clientSecret: "", urlSession: <#T##URLSession#>, tokenManager: TokenStoreStub())
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
