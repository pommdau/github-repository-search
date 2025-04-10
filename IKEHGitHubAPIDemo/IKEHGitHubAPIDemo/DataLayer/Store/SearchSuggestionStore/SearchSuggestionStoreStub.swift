//
//  SearchSuggestionStoreStub.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/04/02.
//

import SwiftUI

@MainActor
@Observable
final class SearchSuggestionStoreStub: SearchSuggestionStoreProtocol {
    
    static let shared: SearchSuggestionStoreStub = .init()
    var historySuggestions: [String]
    
    init(historySuggestions: [String] = []) {
        self.historySuggestions = historySuggestions
    }
}
