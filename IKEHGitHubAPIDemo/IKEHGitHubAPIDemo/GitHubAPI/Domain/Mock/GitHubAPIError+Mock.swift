//
//  GitHubAPIError+sampleData.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - Mock

extension GitHubAPIError {
    enum Mock {
        static var badCredentials: GitHubAPIError {
            .init(
                message: "Bad credentials",
                errors: nil,
                status: "401",
                documentationPath: "https://docs.github.com/rest"
            )
        }
        
        static var validationFailed: GitHubAPIError {
            .init(
                message: "Validation Failed",
                errors: [
                    .init(resource: "Search", field: "q", code: "missing")
                ],
                status: "422",
                documentationPath: "https://docs.github.com/v3/search"
            )
        }
    }
}

// MARK: - JSONString

extension GitHubAPIError.Mock {
    enum JSONString {
        static let badCredentials = """
{
  "message":"Bad credentials",
  "documentation_url":"https://docs.github.com/rest",
  "status":"401"
}
"""
        
        static let validationFailed = """
{
  "message": "Validation Failed",
  "errors": [
    {
      "resource": "Search",
      "field": "q",
      "code": "missing"
    }
  ],
  "documentation_url": "https://docs.github.com/v3/search",
  "status": "422"
}
"""
    }
}
