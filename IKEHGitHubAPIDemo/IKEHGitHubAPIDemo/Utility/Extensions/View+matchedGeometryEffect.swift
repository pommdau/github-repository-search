//
//  View+matchedGeometryEffect.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/06.
//

import SwiftUI

/*
 https://github.com/YusukeHosonuma/Effective-SwiftUI/discussions/31
 https://zenn.dev/kntk/articles/4e3538f402d171
 */

private struct OptionalNamespaceMatchedGeometryEffect<ID>: ViewModifier where ID: Hashable {
    @Namespace var defaultNameSpace
    let id: ID
    let namespace: Namespace.ID?
        
    func body(content: Content) -> some View {
        content.matchedGeometryEffect(id: id, in: namespace ?? defaultNameSpace)
    }
}

extension View {
    /// matchedGeometryEffectのnamespaceをオプショナルで受け取るための拡張
    func matchedGeometryEffect<ID>(id: ID, in namespace: Namespace.ID?) -> some View where ID: Hashable {
        self.modifier(OptionalNamespaceMatchedGeometryEffect(id: id, namespace: namespace))
    }
}
