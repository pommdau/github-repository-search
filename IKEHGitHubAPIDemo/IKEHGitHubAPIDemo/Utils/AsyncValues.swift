//
//  AsyncValues.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/15.
//

import Foundation

enum AsyncValues<T: Equatable, E: Error>: Equatable {
    case initial
    case loading([T])
    case loaded([T])
    case loadingMore([T])
    case error(E, [T])

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
