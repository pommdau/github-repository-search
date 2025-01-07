//
//  ContentView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/01.
//

import SwiftUI
import IKEHGitHubAPI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Button("Debug") {
                Task {
                    do {
                        let repos = try await GitHubAPIClient.shared.searchRepos(keyword: "swift")
                        print("stop")
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            }
            Text(Omikuji().text)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
