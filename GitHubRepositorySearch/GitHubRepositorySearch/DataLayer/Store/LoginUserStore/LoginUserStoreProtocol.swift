//
//  LoginUserStoreProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation
import struct IKEHGitHubAPIClient.LoginUser

@MainActor
protocol LoginUserStoreProtocol: AnyObject {
    var loginUser: LoginUser? { get set }
    func fetchLoginUser() async throws
}

// MARK: - CRUD

extension LoginUserStoreProtocol {
    func addValue(_ loginUser: LoginUser) {
        self.loginUser = loginUser
    }
    func deleteValue() {
        self.loginUser = nil
    }
}
