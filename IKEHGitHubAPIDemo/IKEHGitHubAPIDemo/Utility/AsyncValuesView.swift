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

// swiftlint:disable:next file_types_order
struct AsyncValuesView<
    T: Equatable,
    E: Error,
    DataView: View,
    InitialView: View,
    LoadingView: View,
    NoResultView: View
//    LoadingMoreProgress: View
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

private struct PreviewView: View {
    
    let asyncValues: AsyncValues<String, Error>
    
    var body: some View {
        AsyncValuesView(asyncValuesa: asyncValues) {
            ContentUnavailableView.search
        } loadingView: {
            ProgressView()
        } dataView: { values in
            ForEach(values, id: \.self) { value in
                Text(value)
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
    PreviewView(asyncValues: .loaded(["Apple", "Banana", "Lemon"]))
}

#Preview("loaded_no_result") {
    PreviewView(asyncValues: .loaded([]))
}

#Preview("loading_more") {
    PreviewView(asyncValues: .loadingMore(["Apple", "Banana", "Lemon"]))
}

#Preview("error") {
    PreviewView(asyncValues: .error(MessageError(description: "debug error"), ["Apple", "Banana", "Lemon"]))
}

#Preview("error_no_result") {
    PreviewView(asyncValues: .error(MessageError(description: "debug error"), []))
}
