//
//  LoginUserStore.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/23.
//

import Foundation

// TODO: check
protocol LoginUserStoreProtocol: Actor {
    var value: LoginUser? { get }
    func addValue(_ loginUser: LoginUser)
    func deleteValue()
}

@MainActor
@Observable
final class LoginUserStoreStub {
    
    static let shared: LoginUserStoreStub = .init()

    var value: LoginUser?

    func addValue(_ loginUser: LoginUser) {
        value = loginUser
    }
    
    func deleteValue() {
        value = nil
    }
}

@MainActor
@Observable
final class LoginUserStore {
    
    // MARK: - Property
    
    // プロセスのライフサイクルを考えて、アプリの起動中ずっと存在してかつSingle Sourceなのでここではシングルトンとする
    static let shared: LoginUserStore = .init()

    private(set) var value: LoginUser? {
        didSet {
            UserDefaults.standard.setCodableItem(value, forKey: "ikehgithubapi-login-user")
        }
    }
        
    // MARK: - LifeCycle

    private init() {
        self.value = UserDefaults.standard.codableItem(forKey: "ikehgithubapi-login-user") // 保存されているログインユーザ情報が有れば読み込み
    }
    
    // MARK: - CRUD
        
    func addValue(_ loginUser: LoginUser) {
        self.value = loginUser
    }
    
    func deleteValue() {
        self.value = nil
    }
}
