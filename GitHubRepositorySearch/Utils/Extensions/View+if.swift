//
//  View+if.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/27.
//

import SwiftUI

extension View {
    /// if内の条件でModifierを適用を切り替えるModifier
    /// - Note: 副作用を理解している前提で利用すること
    /// - SeeAlso: [[SwiftUI] if系extensionのmodifierは多用しない方がいい](https://zenn.dev/kntk/articles/4e3538f402d171)
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
