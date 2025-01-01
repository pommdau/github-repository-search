//
//  GitHubAPIError+sampleData.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

extension GitHubAPIError {
    static let sampleData: [GitHubAPIError] = [
        .init(message: "API rate limit exceeded for 121.112.2.169. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)\",\"documentation_url\":\"https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting")
    ]
    
    static var missingQueryPatemeterError: GitHubAPIError {        
        .init(message: "Validation Failed",
              errors: [
                .init(resource: "Search", field: "q", code: "missing")
              ]
        )
    }
}
