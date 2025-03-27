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
}

// MARK: - コールバックURLの受け取り処理のテスト

extension GitHubAPIClientTests {
    
    @MainActor
    func testExtactSessionCodeFromCallbackURLSuccess() async throws {

        // MARK: Given
        let urlSessionStub: URLSessionStub = .init()
        let tokenManagerStub: TokenStoreStub = .init()
        let testLastLoginStateID = UUID().uuidString
        tokenManagerStub.lastLoginStateID = testLastLoginStateID
        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)
        
        let testSessionCode = "adccb822dd897e2d470e"
        guard let testURL = URL(string: "ikehgithubapi://callback?code=\(testSessionCode)&state=\(testLastLoginStateID)") else {
            fatalError("Failed to create URL")
        }
        
        // MARK: When
        let sessionCode = try await sut.extactSessionCodeFromCallbackURL(testURL)
        
        // MARK: Then
        XCTAssertEqual(
            testSessionCode,
            sessionCode
        )
    }
    
    @MainActor
    func testExtactSessionCodeFromCallbackURLFailByInvalidURL() async throws {

        // MARK: Given
        let urlSessionStub: URLSessionStub = .init()
        let tokenManagerStub: TokenStoreStub = .init()
        let testLastLoginStateID = UUID().uuidString
        tokenManagerStub.lastLoginStateID = testLastLoginStateID
        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)
        
        // クエリパラメータのcodeが不足しているURL
        let testSessionCode = "adccb822dd897e2d470e"
        guard let testURL = URL(string: "ikehgithubapi://callback?code=\(testSessionCode)") else {
            fatalError("Failed to create URL")
        }
        
        // MARK: When
        var errorIsExpected = false
        do {
            _ = try await sut.extactSessionCodeFromCallbackURL(testURL)
        } catch {

            // MARK: Then
            
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("unexpected error: \(error.localizedDescription)")
                return
            }
            switch clientError {
            case .loginError:
                errorIsExpected = true
            default:
                XCTFail("unexpected error: \(error.localizedDescription)")
            }
        }
        XCTAssert(errorIsExpected, "error is not expected")
    }
    
    @MainActor
    func testExtactSessionCodeFromCallbackURLFailByInvalidLastLoginStateID() async throws {

        // MARK: Given
        
        let urlSessionStub: URLSessionStub = .init()
        let tokenManagerStub: TokenStoreStub = .init()
        let testLastLoginStateID = UUID().uuidString
        tokenManagerStub.lastLoginStateID = testLastLoginStateID
        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)
        
        let testSessionCode = "adccb822dd897e2d470e"
        guard let testURL = URL(string: "ikehgithubapi://callback?code=\(testSessionCode)&state=\(testLastLoginStateID)") else {
            fatalError("Failed to create URL")
        }
        
        // MARK: When
        let sessionCode = try await sut.extactSessionCodeFromCallbackURL(testURL)
        
        // MARK: Then
        XCTAssertEqual(
            testSessionCode,
            sessionCode
        )
    }
}

// MARK: - 初回トークン取得のテスト

extension GitHubAPIClientTests {
    
    /// 初回トークン取得: 成功
    @MainActor
    func testFetchInitialTokenSuccess() async throws {
        // MARK: Given
        let testResponse: FetchInitialTokenResponse = .Mock.success
        let testData = try JSONEncoder().encode(testResponse)
        let urlSessionStub: URLSessionStub = .init(data: testData, response: .init(status: .ok))
        let tokenManagerStub: TokenStoreStub = .init()
        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)
        
        // MARK: When
        try await sut.fetchInitialToken(sessionCode: "dummy code")
        
        // MARK: Then
        let accessToken = await sut.tokenStore.accessToken
        XCTAssertEqual(
            testResponse.accessToken,
            accessToken
        )
    }
    
    /// 初回トークン取得: 失敗(OAuthError)
    @MainActor
    func testFetchInitialTokenFailedByOAuthError() async throws {
        // MARK: Given
        let testResponse: OAuthError = .Mock.incorrectClientCredentials
        let testData = try JSONEncoder().encode(testResponse)
        let urlSessionStub: URLSessionStub = .init(data: testData, response: .init(status: .init(code: testResponse.statusCode!)))
        let tokenManagerStub: TokenStoreStub = .init()
        sut = .init(clientID: "", clientSecret: "", urlSession: urlSessionStub, tokenManager: tokenManagerStub)
        
        // MARK: When
        var errorIsExpected = false
        do {
            try await sut.fetchInitialToken(sessionCode: "dummy code")
        } catch {

            // MARK: Then
            
            guard let clientError = error as? GitHubAPIClientError else {
                XCTFail("unexpected error: \(error.localizedDescription)")
                return
            }
            switch clientError {
            case .oauthAPIError:
                errorIsExpected = true
            default:
                XCTFail("unexpected error: \(error.localizedDescription)")
            }
        }
        XCTAssert(errorIsExpected, "error is not expected")
    }
}

// MARK: - ログアウト



// MARK: - リポジトリの検索(成功/失敗)

extension GitHubAPIClientTests {
        
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
    func testSearchReposFailByCannotConnectToHost() async throws {
        
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
        XCTAssert(errorIsExpected, "error is not expected")
    }
    
    /// リポジトリの検索: 失敗(レスポンスのデコードエラー)
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
    
    /// リポジトリの検索: APIからのエラーレスポンスを受け取った
    func testSearchReposFailByGitHubAPIError() async throws {
        
        // MARK: Given
        
        let testGitHubAPIError: GitHubAPIError = GitHubAPIError.Mock.validationFailed
        let testData = try JSONEncoder().encode(testGitHubAPIError)
        let urlSessionStub: URLSessionStub = .init(
            data: testData,
            response: .init(status: .init(code: testGitHubAPIError.statusCode))
        )
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
            case .apiError:
                errorIsExpected = true
            default:
                XCTFail("unexpected error: \(error.localizedDescription)")
            }
        }
        XCTAssert(errorIsExpected, "expected error is .responseParseError")
    }
}
