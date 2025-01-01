//
//  GitHubAPIClientProtocol.swift
//  iOSEngineerCodeCheck
//
//  Created by HIROKI IKEUCHI on 2022/11/08.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol GitHubAPIClientProtocol {
    static var shared: Self { get }
    func searchRepos(keyword: String) async throws -> [Repo]
}
