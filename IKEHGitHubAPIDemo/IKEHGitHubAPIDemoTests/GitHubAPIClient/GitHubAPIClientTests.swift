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
    }
    
    // MARK: - Teardown
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
    
    // MARK: - OAuth処理
    
    // MARK: - 通常処理
    
    /// リポジトリの検索: 成功
    func testSearchReposSuccess() async throws {
        
        // MARK: Given
        
        let testRepos = Repo.Mock.random(count: 10)
        let testResponse: SearchResponse<Repo> = .init(totalCount: testRepos.count, items: testRepos)
        let testData = try JSONEncoder().encode(testResponse)
        let urlSessionStub: URLSessionStub = .init(data: testData, response: .init(status: .ok))
        let tokenManagerStub: TokenStoreStub = .init()
        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)
        
        // MARK: When
        let response = try await sut.searchRepos(searchText: "Swift")
        
        // MARK: Then
        XCTAssertEqual(
            testRepos,
            response.items
        )
    }
    
    /// リポジトリの検索: 通信エラー
    func testSearchReposFailByCannotConnectTtHost() async throws {
        
        // MARK: Given

        let urlSessionStub: URLSessionStub = .init(error: URLError(.cannotConnectToHost))
        let tokenManagerStub: TokenStoreStub = .init()
        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)

        // MARK: When

        var errorIsExpected = false
        do {
            _ = try await sut.searchRepos(searchText: "Swift")
        } catch {

            // MARK: Then
            
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("unexpected error: \(error.localizedDescription)")
                return
            }
            switch clientError {
            case .connectionError:
                errorIsExpected = true
            default:
                XCTFail("unexpected error: \(error.localizedDescription)")
            }
        }
        XCTAssert(errorIsExpected, "expected error is .connectionError")
    }
    
    /// リポジトリの検索: レスポンスのデコードエラー
    func testSearchReposFailByResponseParseError() async throws {
        
        // MARK: Given
        let testData = "test message".data(using: .utf8)
        let urlSessionStub: URLSessionStub = .init(data: testData, response: .init(status: .ok))
        let tokenManagerStub: TokenStoreStub = .init()
        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)
        
        // MARK: When

        var errorIsExpected = false
        do {
            _ = try await sut.searchRepos(searchText: "Swift")
        } catch {

            // MARK: Then
            
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("unexpected error: \(error.localizedDescription)")
                return
            }
            switch clientError {
            case .responseParseError:
                errorIsExpected = true
            default:
                XCTFail("unexpected error: \(error.localizedDescription)")
            }
        }
        XCTAssert(errorIsExpected, "expected error is .responseParseError")
    }
//    
//    /// リポジトリの検索: APIからのエラーレスポンスを受け取った
//    func testSearchReposFailByGitHubAPIError() async throws {
//        
//        // MARK: Given
//        let testGitHubAPIError: GitHubAPIError = GitHubAPIError.Mock.missingQueryPatemeterError
//        let testData = try JSONEncoder().encode(testGitHubAPIError)
//        let urlSessionStub: URLSessionStub = .init(data: testData, response: .init(status: ))
//        let tokenManagerStub: TokenStoreStub = .init()
//        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)
//        
//        
//        // MARK: When
//
//        var errorIsExpected = false
//        do {
//            _ = try await sut.searchRepos(searchText: "Swift")
//        } catch {
//
//            // MARK: Then
//            
//            guard let clientError = error as? GitHubAPIClientError else {
//                XCTFail("unexpected error: \(error.localizedDescription)")
//                return
//            }
//            switch clientError {
//            case .responseParseError:
//                errorIsExpected = true
//            default:
//                XCTFail("unexpected error: \(error.localizedDescription)")
//            }
//        }
//        XCTAssert(errorIsExpected, "expected error is .responseParseError")
//    }
//    
//    
//    // MARK: - Helpers
//    
//
//        
//
//    
//    

}
