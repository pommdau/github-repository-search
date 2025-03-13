//
//  SearchSuggestionView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/14.
//

import SwiftUI

struct SearchSuggestionView: View {
    
    @State private var searchSuggestionStore = SearchSuggestionStore.shared
    
    var body: some View {
        Group {
            Section("検索履歴") {
                if searchSuggestionStore.historySuggestions.isEmpty {
                    Text("(なし)")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(searchSuggestionStore.historySuggestions, id: \.self) { history in
                        Label(history, systemImage: "clock")
                            .searchCompletion(history)
                            .foregroundStyle(.primary)
                        
                    }
                    /* TODO: クリア時に候補のViewが閉じてしまう
                    Button("履歴のクリア") {
                        searchSuggestionStore.removeAllHistories()
                    }
                    .frame(alignment: .trailing)
                     */
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
}

#Preview() {
    List {
        SearchSuggestionView()
    }
}
