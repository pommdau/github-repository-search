//
//  GitHubAPIClient.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/07.
//

import Foundation
import SwiftUI

final actor GitHubAPIClient {

    static let shared: GitHubAPIClient = .init()
    
    private(set) var urlSession: URLSession
    private(set) var tokenStore: TokenStore
            
    init(urlSession: URLSession = URLSession.shared,
         tokenManager: TokenStore = TokenStore.shared) {
        
        printUserDefaultsPath()
        
        self.urlSession = urlSession
        self.tokenStore = tokenManager
    }
}

func printUserDefaultsPath() {
    if let bundleID = Bundle.main.bundleIdentifier {
        let preferencesPath = FileManager.default.urls(
            for: .libraryDirectory,
            in: .userDomainMask
        )
        .first?
        .appendingPathComponent("Preferences")
        .appendingPathComponent("\(bundleID).plist")
        
        if let path = preferencesPath?.path {
            print("UserDefaults file path: \(path)")
        } else {
            print("Could not determine the UserDefaults file path.")
        }
    } else {
        print("Bundle identifier not found.")
    }
}
