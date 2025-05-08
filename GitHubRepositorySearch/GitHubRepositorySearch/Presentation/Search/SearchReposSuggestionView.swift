//
//  SearchReposSuggestionView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import SwiftUI

struct SearchReposSuggestionView: View {
    
    @State private var store = SearchReposSuggestionStore.shared
    
    var body: some View {
        Group {
            Section("History") {
                if store.histories.isEmpty {
                    Text("(Empty)")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(store.histories, id: \.self) { history in
                        Label(history, systemImage: "clock")
                            .searchCompletion(history)
                            .foregroundStyle(.primary)
                        
                    }
                    .onDelete { indexPath in
                        store.removeValue(atOffsets: indexPath)
                    }
                }
            }
            
            Section("Recommend") {
                ForEach(store.recommendedSuggestions, id: \.self) { suggestion in
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
        SearchReposSuggestionView()
    }
}
