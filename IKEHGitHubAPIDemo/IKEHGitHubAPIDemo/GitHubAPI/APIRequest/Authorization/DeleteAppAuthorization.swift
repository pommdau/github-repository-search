//
//  DeleteAppAuthorization.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/22.
//
//  refs: https://docs.github.com/ja/rest/apps/oauth-applications?apiVersion=2022-11-28#delete-an-app-authorization

import Foundation
import HTTPTypes

extension GitHubAPIRequest {
    struct DeleteAppAuthorization {
        var clientID: String
        var clientSecret: String
        var accessToken: String
    }
}

extension GitHubAPIRequest.DeleteAppAuthorization: GitHubAPIRequestProtocol {

    typealias Response = String // 実際には不使用
    
//    var responseFailType: ResponseFailType {        
//        .responseBody
//    }
    
    var method: HTTPTypes.HTTPRequest.Method {
        .delete
    }
    
    var baseURL: URL? {
        URL(string: "https://api.github.com")
    }
    
    var path: String {
        "/applications/\(clientID)/grant"
    }
    
    var queryItems: [URLQueryItem] {
        []
    }
    
    var header: HTTPTypes.HTTPFields {
        var headerFields = HTTPTypes.HTTPFields()
        if let authorizationValue = "\(clientID):\(clientSecret)".data(using: .utf8)?.base64EncodedString() {
            headerFields[.authorization] = "Basic \(authorizationValue)"
        }
        headerFields[.contentType] = HTTPField.ConstantValue.applicationJSON
        headerFields[.accept] = HTTPField.ConstantValue.applicationVndGitHubJSON
        headerFields[.xGithubAPIVersion] = HTTPField.ConstantValue.xGitHubAPIVersion
        return headerFields
    }
    
    var body: Data? {
        let body: [String: String] = [
            "access_token": accessToken
        ]
        do {
            return try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON: \(error)")
            return nil
        }
    }
}
