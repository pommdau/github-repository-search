//
//  GitHubAPIError.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

// ref: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#client-errors
struct GitHubAPIError: Decodable, Error {
    struct Error: Decodable {
        var resource: String
        var field: String
        var code: String
    }

    var message: String  // レスポンスのJSONに必ず含まれる
    var errors: [Error?]?
}
