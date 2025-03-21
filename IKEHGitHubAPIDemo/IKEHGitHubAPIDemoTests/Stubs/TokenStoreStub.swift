//
//  TokenStoreStub.swift
//  IKEHGitHubAPIDemoTests
//
//  Created by HIROKI IKEUCHI on 2025/03/21.
//

import Foundation
import Foundation

@MainActor
protocol TokenStoreProtocol: AnyObject {
    var accessToken: String? { get set }
    var accessTokenExpiresAt: Date? { get set }
    var isAccessTokenValid: Bool { get }
    var lastLoginStateID: String { get set }

    func updateTokens(accessToken: String?, accessTokenExpiresAt: Date?)
    func updateLastLoginStateID(_ setLastLoginStateID: String)
    func deleteAll()
}
