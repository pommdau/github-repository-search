//
//  GitHubAPIClient+Logout.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//

import Foundation

// MARK: - Logout

extension GitHubAPIClient {
    
    /// ログアウト処理
    func logout() async throws {
        do {            
            // サーバ上の認証情報の削除
            guard let accessToken = await tokenStore.accessToken else {
                return
            }
            let request = GitHubAPIRequest.DeleteAppAuthorization(
                clientID: clientID,
                clientSecret: clientSecret,
                accessToken: accessToken
            )
            try await self.sendRequestWithoutResponseData(with: request)
        } catch {
            // ローカル上の認証情報の削除
            // サーバ上の認証情報の削除に失敗した場合もローカルのトークン情報を削除する
            await tokenStore.deleteAll()
            throw error
        }
        
        // ローカル上の認証情報の削除
        await tokenStore.deleteAll()
    }
}
