//
//  View+matchedGeometryEffect.swift
//  GitHubRepositorySearch
//
//  Created by HIROKI IKEUCHI on 2025/04/30.
//

import SwiftUI

/// matchedGeometryEffectのnamespaceをオプショナルで受け取るための拡張
private struct OptionalNamespaceMatchedGeometryEffect<ID>: ViewModifier where ID: Hashable {
    @Namespace var defaultNameSpace
    let id: ID
    let namespace: Namespace.ID?
        
    func body(content: Content) -> some View {
        content.matchedGeometryEffect(id: id, in: namespace ?? defaultNameSpace)
    }
}

extension View {
    func matchedGeometryEffect<ID>(id: ID, in namespace: Namespace.ID?) -> some View where ID: Hashable {
        self.modifier(OptionalNamespaceMatchedGeometryEffect(id: id, namespace: namespace))
    }
}
