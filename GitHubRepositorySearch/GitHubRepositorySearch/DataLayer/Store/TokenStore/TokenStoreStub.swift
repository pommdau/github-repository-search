//
//  TokenStoreStub.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import Foundation

final actor TokenStoreStub: TokenStoreProtocol {
    
    var accessToken: String?
    
    func openLoginPageInBrowser() async throws {}
    
    func fetchAccessTokenWithCallbackURL(_ url: URL) async throws {}
    
    func logout() async throws {
        accessToken = nil
    }
    
}
