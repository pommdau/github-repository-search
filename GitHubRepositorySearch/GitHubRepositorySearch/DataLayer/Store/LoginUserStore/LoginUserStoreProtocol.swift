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

    // MARK: - Property

    var loginUser: LoginUser? { get set }
    var userDefaults: UserDefaults? { get }

    // MARK: - GitHubAPI

    func fetchLoginUser() async throws
}

// MARK: - CRUD

extension LoginUserStoreProtocol {
    
    // MARK: Create / Update
    
    func addValue(_ loginUser: LoginUser) {
        self.loginUser = loginUser
        userDefaults?.setCodableItem(loginUser, forKey: UserDefaults.Key.LoginUserStore.loginUser)
    }

    // MARK: Read

    func fetchValue() {
        loginUser = userDefaults?.codableItem(forKey: UserDefaults.Key.LoginUserStore.loginUser)
    }

    // MARK: Delete
    
    func deleteValue() {
        loginUser = nil
        userDefaults?.set(nil, forKey: UserDefaults.Key.LoginUserStore.loginUser)
    }
}
