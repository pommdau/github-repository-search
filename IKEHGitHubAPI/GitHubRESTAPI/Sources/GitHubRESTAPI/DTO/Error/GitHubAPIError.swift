//
//  GitHubAPIError.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//
//  ref: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#client-errors

import Foundation

public struct GitHubAPIError: Sendable, Codable, Error, LocalizedError {
    
    enum CodingKeys: String, CodingKey {
        case message
        case errors
        case status
        case documentationPath = "documentation_url"
    }
        
    // TODO: 要確認
    struct Error: Codable {
        var resource: String
        var field: String
        var code: String
    }
    
    // MARK: - Property
    
    var message: String  // レスポンスのJSONに必ず含まれる
    var errors: [Error?]?
    var status: String
    var documentationPath: String
    
    var statusCode: Int? {
        guard let statusCode = Int(status) else {
            assertionFailure()
            return nil
        }
        return statusCode
    }
    
    // MARK: - LocalizedError
    
    var errorDescription: String {
        return message
    }
}
