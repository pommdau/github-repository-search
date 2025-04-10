//
//  File.swift
//  GitHubAPIClient
//
//  Created by HIROKI IKEUCHI on 2025/04/15.
//

import Foundation
import GitHubAPIGraphQL
import Apollo

public final actor GitHubAPIClient: GitHubAPIClientProtocol {
    
    // MARK: - Property
    
    let clientID: String
    let clientSecret: String
    let callbackURL: URL
    let urlSession: URLSessionProtocol
    // TODO: 引数にする
    private(set) var lastLoginStateID: String = "" // 最後のログインセッションID
    private(set) var apolloClient = ApolloClient.create(accessToken: "")
        
    // MARK: - LifeCycle
    
    public init(clientID: String, clientSecret: String, callbackURL: URL, urlSession: URLSessionProtocol = URLSession.shared) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.callbackURL = callbackURL
        self.urlSession = urlSession
    }
    
    // MARK: - Setter
    
    func setLastLoginStateID(_ lastLoginStateID: String) {
        self.lastLoginStateID = lastLoginStateID
    }
    
    func setApolloClient(_ apolloClient: ApolloClient) {
        self.apolloClient = apolloClient
    }
}

extension GitHubAPIClient {
    // TODO: ApolloIOSDemo.RepositoryFieldsを別Entityに共通して変換しても良さそう
    func getRepos(user: String, apolloClient: ApolloClient) async throws -> [GitHubAPIGraphQL.RepositoryFields] {
        let query = GitHubAPIGraphQL.GetReposQuery(username: user)
        do {
            let data = try await apolloClient.fetch(query: query)
            let repos = data.user?.repositories.nodes?.compactMap { $0?.fragments.repositoryFields } ?? []
            return repos
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
