//
//  LoginUserStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

// classでもimmutableであれば簡単にSendableになれる
final class LoginUserContext: Sendable {
    let loginUser: LoginUser
    
    init(loginUser: LoginUser) {
        self.loginUser = loginUser
    }
}

@MainActor @Observable
final class LoginUserStore {
    
    // プロセスのライフサイクルを考えて、アプリの起動中ずっと存在してかつSingle Sourceなのでここではシングルトンとする
    static let shared: LoginUserStore = .init()
    
    private(set) var value: LoginUserContext?
    
    let gitHubAPIClient: GitHubAPIClient
    
    init(gitHubAPIClient: GitHubAPIClient = .shared) {
        self.gitHubAPIClient = gitHubAPIClient
    }
    
    // TODO: Repository経由で取得させるようにできると、テスタブルにしやすい
    func fetchLoginUser() async throws {
        let loginUser = try await gitHubAPIClient.fetchLoginUser()
        value = LoginUserContext(loginUser: loginUser)
    }
}
