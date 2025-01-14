//
//  AsyncValue.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/14.
//
//  Refs: [非同期処理をラクにする！SwiftUIでの設計パターンの紹介](https://zenn.dev/timetree/articles/97ad70c4611894)

import SwiftUI

enum AsyncValue<T, E: Error> {
    case initial /// 読み込み開始前
    case loading(T?) /// 読み込み中 or リフレッシュ中
    case loaded(T) /// 読み込み成功
    case error(E, T?) ///エラー
}

enum AsyncValues<T, E: Error> {
    case initial /// 読み込み開始前
    case loading([T]) /// 読み込み中 or リフレッシュ中
    case loaded([T]) /// 読み込み成功
    case error(E, [T]) ///エラー

    var values: [T] {
        switch self {
        case .initial:
            return []
        case let .loading(values):
            return values
        case let .loaded(values):
            return values
        case let .error(_, values):
            return values
        }
    }
}


struct AsyncValuesView<
    T,
    E: Error,
    DataView: View,
    InitialView: View,
    LoadingView: View,
    ErrorView: View
>: View {
    var values: AsyncValues<T, E>
    var dataView: ([T]) -> DataView
    var initialView: () -> InitialView
    var loadingView: ([T]) -> LoadingView
    var errorView: (E, [T]) -> ErrorView

    var body: some View {
        switch values {
        case .initial:
            initialView()
        case let .loading(elements):
            loadingView(elements)
        case let .loaded(t):
            dataView(t)
        case let .error(e, values):
            errorView(e, values)
        }
    }
}


extension AsyncValuesView {
//    /// dataViewだけ
//    init(value: AsyncValue<T, E>,
//         @ViewBuilder dataView: @escaping (T) -> DataView)
//        where InitialView == LoadingView,
//        LoadingView == ProgressView<EmptyView, EmptyView>,
//    ErrorView == EmptyView {
//        self.value = value
//        self.dataView = dataView
//        initialView = ProgressView()
//        loadingView = ProgressView()
//        errorView = { error in EmptyView() }
//    }
//
//    /// dataView, loadingView
//    /// 省略
//    /// dataView, errorView
//    /// 省略
//
//    /// dataView, loadingView, errorView
//    init(value: AsyncValue<T, E>,
//         @ViewBuilder dataView: @escaping (T) -> DataView,
//         @ViewBuilder loadingView: @escaping () -> LoadingView,
//         @ViewBuilder errorView: @escaping (E) -> ErrorView)
//        where InitialView == LoadingView {
//        self.value = value
//        self.dataView = dataView
//        initialView = loadingView()
//        self.loadingView = loadingView()
//        self.errorView = errorView
//    }
    
//    init(values: AsyncValues<T, E>,
//         @ViewBuilder dataView: @escaping ([T]) -> DataView,
//         @ViewBuilder initialView: @escaping () -> InitialView,
//         @ViewBuilder loadingView: @escaping ([T]) -> LoadingView,
//         @ViewBuilder errorView: @escaping (E, [T]) -> ErrorView)
//    {
//        self.values = values
//        self.dataView = dataView
//        self.initialView = initialView
//        self.loadingView = loadingView
//        self.errorView = errorView
//    }
    
        init(values: AsyncValues<T, E>,
             @ViewBuilder dataView: @escaping ([T]) -> DataView,
             @ViewBuilder initialView: @escaping () -> InitialView,
             @ViewBuilder errorView: @escaping (E, [T]) -> ErrorView)
             where DataView == LoadingView
        {
            self.values = values
            self.dataView = dataView
            self.initialView = initialView
            self.loadingView = dataView
            self.errorView = errorView
        }
    
}
