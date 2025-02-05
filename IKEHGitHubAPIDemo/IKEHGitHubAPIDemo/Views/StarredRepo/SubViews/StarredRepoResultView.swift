////
////  StarredReposList.swift
////  IKEHGitHubAPIDemo
////
////  Created by HIROKI IKEUCHI on 2025/02/02.
////
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
