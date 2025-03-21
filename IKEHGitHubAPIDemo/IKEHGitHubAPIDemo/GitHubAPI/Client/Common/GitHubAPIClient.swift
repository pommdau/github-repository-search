//
//  GitHubAPIClient.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftUI

protocol GitHubAPIClientProtocol {
    static var shared: Self { get }
    func searchRepos(searchText: String, page: Int?, sort: String?, order: String?) async throws -> SearchResponse<Repo>

    func fetchStarredRepos(
        userName: String,
        sort: String?,
        direction: String?
    ) async throws -> StarredReposResponse
}

final actor GitHubAPIClientStub: GitHubAPIClientProtocol {
    static let shared: GitHubAPIClientStub = .init()
    
    var searchReposContinuation: CheckedContinuation<SearchResponse<Repo>, Error>?
    
    func searchRepos(searchText: String, page: Int? = nil, sort: String? = nil, order: String? = nil) async throws -> SearchResponse<Repo> {
        try await withCheckedThrowingContinuation { continuation in
            searchReposContinuation = continuation
        }
    }
    
    func fetchStarredRepos(
        userName: String,
        sort: String? = nil,
        direction: String? = nil
    ) async throws -> StarredReposResponse {
        return .init(repos: Repo.Mock.random(count: 10))
    }
    
}

final actor GitHubAPIClient {
    
    let clientID: String
    let clientSecret: String
    private(set) var urlSession: URLSession
    private(set) var tokenStore: TokenStore
    
    init(
        clientID: String,
        clientSecret: String,
        urlSession: URLSession = URLSession.shared,
        tokenManager: TokenStore = TokenStore.shared
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
