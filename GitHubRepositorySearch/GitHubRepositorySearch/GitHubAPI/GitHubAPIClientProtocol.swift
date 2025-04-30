//
//  GitHubAPIClientProtocol.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import Foundation
import IKEHGitHubAPIClient

protocol GitHubAPIClientProtocol: Actor {
    
    // MARK: GitHubAPIClient+Authorization
    
    func openLoginPageInBrowser() async throws
    func recieveLoginCallBackURLAndFetchAccessToken(_ url: URL) async throws -> String
    func logout(accessToken: String) async throws
    
    // MARK: GitHubAPIClient+FetchRepos
    
    func searchRepos(
        searchText: String,
        accessToken: String?,
        sort: String?,
        order: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> SearchResponse<Repo>
    
    func fetchUserRepos(
        userName: String,
        accessToken: String?,
        type: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?
    ) async throws -> ListResponse<Repo>
    
    func fetchRepo(
        owner: String,
        repo: String,
        accessToken: String?
    ) async throws -> Repo
    
    // MARK: GitHubAPIClient+fetchWithURL
    
    func fetchWithURL<Response: Decodable>(url: URL, accessToken: String?) async throws -> Response
    
    // MARK: GitHubAPIClient+Starred
    
    func fetchStarredRepos(
        userName: String,
        accessToken: String?,
        sort: String?,
        direction: String?,
        perPage: Int?,
        page: Int?,
    ) async throws -> StarredReposResponse
        
    func checkIsRepoStarred(
        accessToken: String,
        ownerName: String,
        repoName: String
    ) async throws -> Bool
    
    func starRepo(accessToken: String, ownerName: String, repoName: String) async throws
    func unstarRepo(accessToken: String, ownerName: String, repoName: String) async throws
}
