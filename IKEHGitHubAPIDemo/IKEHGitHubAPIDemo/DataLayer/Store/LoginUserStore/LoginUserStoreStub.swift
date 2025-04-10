//
//  LoginUserStoreStub.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/04/02.
//

import Foundation

@MainActor
@Observable
final class LoginUserStoreStub: LoginUserStoreProtocol {
    static let shared: LoginUserStoreStub = .init()
    var loginUser: LoginUser?
}
