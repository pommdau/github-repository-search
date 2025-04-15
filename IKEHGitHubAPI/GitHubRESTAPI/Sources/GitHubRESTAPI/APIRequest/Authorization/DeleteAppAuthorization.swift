//
//  DeleteAppAuthorization.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//
//  refs: https://docs.github.com/ja/rest/apps/oauth-applications?apiVersion=2022-11-28#delete-an-app-authorization

import Foundation
import HTTPTypes

public extension GitHubRESTAPIRequest {
    struct DeleteAppAuthorization {
        var clientID: String
        var clientSecret: String
        var accessToken: String
        
        public init(clientID: String, clientSecret: String, accessToken: String) {
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.accessToken = accessToken
        }
    }
}

extension GitHubRESTAPIRequest.DeleteAppAuthorization: GitHubRESTAPIRequestProtocol {

    public typealias Response = NoBodyResponse
    
    public var method: HTTPTypes.HTTPRequest.Method {
        .delete
    }
    
    public var baseURL: URL? {
        GitHubRESTAPIEndpoints.apiBaseURL
    }
    
    public var path: String {
        "/applications/\(clientID)/grant"
    }
    
    public var queryItems: [URLQueryItem] {
        []
    }
    
    public var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        headerFields[.authorization] = HTTPField.ConstValue.aurhorization(clientID: clientID, clientSecret: clientSecret)
        headerFields[.contentType] = HTTPField.ConstValue.applicationJSON
        headerFields[.accept] = HTTPField.ConstValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstValue.xGitHubAPIVersion
        return headerFields
    }
    
    public var body: Data? {
        let body: [String: String] = [
            "access_token": accessToken
        ]
        do {
            return try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            assertionFailure("Failed to serialize JSON: \(error)")
            return nil
        }
    }
}
