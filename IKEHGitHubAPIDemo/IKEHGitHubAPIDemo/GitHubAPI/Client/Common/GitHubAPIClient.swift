//
//  GitHubAPIClient.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftUI

protocol GitHubAPIClientProtocol: Actor {
    
    // MARK: - Property
    
    static var shared: Self { get }
    
//    let clientID: String
//    let clientSecret: String
//    private(set) var urlSession: URLSessionProtocol
//    private(set) var tokenStore: TokenStoreProtocol
    
    // MARK: Authorization
    
    @MainActor
    func openLoginPageInBrowser() async throws
    func handleLoginCallBackURL(_ url: URL) async throws
    func extactSessionCodeFromCallbackURL(_ url: URL) async throws -> String
    func logout() async throws
    func fetchInitialToken(sessionCode: String) async throws
    
    // MARK: - FetchRepos
    
    func searchRepos(searchText: String, page: Int?, sort: String?, order: String?) async throws -> SearchResponse<Repo>
    func fetchUserRepos(userName: String, page: Int?) async throws -> ListResponse<Repo>

    // MARK: - Starred
        
    func fetchStarredRepos( userName: String, sort: String?, direction: String?) async throws -> StarredReposResponse
    func fetchStarredRepos(userName: String, link: RelationLink.Link) async throws -> StarredReposResponse
    func checkIsRepoStarred(ownerName: String, repoName: String) async throws -> Bool
    func starRepo(ownerName: String, repoName: String) async throws
    func unstarRepo(ownerName: String, repoName: String) async throws
    
    // MARK: - User
    func fetchLoginUser() async throws -> LoginUser
    func fetchUser(login: String) async throws -> User
        
    // MARK: - Common

    func fetchWithURL<Response: Decodable>(url: URL) async throws -> Response
}

final actor GitHubAPIClientStub: GitHubAPIClientProtocol {
    
    static let shared: GitHubAPIClientStub = .init()
    
    // MARK: Authorization
    
    @MainActor
    func openLoginPageInBrowser() async throws {
        
    }
    func handleLoginCallBackURL(_ url: URL) async throws {
        
    }
    func extactSessionCodeFromCallbackURL(_ url: URL) async throws -> String {
        return ""
    }
    func logout() async throws {
        
    }
    func fetchInitialToken(sessionCode: String) async throws {
        
    }
    
    // MARK: - FetchRepos
    
    func searchRepos(searchText: String, page: Int? = nil, sort: String? = nil, order: String? = nil) async throws -> SearchResponse<Repo> {
        return .init(totalCount: 1, items: [Repo.Mock.random()])
    }
    func fetchUserRepos(userName: String, page: Int? = nil) async throws -> ListResponse<Repo> {
        return .init(items: [Repo.Mock.random()])
    }

    // MARK: - Starred
        
    func fetchStarredRepos( userName: String, sort: String? = nil, direction: String? = nil) async throws -> StarredReposResponse {
        return .init(repos: Repo.Mock.random(count: 10))
    }
    func fetchStarredRepos(userName: String, link: RelationLink.Link) async throws -> StarredReposResponse {
        return .init(repos: Repo.Mock.random(count: 10))
    }
    func checkIsRepoStarred(ownerName: String, repoName: String) async throws -> Bool {
        return true
    }
    func starRepo(ownerName: String, repoName: String) async throws {
        
    }
    func unstarRepo(ownerName: String, repoName: String) async throws {
        
    }
    
    // MARK: - User
    func fetchLoginUser() async throws -> LoginUser {
        LoginUser.Mock.ikeh
    }
    func fetchUser(login: String) async throws -> User {
        User.Mock.random()
    }
    
    // MARK: - Common
    
//    var fetchWithURLResponse<Response: Decodable>: Response?
    func fetchWithURL<Response: Decodable>(url: URL) async throws -> Response {
        let dummyData: Data = .init()
        return try JSONDecoder().decode(Response.self, from: dummyData)
    }
    
//    var searchReposContinuation: CheckedContinuation<SearchResponse<Repo>, Error>?
    
//    func searchRepos(searchText: String, page: Int? = nil, sort: String? = nil, order: String? = nil) async throws -> SearchResponse<Repo> {
//        try await withCheckedThrowingContinuation { continuation in
//            searchReposContinuation = continuation
//        }
//    }
//    
//    func fetchStarredRepos(
//        userName: String,
//        sort: String? = nil,
//        direction: String? = nil
//    ) async throws -> StarredReposResponse {
//        return .init(repos: Repo.Mock.random(count: 10))
//    }
}

final actor GitHubAPIClient: GitHubAPIClientProtocol {
    
    let clientID: String
    let clientSecret: String
    private(set) var urlSession: URLSessionProtocol
    private(set) var tokenStore: TokenStoreProtocol
    
    init(
        clientID: String,
        clientSecret: String,
        urlSession: URLSessionProtocol = URLSession.shared,
        tokenManager: TokenStoreProtocol = TokenStore.shared
    ) {        
        printUserDefaultsPath()
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.urlSession = urlSession
        self.tokenStore = tokenManager
    }
}

func printUserDefaultsPath() {
    if let bundleID = Bundle.main.bundleIdentifier {
        let preferencesPath = FileManager.default.urls(
            for: .libraryDirectory,
            in: .userDomainMask
        )
        .first?
        .appendingPathComponent("Preferences")
        .appendingPathComponent("\(bundleID).plist")
        
        if let path = preferencesPath?.path {
            print("UserDefaults file path: \(path)")
        } else {
            print("Could not determine the UserDefaults file path.")
        }
    } else {
        print("Bundle identifier not found.")
    }
}
