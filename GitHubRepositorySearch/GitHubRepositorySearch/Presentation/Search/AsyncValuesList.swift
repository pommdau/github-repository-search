////
////  AsyncValuesList.swift
////  GitHubRepositorySearch
////
////  Created by HIROKI IKEUCHI on 2025/05/08.
////
//
//import SwiftUI
//import Shimmer
//
//struct AsyncValuesList<
//    Value: Identifiable & Equatable,
//    E: Error,
//    DataView: View,
//    InitialView: View,
//    LoadingView: View,
//    NoResultView: View,
//>: View {
//    
//    // MARK: - Property
//    
//    @Namespace var namespace
//    
//    let asyncValues: AsyncValues<Value, E>
//    var initialView: InitialView
//    var loadingView: LoadingView
//    var dataView: ([Value]) -> DataView
//    var noResultView: NoResultView
//        
//    var bottomCellOnAppear: ((Value.ID) -> Void)?
//    var handlePullToRefresh: (() -> Void)?
//    
//    /// Pull to Refreshを動作させるかどうか
//    private var allowPullToRefresh: Bool {
//        if handlePullToRefresh == nil {
//            return false
//        }
//        switch asyncValues {
//        case .loaded, .error:
//            return true
//        default:
//            return false
//        }
//    }
//    
//    var showNoResultLabel: Bool {
//        // 検索結果が0であることが前提
//        if !asyncValues.values.isEmpty {
//            return false
//        }
//        
//        // 検索済み or エラーのとき
//        switch asyncValues {
//        case .loaded, .error:
//            return true
//        default:
//            return false
//        }
//    }
//    
//    // MARK: - LifeCycle
//    
//    // swiftlint:disable:next type_contents_order
//    init(
//        asyncValues: AsyncValues<Value, E>,
//        bottomCellOnAppear: @escaping (Value.ID) -> Void = { _ in },
//    ) {
//        self.asyncValues = asyncValues
//        self.bottomCellOnAppear = bottomCellOnAppear
//    }
//    
//    // MARK: - View
//    
//    var body: some View {
//        List {
//            switch asyncValues {
//            case let .loaded(values), let .loadingMore(values), let .error(_, values):
//                Group {
//                    dataView(values)
//                    if case .loadingMore = asyncValues {
//                        progressView()
//                    }
//                }
//            default:
//                EmptyView()
//            }
//        }
//        .if(allowPullToRefresh) {
//            $0.refreshable {
//                await handleRefreshable()
//            }
//        }
//        .overlay {
//            switch asyncValues {
//            case .initial:
//                initialView
//            case .loading:
//                loadingView
//            case .loaded, .loadingMore, .error:
//                if asyncValues.values.isEmpty {
//                    noResultView
//                }
//            }
//        }
//        .scrollContentBackground(.hidden)
//    }
//    
//    // MARK: - UI Parts
//    
//    @ViewBuilder
//    private func initialLabel() -> some View {
//        ContentUnavailableView("Search GitHub Repositories!", systemImage: "magnifyingglass")
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//    }
//        
//    @ViewBuilder
//    private func reposList(asyncValues: AsyncValues<Value, E>) -> some View {
////        ForEach(asyncRepos.values) { repo in
////            NavigationLink {
////                RepoDetailsView(repoID: repo.id)
////                    .navigationTransition(.zoom(sourceID: "\(repo.id)", in: namespace))
////            } label: {
////                RepoCell(repo: repo)
////                    .padding(.vertical, 4)
////                    .matchedTransitionSource(id: "\(repo.id)", in: namespace)
////                    .onAppear {
////                        // 一番したのセルが表示されたことを検出する
////                        guard let lastRepo = asyncRepos.values.last else {
////                            return
////                        }
////                        if lastRepo.id == repo.id {
////                            bottomCellOnAppear(repo.id)
////                        }
////                    }
////            }
////        }
//        Text("Hoge")
//        if case .loadingMore = asyncValues {
//            searchProgressView()
//        }
//    }
//    
//    @ViewBuilder
//    private func searchProgressView() -> some View {
//        // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
//        ProgressView()
//            .frame(maxWidth: .infinity, alignment: .center)
//            .id(UUID())
//    }
//    
//    @ViewBuilder
//    private func noResultView() -> some View {
//        Text("noResultView")
////        ContentUnavailableView.search(text: searchText)
////            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
////            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//    }
//}
//
//struct PreviewModel: Identifiable, Equatable {
//    let id: String = UUID().uuidString
//    let name: String
//}
//
////#Preview {
////    let asyncValues: AsyncValues<PreviewModel, Error> = .initial
////    AsyncValuesList(asyncValues: asyncValues)
////}

//
//  AsyncValuesView.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/27.
//
/*
 // [SwiftUI Viewの責務分離 - Speaker Deck](https://speakerdeck.com/elmetal/separation-the-responsibilities-of-swiftui-view?slide=12)
 // [非同期処理をラクにする！SwiftUIでの設計パターンの紹介](https://zenn.dev/timetree/articles/97ad70c4611894)
 */

import SwiftUI

// MARK: - AsyncValuesView

/// AsyncValuesの一覧を表示する汎用List
/// - SeeAlso:
/// [非同期処理をラクにする！SwiftUIでの設計パターンの紹介](https://zenn.dev/timetree/articles/97ad70c4611894)
/// [SwiftUI Viewの責務分離 - Speaker Deck](https://speakerdeck.com/elmetal/separation-the-responsibilities-of-swiftui-view?slide=12)
struct AsyncValuesView<
    T: Identifiable & Equatable,
    E: Error,
    DataView: View,
    InitialView: View,
    LoadingView: View,
    NoResultView: View
>: View {
    // MARK: - Property
    
    var asyncValues: AsyncValues<T, E>

    var initialView: InitialView
    var loadingView: LoadingView
    var dataView: ([T]) -> DataView
    var noResultView: NoResultView
    var handlePullToRefresh: (() -> Void)?
    
    /// Pull to Refreshを動作させるかどうか
    private var allowPullToRefresh: Bool {
        if handlePullToRefresh == nil {
            return false
        }
        switch asyncValues {
        case .loaded, .error:
            return true
        default:
            return false
        }
    }
    
    // MARK: - LifeCycle
    
    // swiftlint:disable:next type_contents_order
    init(
        asyncValuesa: AsyncValues<T, E>,
        @ViewBuilder initialView: @escaping () -> InitialView,
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder dataView: @escaping ([T]) -> DataView,
        @ViewBuilder noResultView: @escaping () -> NoResultView
    ) {
        self.asyncValues = asyncValuesa
        self.initialView = initialView()
        self.loadingView = loadingView()
        self.dataView = dataView
        self.noResultView = noResultView()
    }
    
    // MARK: - View
    
    var body: some View {
        List {
            switch asyncValues {
            case let .loaded(values), let .loadingMore(values), let .error(_, values):
                Group {
                    dataView(values)
                    if case .loadingMore = asyncValues {
                        progressView()
                    }
                }
            default:
                EmptyView()
            }
        }
        .if(allowPullToRefresh) {
            $0.refreshable {
                await handleRefreshable()
            }
        }
        .overlay {
            switch asyncValues {
            case .initial:
                initialView
            case .loading:
                loadingView
            case .loaded, .loadingMore, .error:
                if asyncValues.values.isEmpty {
                    noResultView
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func handleRefreshable() async {
        guard let handlePullToRefresh else {
            return
        }
        handlePullToRefresh()
        // クロージャを抜けるとインジケータが消えてしまうので、Sleepで生存期間を管理する
        while true {
            let isRefreshCompleted: Bool
            switch asyncValues {
            case .loaded, .error:
                isRefreshCompleted = true
            default:
                isRefreshCompleted = false
            }
            if isRefreshCompleted {
                break
            } else {
                try? await Task.sleep(for: .milliseconds(100))
            }
        }
    }
    
    @ViewBuilder
    private func progressView() -> some View {
        // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
        ProgressView<EmptyView, EmptyView>()
            .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
            .frame(maxWidth: .infinity, alignment: .center)
            .id(UUID())
    }
}

// MARK: - Preview

struct PreviewModel: Identifiable, Equatable {
    let id: String = UUID().uuidString
    let name: String
    
    static let sampleData: [PreviewModel] = [
        .init(name: "Apple"),
        .init(name: "Banana"),
        .init(name: "Lemon"),
    ]
}

private struct PreviewView: View {
    
    let asyncValues: AsyncValues<PreviewModel, Error>
    
    var body: some View {
        AsyncValuesView(asyncValuesa: asyncValues) {
            ContentUnavailableView.search
        } loadingView: {
            ProgressView("Loading...")
        } dataView: { values in
            ForEach(values) { value in
                Text(value.name)
            }
        } noResultView: {
            ContentUnavailableView.search
        }
    }
}

#Preview("initial") {
    PreviewView(asyncValues: .initial)
}

#Preview("loading") {
    PreviewView(asyncValues: .loading([]))
}

#Preview("loaded") {
    PreviewView(asyncValues: .loaded(PreviewModel.sampleData))
}

#Preview("loaded_no_result") {
    PreviewView(asyncValues: .loaded([]))
}

#Preview("loading_more") {
    PreviewView(asyncValues: .loadingMore(PreviewModel.sampleData))
}

#Preview("error") {
    PreviewView(asyncValues: .error(MessageError(description: "debug error"), PreviewModel.sampleData))
}

#Preview("error_no_result") {
    PreviewView(asyncValues: .error(MessageError(description: "debug error"), []))
}
