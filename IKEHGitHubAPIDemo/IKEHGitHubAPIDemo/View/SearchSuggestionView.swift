//
//  SearchSuggestionView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/14.
//

import SwiftUI

struct SearchSuggestionView: View {
    
    @State private var searchSuggestionRepository = SearchSuggestionStore.shared
    
    var body: some View {
        Section("検索履歴") {
            if searchSuggestionRepository.historySuggestions.isEmpty {
                Text("(なし)")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(searchSuggestionRepository.historySuggestions, id: \.self) { history in
                    Label(history, systemImage: "clock")
                        .searchCompletion(history)
                        .foregroundStyle(.primary)
                    
                }
                Button("履歴のクリア") {
                    searchSuggestionRepository.removeAllHistories()
                }
                .frame(alignment: .trailing)
            }
        }
        Section("おすすめ") {
            ForEach(SearchSuggestionStore.recommendedSuggestions, id: \.self) { suggestion in
                Label(suggestion, systemImage: "magnifyingglass")
                    .searchCompletion(suggestion)
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview() {
    List {
        SearchSuggestionView()
    }
}
