//
//  ApolloClientCustomError.swift
//  ApolloIOSDemo
//
//  Created by HIROKI IKEUCHI on 2025/03/04.
//

import Foundation

enum ApolloClientCustomError: Error {
    case isResultDataNil
}

extension ApolloClientCustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .isResultDataNil:
            return "Result data is nil"
        }
    }
}
