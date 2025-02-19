//
//  Binding+.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/12.
//
//  refs: https://zenn.dev/ikeh1024/articles/60337cefd1bdad

import SwiftUI

public extension Binding {
    static func bind<T: Sendable>(
        _ value: T,
        with action: @MainActor @escaping (T) -> Void
    ) -> Binding<T> {
        Binding<T>(get: { value }, set: action)
    }
}
