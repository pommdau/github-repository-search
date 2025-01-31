////
////  StarredRepoView.swift
////  IKEHGitHubAPIDemo
////
////  Created by HIROKI IKEUCHI on 2025/01/25.
////
//
//import SwiftUI
//
//@MainActor @Observable
//final class StarredRepoViewState {
//    
//    let githubAPIClient: GitHubAPIClient
//    let starredRepoStore: StarredRepoStore
//    
//    init(githubAPIClient: GitHubAPIClient = .shared, starredRepoStore: StarredRepoStore) {
//        self.githubAPIClient = githubAPIClient
//        self.starredRepoStore = starredRepoStore
//    }
//    
//    convenience init() {
//        self.init(starredRepoStore: StarredRepoStore.shared)
//    }
//        
//    var repos: [Repo] {
//        starredRepoStore.values
//    }
//    
//    func handleFetchButtonTapped() {
//        Task {
//            do {
//                let response = try await githubAPIClient.fetchStarredRepos()
//                try await starredRepoStore.addValue(response.items.first!)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func handleAddButtonTapped() {
//        Task {
//            let newRepo = Repo.sampleData[Int.random(in: 0...10)]
//            try await starredRepoStore.addValue(newRepo)
//        }
//    }
//    
//    func handleDeleteButtonTapped() {
//        Task {
//            try await starredRepoStore.deleteValues(starredRepoStore.values)
//        }
//    }
//    
//    func onAppear() {
//        Task {
//            do {
//                try await starredRepoStore.loadAllValues()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
//
//struct StarredRepoView: View {
//    
//    @State private var viewState: StarredRepoViewState = .init()
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                
//                Button("Fetch") {
//                    viewState.handleFetchButtonTapped()
//                }
//                
//                Button("Add") {
//                    viewState.handleAddButtonTapped()
//                }
//                
//                Button("Delete All") {
//                    viewState.handleDeleteButtonTapped()
//                }
//                
//                ForEach(viewState.repos) { repo in
//                    NavigationLink {
//                        RepoDetailsView(repo: repo)
//                    } label: {
//                        RepoCell(repo: repo)
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    StarredRepoView()
//}
