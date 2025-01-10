//
//  ContentView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/01.
//

import SwiftUI
import IKEHGitHubAPI

struct ContentView: View {
    @State private var searchText = "Swift"
    @State private var repos: [Repo] = []
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter Word", text: $searchText)
                Button("Search") {
                    Task {
                        do {
                            let response = try await GitHubAPIClient.shared.searchRepos(keyword: searchText)
                            self.repos = response.items
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                .disabled(searchText.isEmpty)
            }
            .padding()
            
            List(repos) { repo in
                RepoCell(repo: repo)
                    .padding(.vertical, 4)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
