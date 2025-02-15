//
//  StarredReposList.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/02.
//

import SwiftUI

struct StarredReposResultView: View {
    
    @State private var state: StarredRepoResultViewState = .init()
    @State private var taskId: UUID = .init()
    
    var body: some View {
        NavigationStack {
            Content(asyncRepos: state.asyncRepos, bottomRepoCellOnAppear: {
                print("load more!")
            })
            .refreshable {
//                await Task {
//                    state.handleRefresh()
//                }.value
                await state.handleRefresh()
            }
            .toolbar {
                ToolbarItem {
                    toolbarItemContentSortedBy()
                }
            }
        }
        .onAppear() {
            state.onAppear()
        }
    }
    
    @ViewBuilder
    private func toolbarItemContentSortedBy() -> some View {
        Menu {
            Picker("Sorted By", selection: $state.sortedBy) {
                ForEach(GitHubAPIRequest.StarredReposRequest.SortBy.allCases) { type in
                    Text(type.title)
                        .tag(type)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onChange(of: state.sortedBy) { _, _ in
                state.handleSortedByChanged()
//                print(state.sortedBy)
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}

// MARK: - StarredReposResultView - Content

extension StarredReposResultView {
    
    fileprivate struct Content: View {
        
        @Namespace var namespace
        
        let asyncRepos: AsyncValues<Repo, Error>
        var bottomRepoCellOnAppear: () -> Void = {}
        
        /// 検索結果がない場合のラベルを表示するか
        var showNoResultView: Bool {
            // 検索結果が0であることが前提
            if !asyncRepos.values.isEmpty {
                return false
            }
            
            // 検索済み or エラーのとき
            switch asyncRepos {
            case .loaded, .error:
                return true
            default:
                return false
            }
        }
        
        var body: some View {
            List {
                switch asyncRepos {
                case .initial, .loading:
                    skeltonView()
                case .loaded, .loadingMore, .error:
                    if showNoResultView {
                        noResultView()
                    } else {
                        starredReposList()
                        if case .loadingMore = asyncRepos {
                            lodingMoreProgressView()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Starred List")
        }
    }
}

extension StarredReposResultView.Content {
            
    @ViewBuilder
    private func skeltonView() -> some View {
        ForEach(0..<3, id: \.self) { _ in
            RepoCell(repo: Repo.Mock.sampleDataForReposCellSkelton)
                .redacted(reason: .placeholder)
                .shimmering()
                .id(UUID())
        }
    }
    
    @ViewBuilder
    private func noResultView() -> some View {
        VStack {
            Image(systemName: "star.slash")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.secondary)
                .frame(width: 36)
            Text("There are no starred repositories")
                .lineLimit(1)
                .bold()
        }
        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func starredReposList() -> some View {
        ForEach(asyncRepos.values) { repo in
            NavigationLink {
                RepoDetailsView(repoID: repo.id)
                    .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
            } label: {
                RepoCell(repo: repo)
                    .matchedTransitionSource(id:"\(repo.id)", in: namespace)
                    .onAppear {
                        if let bottomRepoID = asyncRepos.values.last?.id,
                           repo.id == bottomRepoID {
                            bottomRepoCellOnAppear()
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private func lodingMoreProgressView() -> some View {
        // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
        ProgressView("Loading...")
            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
            .frame(maxWidth: .infinity, alignment: .center)
            .id(UUID())
    }
}

// MARK: - Preview

#Preview("StarredResultView") {
    StarredReposResultView()
}

#Preview("initial") {
    StarredReposResultView.Content(asyncRepos: .initial)
}

#Preview("loading") {
    StarredReposResultView.Content(asyncRepos: .loading([]))
}

#Preview("loaded") {
    NavigationStack {
        StarredReposResultView.Content(asyncRepos: .loaded(Repo.Mock.random(count: 3)))
    }
}

#Preview("loaded_no_result") {
    StarredReposResultView.Content(asyncRepos: .loaded([]))
}

#Preview("loading-more") {
    StarredReposResultView.Content(asyncRepos: .loadingMore(Repo.Mock.random(count: 3)))
}

#Preview("error") {
    StarredReposResultView.Content(asyncRepos: .error(MessageError(description: "sample error"), []))
}

//
//import SwiftUI
//
//struct StarredRepoResultView: View {
//    
//    // MARK: - Property
//            
//    @Namespace private var namespace
//    @State private var state: StarredRepoResultViewState
//    
//    // MARK: - LifeCycle
//    
//    init(asyncRepos: AsyncValues<Repo, Error>) {
//        _state = .init(initialValue: StarredRepoResultViewState(asyncRepos: asyncRepos))
//    }
//        
//    // MARK: - View
//    
//    var body: some View {
//        let _ = print(state.asyncRepos)
//        List {
//            switch state.asyncRepos {
//            case .initial: /*.loading*/
//                skeltonView()
//            case .loading:
//                Text("Loading...")
//            case .loaded, .loadingMore, .error:
//                if state.showNoResultView {
//                    noResultView()
//                } else {
//                    starredReposList()
//                    if case .loadingMore = state.asyncRepos {
//                        lodingMoreProgressView()
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Views
//
//extension StarredRepoResultView {
//    @ViewBuilder
//    private func skeltonView() -> some View {
//        ForEach(0..<3, id: \.self) { _ in
//            RepoCell(repo: Repo.Mock.sampleDataForReposCellSkelton)
//                .redacted(reason: .placeholder)
//                .shimmering()
//        }
//        .id(UUID())
//    }
//    
//    @ViewBuilder
//    private func noResultView() -> some View {
//        VStack {
//            Image(systemName: "star.slash")
//                .resizable()
//                .scaledToFit()
//                .foregroundStyle(.secondary)
//                .frame(width: 36)
//            Text("There are no starred repositories")
//                .lineLimit(1)
//                .bold()
//        }
//        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//    }
//    
//    @ViewBuilder
//    private func starredReposList() -> some View {
//        ForEach(state.asyncRepos.values) { repo in
//            NavigationLink {
//                RepoDetailsView(repoID: repo.id)
//                    .navigationBarBackButtonHidden()
//                    .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
//            } label: {
//                RepoCell(repo: repo)
//                    .matchedTransitionSource(id:"\(repo.id)", in: namespace)
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func lodingMoreProgressView() -> some View {
//        // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
//        ProgressView("Loading...")
//            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
//            .frame(maxWidth: .infinity, alignment: .center)
//            .id(UUID())
//    }
//}
//
//// MARK: - Preview
//
//#Preview("initial") {
//    NavigationStack {
//        StarredRepoResultView(asyncRepos: .initial)
//    }
//}
//
//#Preview("loading") {
//    NavigationStack {
//        StarredRepoResultView(
//            asyncRepos: .loading([])
//        )
//    }
//}
//
//#Preview("loaded") {
//    NavigationStack {
//        StarredRepoResultView(
//            asyncRepos: .loaded(Repo.Mock.random(count: 10))
//        )
//    }
//}
//
//#Preview("loaded_no_result") {
//    NavigationStack {
//        StarredRepoResultView(asyncRepos:.loaded([]))
//    }
//}
//
//#Preview("loading_more") {
//    NavigationStack {
//        StarredRepoResultView(
//            asyncRepos: .loadingMore(Repo.Mock.random(count: 3))
//        )
//    }
//}
//
//#Preview("error") {
//    NavigationStack {
//        StarredRepoResultView(
//            asyncRepos: .error(
//                MessageError(description: "sample error"),
//                Repo.Mock.random(count: 3)
//            )
//        )
//    }
//}
//
//#Preview("error_no_result") {
//    NavigationStack {
//        StarredRepoResultView(
//            asyncRepos: .error(MessageError(description: "sample error"), [])
//        )
//    }
//}
