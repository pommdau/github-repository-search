////
////  GitHubAPIClientProtocol.swift
////  GitHubRepositorySearch
////
////  Created by HIROKI IKEUCHI on 2025/04/30.
////
//
//import Foundation
//import IKEHGitHubAPIClient
//
//protocol GitHubAPIClientProtocol: Actor {
//    
//    // MARK: GitHubAPIClient+Authorization
//    
//    func openLoginPageInBrowser() async throws
//    func recieveLoginCallBackURLAndFetchAccessToken(_ url: URL) async throws -> String
//    func logout(accessToken: String) async throws
//    
//    // MARK: GitHubAPIClient+Common
//    
//    func fetchWithURL<Response: Decodable>(url: URL, accessToken: String?) async throws -> Response
//    
//    // MARK: GitHubAPIClient+FetchRepos
//    
//    func searchRepos(
//        searchText: String,
//        accessToken: String?,
//        sort: String?,
//        order: String?,
//        perPage: Int?,
//        page: Int?
//    ) async throws -> SearchResponse<Repo>
//    
//    func fetchUserRepos(
//        userName: String,
//        accessToken: String?,
//        type: String?,
//        sort: String?,
//        direction: String?,
//        perPage: Int?,
//        page: Int?
//    ) async throws -> ListResponse<Repo>
//    
//    func fetchRepo(
//        owner: String,
//        repo: String,
//        accessToken: String?
//    ) async throws -> Repo
//    
//    // MARK: GitHubAPIClient+FetchUser
//    
//    func fetchLoginUser(accessToken: String) async throws -> LoginUser
//    func fetchUser(accessToken: String, login: String) async throws -> User
//    
//    // MARK: GitHubAPIClient+Starred
//    
//    func fetchStarredRepos(
//        userName: String,
//        accessToken: String?,
//        sort: String?,
//        direction: String?,
//        perPage: Int?,
//        page: Int?,
//    ) async throws -> StarredReposResponse
//        
//    func checkIsRepoStarred(
//        accessToken: String,
//        ownerName: String,
//        repoName: String
//    ) async throws -> Bool
//    
//    func starRepo(accessToken: String, ownerName: String, repoName: String) async throws
//    func unstarRepo(accessToken: String, ownerName: String, repoName: String) async throws
//}
//
//// MARK: - デフォルト実装
//
//extension GitHubAPIClientProtocol {
//
//    // MARK: GitHubAPIClient+Authorization
//
//    func openLoginPageInBrowser() async throws {}
//
//    func recieveLoginCallBackURLAndFetchAccessToken(_ url: URL) async throws -> String {
//        return ""
//    }
//
//    func logout(accessToken: String) async throws {}
//    
//    // MARK: GitHubAPIClient+Common
//
//    func fetchWithURL<Response: Decodable>(url: URL, accessToken: String?) async throws -> Response {
//        throw MessageError(description: "Unused method")
//    }
//    
//    // MARK: GitHubAPIClient+FetchUser
//    
//    func fetchLoginUser(accessToken: String) async throws -> LoginUser {
//        throw MessageError(description: "Unused method")
//    }
//    
//    func fetchUser(accessToken: String, login: String) async throws -> User {
//        throw MessageError(description: "Unused method")
//    }
//
//    // MARK: GitHubAPIClient+FetchRepos
//
//    func searchRepos(
//        query: String,
//        accessToken: String?,
//        sort: String?,
//        order: String?,
//        perPage: Int?,
//        page: Int?
//    ) async throws -> SearchResponse<Repo> {
//        throw MessageError(description: "Unused method")
//    }
//
//    func fetchUserRepos(
//        userName: String,
//        accessToken: String?,
//        type: String?,
//        sort: String?,
//        direction: String?,
//        perPage: Int?,
//        page: Int?
//    ) async throws -> ListResponse<Repo> {
//        throw MessageError(description: "Unused method")
//    }
//
//    func fetchRepo(
//        owner: String,
//        repo: String,
//        accessToken: String?
//    ) async throws -> Repo {
//        throw MessageError(description: "Unused method")
//    }
//
//    // MARK: GitHubAPIClient+Starred
//
//    func fetchStarredRepos(
//        userName: String,
//        accessToken: String?,
//        sort: String?,
//        direction: String?,
//        perPage: Int?,
//        page: Int?,
//    ) async throws -> StarredReposResponse {
//        throw MessageError(description: "Unused method")
//    }
//
//    func checkIsRepoStarred(
//        accessToken: String,
//        owner: String,
//        repo: String
//    ) async throws -> Bool {
//        return true
//    }
//
//    func starRepo(accessToken: String, owner: String, repo: String) async throws {}
//
//    func unstarRepo(accessToken: String, owner: String, repo: String) async throws {}
//}
