//
//  AsyncValues.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//
//  refs: [非同期処理をラクにする！SwiftUIでの設計パターンの紹介](https://zenn.dev/timetree/articles/97ad70c4611894)

import Foundation

enum AsyncValues<T: Equatable, E: Error>: Equatable {
    case initial /// 読み込み開始前
    case loading([T]) /// 読み込み中 or リフレッシュ中
    case loaded([T]) /// 読み込み成功
    case loadingMore([T]) /// 追加読み込み中
    case error(E, [T]) /// エラー

    var values: [T] {
        switch self {
        case .initial:
            return []
        case let .loading(values),
             let .loaded(values),
             let .loadingMore(values),
             let .error(_, values):
            return values
        }
    }

    static func == (lhs: AsyncValues<T, E>, rhs: AsyncValues<T, E>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case let (.loading(lhsValues), .loading(rhsValues)):
            return lhsValues == rhsValues
        case let (.loaded(lhsValues), .loaded(rhsValues)):
            return lhsValues == rhsValues
        case let (.loadingMore(lhsValues), .loadingMore(rhsValues)):
            return lhsValues == rhsValues
        case let (.error(lhsError, lhsValues), .error(rhsError, rhsValues)):
            return lhsError.localizedDescription == rhsError.localizedDescription &&
                   lhsValues == rhsValues
        default:
            return false
        }
    }
}
