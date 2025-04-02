//
//  LoginUserStoreProtocol.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/04/02.
//

import Foundation

@MainActor
protocol LoginUserStoreProtocol: AnyObject {
    // プロセスのライフサイクルを考えて、アプリの起動中ずっと存在してかつSingle Sourceなのでここではシングルトンとする
    static var shared: Self { get }
    var loginUser: LoginUser? { get set }
}

extension LoginUserStoreProtocol {
    
    // MARK: - CRUD
        
    func addValue(_ loginUser: LoginUser) {
        self.loginUser = loginUser
    }
    
    func deleteValue() {
        self.loginUser = nil
    }
}
