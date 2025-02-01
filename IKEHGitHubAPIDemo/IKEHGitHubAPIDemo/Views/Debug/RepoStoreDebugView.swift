//
//  RepoStoreDebugView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/31.
//

import SwiftUI
import OrderedCollections

struct RepoStoreDebugView: View {
    
    @State private var repoStore = RepoStore()
    @State private var repoIDs: OrderedSet<Repo.ID> = []
    
    var repos: [Repo] {
        repoIDs
            .compactMap { repoStore.valuesDic[$0] }
            .sorted(by: { $0.id.rawValue < $1.id.rawValue })
    }
    
    var body: some View {
        
        List {
            Section() {
                Button("Add") {
                    Task {
                        do {
                            let newRepo = Repo.Mock.createRandom()
                            try await repoStore.addValue(newRepo)
                            withAnimation {
                                repoIDs.append(newRepo.id)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                Button("Delete All") {
                    Task {
                        do {
                            withAnimation {
                                repoIDs.removeAll()
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
                Button("Print") {
                    print("*** *** ***")
                    for repo in repos {
                        print(repo.id.rawValue)
                    }
                }
            }
            
            Section() {
                ForEach(repos) { repo in
                    Text("\(repo.id)")
                }
            }
        }
    }
}

#Preview {
    RepoStoreDebugView()
}

