//
//  SearchReposSuggestionView.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/08.
//

import SwiftUI

struct SearchReposSuggestionView: View {
    
    // MARK: - Property
    
    private var store: SearchReposSuggestionStoreProtocol
    
    // MARK: - LifeCycle
    
    init(store: SearchReposSuggestionStoreProtocol = SearchReposSuggestionStore.shared) {
        self.store = store
    }
    
    // MARK: - View
        
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

// MARK: - Preview

#Preview {
    
    @Previewable var store = SearchReposSuggestionStoreStub(histories: ["sample1", "sample2", "sample3" ])
    
    List {
        SearchReposSuggestionView(store: store)
    }
}
