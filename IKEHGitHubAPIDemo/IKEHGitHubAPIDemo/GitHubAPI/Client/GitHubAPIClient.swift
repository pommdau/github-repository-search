//
//  GitHubAPIClient.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftUI

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

final actor GitHubAPIClient {

    static let shared: GitHubAPIClient = .init()
    
    private(set) var urlSession: URLSession
    private(set) var tokenStore: TokenStore
            
    init(urlSession: URLSession = URLSession.shared,
         tokenManager: TokenStore = TokenStore.shared) {
        
        printUserDefaultsPath()
        
        self.urlSession = urlSession
        self.tokenStore = tokenManager
    }
}

extension GitHubAPIClient {
    func searchRepos(searchText: String, page: Int? = nil) async throws -> SearchResponse<Repo> {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        // ログイン状態であればトークンの更新
        if await tokenStore.isLoggedIn {
            try await updateAccessTokenIfNeeded()
        }
        
        let request = await GitHubAPIRequest.NewSearchRequest<Repo>(
            searchType: .repo,
            accessToken: tokenStore.accessToken,
            query: searchText,
            page: page,
            perPage: 10
        )
        let response: SearchResponse<Repo> = try await searchRequest(with: request)
        return response
    }
    
    func fetchLoginUser() async throws -> LoginUser {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        try await updateAccessTokenIfNeeded()
        guard let accessToken = await tokenStore.accessToken else {
            throw GitHubAPIClientError.oauthError("有効なトークンが見つかりませんでした")
        }
        let request = GitHubAPIRequest.FetchLoginUser(accessToken: accessToken)
        let response = try await defaultRequest(with: request)
        return response
    }
}
