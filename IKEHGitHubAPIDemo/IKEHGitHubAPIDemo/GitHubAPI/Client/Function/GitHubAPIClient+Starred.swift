//
//  GitHubAPIClient+Starred.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/27.
//
//  refs: https://docs.github.com/ja/rest/activity/starring?apiVersion=2022-11-28

import Foundation

extension GitHubAPIClient {
    
    func fetchStarredRepos(
        userName: String,
        sort: String? = nil,
        direction: String? = nil
    ) async throws -> StarredReposResponse {
                
        // TODO: fix
        let request = await GitHubAPIRequest.FetchStarredRepos(
            userName: userName,
            accessToken: tokenStore.accessToken,
            sort: sort,
            direction: direction
        )
        let response = try await performRequest(with: request)
        return response
    }
    
    func fetchStarredRepos(
        userName: String,
        link: RelationLink.Link
    ) async throws -> StarredReposResponse {
        let request = await GitHubAPIRequest.FetchStarredRepos(
            userName: userName,
            link: link,
            accessToken: tokenStore.accessToken
        )
        let response = try await performRequest(with: request)
        return response
    }
    
    func checkIsRepoStarred(ownerName: String, repoName: String) async throws -> Bool {
//        try await Task.sleep(nanoseconds: 10_000_000_000) // 10s待機
        let request = await GitHubAPIRequest.CheckIsRepoStarredRequest(
            accessToken: tokenStore.accessToken ?? "",
            ownerName: ownerName,
            repoName: repoName
        )
        
        do {
            try await performRequestWithoutResponse(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(error):
                if error.statusCode == 404 {
                    return false // スターされていない
                }
                throw error
            default:
                throw error
            }
        }
        return true // スター済み
    }
    
    func starRepo(ownerName: String, repoName: String) async throws {
        let request = await GitHubAPIRequest.StarRepo(
            accessToken: tokenStore.accessToken ?? "",
            ownerName: ownerName,
            repoName: repoName
        )
        print(request)
        do {
            try await performRequestWithoutResponse(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(error):
                if error.statusCode == 304 {
                    return // not modified(=成功とみなす)
                }
                throw error
            default:
                throw error
            }
        }
    }
    
    func unstarRepo(ownerName: String, repoName: String) async throws {
        let request = await GitHubAPIRequest.UnstarRepo(
            accessToken: tokenStore.accessToken ?? "",
            ownerName: ownerName,
            repoName: repoName
        )        
        do {
            try await performRequestWithoutResponse(with: request)
        } catch {
            switch error {
            case let GitHubAPIClientError.apiError(error):
                if error.statusCode == 304 {
                    return // not modified
                }
                throw error
            default:
                throw error
            }
        }
    }        
}
