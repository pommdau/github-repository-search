//
//  LoginUserStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

@MainActor @Observable
final class LoginUserStore {
    
    // プロセスのライフサイクルを考えて、アプリの起動中ずっと存在してかつSingle Sourceなのでここではシングルトンとする
    static let shared: LoginUserStore = .init()

    let gitHubAPIClient: GitHubAPIClient

    // パラメータが増えたらLoginUserContextへ分離すると良さそう
    private(set) var loginUser: LoginUser? {
        didSet {
            UserDefaults.standard.setCodableItem(loginUser, forKey: "ikehgithubapi-login-user")
        }
    }
    
    init(gitHubAPIClient: GitHubAPIClient = .shared) {
        self.gitHubAPIClient = gitHubAPIClient
        self.loginUser = UserDefaults.standard.codableItem(forKey: "ikehgithubapi-login-user") // 保存されているログインユーザ情報が有れば読み込み
    }
    
    // TODO: Repository経由で取得させるようにできると、テスタブルにしやすい
    func fetchLoginUser() async throws {
        loginUser = try await gitHubAPIClient.fetchLoginUser()
    }
    
    func logOutUser() async {
        loginUser = nil
    }
}
