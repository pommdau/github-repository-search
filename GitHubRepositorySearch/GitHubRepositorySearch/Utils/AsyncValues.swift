//
//  AsyncValues.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//
//  refs:

import Foundation

/// 非同期処理の状態を含む配列の型を定義
/// - SeeAlso: [非同期処理をラクにする！SwiftUIでの設計パターンの紹介](https://zenn.dev/timetree/articles/97ad70c4611894)
enum AsyncValues<T: Equatable, E: Error> {
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
}

extension AsyncValues: Equatable {
    
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

/// 型判定のためのUtils
/// - SeeAlso: [associated values抜きでのenumの比較をスマートにしたい #Swift - Qiita](https://qiita.com/kntkymt/items/b73f74c29fd4e399b6b7)
extension AsyncValues {
    
    var isInitial: Bool {
        if case .initial = self {
            return true
        }
        return false
    }
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var isLoaded: Bool {
        if case .loaded = self {
            return true
        }
        return false
    }
    
    var isLoadingMore: Bool {
        if case .loadingMore = self {
            return true
        }
        return false
    }
    
    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
}
