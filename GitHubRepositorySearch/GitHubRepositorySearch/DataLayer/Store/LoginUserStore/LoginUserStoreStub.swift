//
//  LoginUserStoreStub.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation
import struct IKEHGitHubAPIClient.LoginUser

@MainActor
@Observable
final class LoginUserStoreStub: LoginUserStoreProtocol {
                
    // MARK: - Property
        
    var loginUser: LoginUser?
    let userDefaults: UserDefaults? = nil // Stubではデータの永続化を行わないのでnil
                    
    // MARK: - LifeCycle
    
    init(loginUser: LoginUser? = nil) {
        self.loginUser = loginUser
    }
            
    // MARK: - GitHubAPI
    
    func fetchLoginUser() async throws {}
}
