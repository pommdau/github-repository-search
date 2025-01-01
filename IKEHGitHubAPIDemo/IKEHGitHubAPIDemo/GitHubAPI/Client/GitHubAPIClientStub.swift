//
//  GitHubAPIClientStub.swift
//  iOSEngineerCodeCheckTests
//
//  Created by HIROKI IKEUCHI on 2022/11/27.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// ViewModelの非同期処理を含めて確認するためのGitHubAPIServiceのStub
final class GitHubAPIClientStub: GitHubAPIClientProtocol {

    static let shared: GitHubAPIClientStub = .init()

    var searchContinuation: CheckedContinuation<[Repo], Error>?

    private init() {}

    func searchRepos(keyword: String) async throws -> [Repo] {
        try await withCheckedThrowingContinuation { continuation in
            searchContinuation = continuation
        }
    }
}
