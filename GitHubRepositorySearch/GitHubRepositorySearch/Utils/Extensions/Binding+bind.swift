//
//  Binding+bind.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/05/06.
//

import SwiftUI

extension Binding {
    /// Binding値のSetterで任意の処理を挟むためのUtils
    /// - SeeAlso: [.onChangeの代わりにBinding型のsetで任意の処理を実行する](https://zenn.dev/ikeh1024/articles/60337cefd1bdad)
    static func bind<T: Sendable>(
        _ value: T,
        with action: @MainActor @escaping (T) -> Void
    ) -> Binding<T> {
        Binding<T>(get: { value }, set: action)
    }
}
