//
//  GitHubAPIError+sampleData.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

extension GitHubAPIError {
    enum Mock {
        static var validationFailed: GitHubAPIError {
            guard let data = JSONString.validationFailed.data(using: .utf8) else {
                fatalError("Failed to convert JSONString to Data.")
            }
            
            do {
                return try JSONDecoder().decode(GitHubAPIError.self, from: data)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}

extension GitHubAPIError.Mock {
    enum JSONString {
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
  "status": 422
}
"""
    }
}
