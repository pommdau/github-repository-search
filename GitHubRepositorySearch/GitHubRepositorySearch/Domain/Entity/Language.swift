//
//  Language.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/14.
//

import SwiftUI

struct Language: Identifiable, Equatable, Sendable {
    let id: String
    var name: String
    var color: Color

    /// Initializer
    /// - Parameters:
    ///   - name: Language name
    ///   - hex: e.g.  "#00cafe"
    init(name: String, hex: String) {
        self.id = UUID().uuidString
        self.name = name
        self.color = Color(hex: hex.replacingOccurrences(of: "#", with: ""))
    }
}

// MARK: - Mock

extension Language {
    enum Mock {
        static let swift: Language = .init(name: "Swift", hex: "#F05138")
        static let python: Language = .init(name: "Python", hex: "#3572A5")
    }
}
